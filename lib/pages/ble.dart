import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crclib/catalog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class BlePage extends StatefulWidget {
  const BlePage({Key? key}) : super(key: key);

  @override
  State<BlePage> createState() => _BlePageState();
}

class _BlePageState extends State<BlePage> {
  final flutterReactiveBle = FlutterReactiveBle();
  final List<DiscoveredDevice> devs = [];

  DiscoveredDevice? connetDev;
  StreamSubscription<ConnectionStateUpdate>? sub;

  Future scan() async {
    print("开始扫描");
    flutterReactiveBle.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      if (devs.indexWhere((element) => element.id == device.id) < 0) {
        setState(() {
          devs.add(device);
        });
      }
    }, onError: (err) {
      print("扫描错误: $err");
    });
  }

  clickDev(DiscoveredDevice dev) {
    sub = flutterReactiveBle
        .connectToDevice(
      id: dev.id,
      connectionTimeout: const Duration(seconds: 10),
    )
        .listen(
      (event) {
        if (event.connectionState == DeviceConnectionState.connected) {
          Fluttertoast.showToast(msg: "设备已连接");
          setState(() {
            connetDev = dev;
          });
        } else {
          setState(() {
            connetDev = null;
          });
          if (event.connectionState == DeviceConnectionState.disconnected) {
            Fluttertoast.showToast(msg: "连接已断开");
          }
        }
      },
    );
  }

  update(String devId) {}

  @override
  void initState() {
    Permission.location.request().then((value) {
      if (value.isDenied) {
        Fluttertoast.showToast(msg: "没得权限无法正常运行");
      }
    });
    flutterReactiveBle.initialize();
    super.initState();
  }

  @override
  void dispose() {
    flutterReactiveBle.deinitialize();
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("蓝牙安装")),
      body: connetDev != null
          ? _ConnectState(device: connetDev!, ble: flutterReactiveBle)
          : Column(
              children: [
                ElevatedButton(onPressed: scan, child: const Text("扫描设备")),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      var dev = devs[index];
                      return GestureDetector(
                        onTap: () => clickDev(dev),
                        child: Text("${dev.id}[${dev.name}]"),
                      );
                    },
                    itemCount: devs.length,
                  ),
                ),
              ],
            ),
    );
  }
}

class _ConnectState extends StatefulWidget {
  final DiscoveredDevice device;
  final FlutterReactiveBle ble;
  const _ConnectState({Key? key, required this.device, required this.ble})
      : super(key: key);

  @override
  State<_ConnectState> createState() => __ConnectStateState();
}

class __ConnectStateState extends State<_ConnectState> {
  ValueNotifier<String> customWatchPath = ValueNotifier("");
  ValueNotifier<String> selectName = ValueNotifier(""); // 已选择的表盘
  Stream<List<int>>? stream;

  getBettery() async {
    var chara = await findCharacteristic("0000180f", "00002a19");
    var res = await widget.ble.readCharacteristic(chara);

    print("电池电量${res[0]}");
  }

  getHeart() async {
    var sub = await findCharacteristic("0000180d", "00002a37");
    var ble = widget.ble;
    ble.subscribeToCharacteristic(sub).listen((event) {
      print("心率:$event");
    }, onError: (err) {
      print("心率订阅错误: $err");
    });
    print("完成操作");
  }

  Future<List<int>> awaitRes() {
    if (stream == null) throw Exception("未订阅");
    Completer<List<int>> c = Completer();
    StreamSubscription? sub;
    sub = stream?.listen((event) {
      c.complete(event);
      sub!.cancel();
    });
    return c.future;
  }

  String print16hex(List<int> data) {
    return data
        .map((e) => e.toRadixString(16).padLeft(2, "0"))
        .toList()
        .toString();
  }

  start() async {
    var char = await findCharacteristic("00001530", "00001531");
    var charWiret = await findCharacteristic("00001530", "00001532");
    stream = widget.ble.subscribeToCharacteristic(char).asBroadcastStream();
    var file = File(customWatchPath.value);
    var bytes = await file.readAsBytes();
    var crc = Crc32().convert(bytes).toBigInt();
    print("crc: $crc");
    final bytesBuilder = BytesBuilder();
    bytesBuilder.add([0xd2, 0x08]);
    // 将长度转换为3个字节大小的16进制字符串
    var hexStr = bytes.length.toRadixString(16).padLeft(6, "0");
    bytesBuilder.add(hexStrToUint8ListBeLittle(hexStr));
    bytesBuilder.addByte(0x00);
    var crcHex = crc.toRadixString(16).padLeft(8, "0");
    bytesBuilder.add(hexStrToUint8ListBeLittle(crcHex));
    bytesBuilder.add([0x00, 0x20, 0x00, 0xff]);
    print("lengthHex: $hexStr");
    print("crcHex: $crcHex");
    print("length info: ${print16hex(bytesBuilder.toBytes())}");
    print("开始确认");

    Future sendData(data) async {
      var res = awaitRes();
      await widget.ble.writeCharacteristicWithResponse(
        char,
        value: data,
      );
      var d = await res;
      print("notify ${print16hex(d)}");
    }

    print("send d0");
    await sendData([0xd0]);

    print("send d1");
    await sendData([0xd1]);

    print("send length");
    await sendData(bytesBuilder.toBytes());

    print("send d3 01");
    await sendData([0xd3, 0x01]);

    print("确认完成");
    var flag = 0;
    var res = awaitRes();
    while (flag < bytes.length) {
      var size = 244;
      var p = bytes.getRange(flag, min(flag + size, bytes.length)).toList();
      await widget.ble.writeCharacteristicWithoutResponse(charWiret, value: p);
      flag = flag + size;
    }
    var data = await res;
    print("end ${print16hex(data)}");
    print("传输完成");
    await widget.ble.writeCharacteristicWithResponse(char, value: [0xd5]);
    await widget.ble.writeCharacteristicWithResponse(char, value: [0xd1]);
    await widget.ble.writeCharacteristicWithResponse(char, value: [0xd6]);
    await widget.ble.writeCharacteristicWithResponse(char, value: [0xd1]);
    print("全部执行完成");
  }

  // 将16进制转为字节列表，以小端序存储
  Uint8List hexStrToUint8ListBeLittle(String hexStr) {
    assert(hexStr.length % 2 == 0);
    final bytesBuilder = BytesBuilder();
    for (var i = hexStr.length; i > 0; i = i - 2) {
      var hex = hexStr.substring(i - 2, i);
      bytesBuilder.addByte(int.parse(hex, radix: 16));
    }
    return bytesBuilder.toBytes();
  }

  selectWatch() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      customWatchPath.value = result.files.single.path!;
      selectName.value = result.files.single.name;
      print("选择的表盘文件地址： ${customWatchPath.value}");
    }
  }

  /// 根据uuid的前缀找到 Characteristic
  Future<QualifiedCharacteristic> findCharacteristic(
      String server, String char) async {
    var services = await widget.ble.discoverServices(widget.device.id);
    Uuid? serviceId;
    Uuid? cid;
    for (var element in services) {
      if (element.serviceId.toString().startsWith(server)) {
        serviceId = element.serviceId;
        for (var el in element.characteristics) {
          print("charId: $el");
          if (el.characteristicId.toString().startsWith(char)) {
            cid = el.characteristicId;
            print("发现charId: ${el.characteristicId}");
            print("isReadable: ${el.isReadable}");
            print("isWritableWithResponse: ${el.isWritableWithResponse}");
            print("isNotifiable: ${el.isNotifiable}");
            print("isWritableWithoutResponse: ${el.isWritableWithoutResponse}");
            print("isIndicatable: ${el.isIndicatable}");
            break;
          }
        }
        break;
      }
    }
    if (serviceId == null || cid == null) {
      Fluttertoast.showToast(msg: "未发现服务");
      throw Exception("未发现服务");
    }
    return QualifiedCharacteristic(
      characteristicId: cid,
      serviceId: serviceId,
      deviceId: widget.device.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("已连接至：${widget.device.name}"),
        ValueListenableBuilder(
            valueListenable: selectName,
            builder: (ctx, String val, child) {
              return Text("已选择表盘：$val");
            }),
        ElevatedButton(onPressed: getBettery, child: const Text("电池电量")),
        ElevatedButton(onPressed: getHeart, child: const Text("获取心率")),
        ElevatedButton(onPressed: start, child: const Text("安装")),
        ElevatedButton(onPressed: selectWatch, child: const Text("选择表盘")),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

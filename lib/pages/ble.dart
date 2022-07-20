import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:copy_watch_face/generated/l10n.dart';
import 'package:crclib/catalog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  bool scaning = false;

  StreamSubscription<DiscoveredDevice>? scanSub;

  Future scan() async {
    var value = await Permission.location.request();
    if (value.isDenied) {
      Fluttertoast.showToast(msg: S.current.firstGivePromise);
      return;
    }
    print("开始扫描");
    setState(() {
      scaning = true;
    });
    scanSub = flutterReactiveBle.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      if (devs.indexWhere((element) => element.id == device.id) < 0) {
        if (device.name.isNotEmpty && device.name.contains("Band")) {
          setState(() {
            devs.add(device);
          });
        }
      }
    }, onError: (err) {
      print("扫描错误: $err");
    });
  }

  clickDev(DiscoveredDevice dev) {
    var s = S.of(context);
    EasyLoading.show(status: s.ble_connecting);
    sub = flutterReactiveBle
        .connectToDevice(
      id: dev.id,
      connectionTimeout: const Duration(seconds: 10),
    )
        .listen((event) {
      if (event.connectionState == DeviceConnectionState.connected) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: s.ble_connected);
        setState(() {
          connetDev = dev;
        });
      } else {
        setState(() {
          connetDev = null;
        });
        if (event.connectionState == DeviceConnectionState.disconnected) {
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: s.ble_disconnected);
        }
      }
    }, onError: (error) {
      setState(() {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: s.ble_connectFail);
      });
    });
  }

  update(String devId) {}

  @override
  void initState() {
    flutterReactiveBle.initialize();
    super.initState();
  }

  @override
  void dispose() {
    flutterReactiveBle.deinitialize();
    sub?.cancel();
    scanSub?.cancel();
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.ble_title)),
      body: connetDev != null
          ? _ConnectState(device: connetDev!, ble: flutterReactiveBle)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        s.ble_tips,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      Text(
                        s.ble_tips2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: scaning ? null : scan,
                    child: Text(scaning ? s.ble_scanning : s.ble_scan),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      var dev = devs[index];
                      return ListTile(
                        title: Text(dev.name),
                        subtitle: Text(dev.id),
                        trailing: ElevatedButton(
                          onPressed: () => clickDev(dev),
                          child: Text(s.ble_connect),
                        ),
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
  ValueNotifier<int> bettery = ValueNotifier(0); // 电池电量
  Stream<List<int>>? stream;

  bool installing = false; // 是否安装中
  double progress = 0; // 安装进度

  getBettery() async {
    var chara = await findCharacteristic("0000180f", "00002a19");
    var res = await widget.ble.readCharacteristic(chara);
    bettery.value = res[0];
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
    return c.future.timeout(const Duration(seconds: 60), onTimeout: () {
      return Future.error(MsgException(S.current.ble_timeout));
    });
  }

  String print16hex(List<int> data) {
    return data
        .map((e) => e.toRadixString(16).padLeft(2, "0"))
        .toList()
        .toString();
  }

  Future onSyncEnd(length) {
    Completer c = Completer();
    StreamSubscription? sub;
    sub = stream?.listen((event) {
      if (event.length != 7) return;
      var hexLen = event
          .sublist(2, 5)
          .map((e) => e.toRadixString(16))
          .toList()
          .reversed
          .join("");
      var len = int.parse(hexLen, radix: 16);
      print("end len: $len");
      if (len == length) {
        c.complete();
        sub?.cancel();
      }
    });
    return c.future.timeout(const Duration(seconds: 60), onTimeout: () {
      setState(() {
        progress = 0;
        installing = false;
      });
      return Future.error(MsgException(S.current.ble_timeout));
    });
  }

  /// 对 start 封装一层 好维护安装状态
  safeInstall() async {
    setState(() {
      installing = true;
    });
    try {
      await install();
      Fluttertoast.showToast(msg: S.current.ble_install_success);
    } catch (e) {
      if (e is MsgException) {
        Fluttertoast.showToast(msg: e.msg);
      } else {
        Fluttertoast.showToast(msg: S.current.ble_install_fail);
      }
    }
    setState(() {
      installing = false;
    });
  }

  /// 执行安装任务
  install() async {
    var char = await findCharacteristic("00001530", "00001531");
    var charWiret = await findCharacteristic("00001530", "00001532");
    if (stream == null) {
      stream = widget.ble.subscribeToCharacteristic(char).asBroadcastStream();
      stream?.listen((event) {
        print("[${DateTime.now()}]收到通知：${print16hex(event)}");
      });
    }

    var file = File(customWatchPath.value);
    var bytes = await file.readAsBytes();
    var crc = Crc32().convert(bytes).toBigInt();
    print("crc: $crc");
    final bytesBuilder = BytesBuilder();
    bytesBuilder.add([0xd2, 0x08]);
    // 将长度转换为3个字节大小的16进制字符串
    var bytesLength = bytes.length;
    var hexStr = bytesLength.toRadixString(16).padLeft(6, "0");
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

    updateProgress(int flag) {
      setState(() {
        progress = flag / bytesLength;
      });
    }

    await sendData([0xd0]);
    await sendData([0xd1]);
    await sendData(bytesBuilder.toBytes());
    await sendData([0xd3, 0x01]);

    print("确认完成");
    var flag = 0;
    var res = awaitRes();
    const int times = 33;
    int time = 0;
    while (flag < bytes.length) {
      if (time == times) {
        // 如果已发送了33次256的包，就发送一个152的包。
        int size = 140;
        if (flag + size > bytes.length) {
          size = bytes.length - flag;
        }
        var p = bytes.getRange(flag, flag + size).toList();
        await widget.ble
            .writeCharacteristicWithoutResponse(charWiret, value: p);
        var send = await res;
        res = awaitRes();
        print("已同步长度: ${print16hex(send)}");
        time = 0;
        flag = flag + size;
        updateProgress(flag);
        continue;
      }
      int size = 244;
      if (flag + size > bytes.length) {
        size = bytes.length - flag;
      }
      List<int> p = bytes.getRange(flag, flag + size).toList();
      await widget.ble.writeCharacteristicWithoutResponse(charWiret, value: p);
      flag = flag + size;
      time++;
      updateProgress(flag);
    }
    print("等待同步完成");
    await onSyncEnd(bytesLength);
    print("同步完成");

    await sendData([0xd5]);
    await sendData([0xd6]);
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
      } else {
        String uuid = element.serviceId.toString();
        print("uuid: $uuid");
      }
    }
    if (serviceId == null || cid == null) {
      throw MsgException(S.current.ble_notFindService);
    }
    return QualifiedCharacteristic(
      characteristicId: cid,
      serviceId: serviceId,
      deviceId: widget.device.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("${s.ble_connectedTo}${widget.device.name}"),
          ValueListenableBuilder(
            valueListenable: bettery,
            builder: betteryBuilder,
          ),
          Expanded(
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: selectName,
                builder: (ctx, String val, child) {
                  if (val.isEmpty) {
                    return ElevatedButton(
                      onPressed: selectWatch,
                      child: Text(s.ble_select_file),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 64),
                        child: buildProgress(),
                      ),
                      Text("${s.ble_selected}$val"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: installing ? null : safeInstall,
                        child: Text(s.ble_install),
                      ),
                      ElevatedButton(
                        onPressed: installing ? null : selectWatch,
                        child: Text(s.ble_reselectFile),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      getBettery();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (Platform.isAndroid) {
      widget.ble.clearGattCache(widget.device.id);
    }
  }

  Widget buildProgress() {
    var s = S.of(context);
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey[200],
              strokeWidth: 16,
              value: progress,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                "${s.ble_installProgress}${(progress * 100).toInt()}%",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 电量显示
  Widget betteryBuilder(BuildContext context, int value, Widget? child) {
    if (value == 0) {
      return const SizedBox();
    }
    Color color;
    if (value > 20) {
      color = Colors.green;
    } else if (value > 10) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(Icons.battery_full_sharp, color: color), Text("$value%")],
    );
  }
}

class MsgException implements Exception {
  final String msg;

  MsgException(this.msg);
}

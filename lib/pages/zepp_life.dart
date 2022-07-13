import 'dart:io';
import 'dart:typed_data';

import 'package:app_launcher/app_launcher.dart';
import 'package:copy_watch_face/face_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_storage/saf.dart' as saf;
import 'package:flutter/services.dart' show rootBundle;

class ZeppLifePage extends StatefulWidget {
  const ZeppLifePage({Key? key}) : super(key: key);

  @override
  State<ZeppLifePage> createState() => _ZeppLifePageState();
}

class _ZeppLifePageState extends State<ZeppLifePage> {
  var ctl = FaceController(
    directory: "Android/data/com.xiaomi.hm.health/files/watch_skin_local",
    target: "custom.bin",
    targetSize: 0,
  );

  var targetName = "被偷的天";

  Future startReplace() async {
    if (!ctl.havePromise.value) {
      ctl.toast(msg: "请先授权");
      return;
    }
    if (ctl.customWatchPath.value.isEmpty) {
      ctl.toast(msg: "请先选择表盘");
      return;
    }

    var hasDir = await saf.findFile(ctl.directoryUri, "CUSTOM");
    if (hasDir == null) {
      await createXml();
    }

    var custom = await saf.child(ctl.directoryUri, "CUSTOM");

    try {
      File selectFile = File(ctl.customWatchPath.value);
      Uint8List bytes = selectFile.readAsBytesSync();
      await custom!.createFileAsBytes(
        mimeType: "application/octet-stream",
        displayName: ctl.target,
        bytes: bytes,
      );
      ctl.toast(msg: "替换成功, 请在 Zepp Life 本地表盘中同步$targetName表盘");
      AppLauncher.openApp(androidApplicationId: "com.xiaomi.hm.health");
    } catch (e) {
      ctl.toast(msg: "替换失败");
    }
  }

  // 创建XML文件以及封面图
  Future createXml() async {
    await saf.createDirectory(ctl.directoryUri, "CUSTOM");
    var xml = await rootBundle.load("assets/infos.xml");
    var xmlData = xml.buffer.asUint8List();
    var child = await saf.child(ctl.directoryUri, "CUSTOM");
    if (child == null) ctl.toast(msg: "创建目录失败");
    child!.createFile(
      mimeType: "text/xml",
      displayName: "infos.xml",
      bytes: xmlData,
    );
    var face = await rootBundle.load("assets/face.png");
    Uint8List faceData = face.buffer.asUint8List();
    await child.createFile(
      mimeType: "image/png",
      displayName: "face.png",
      bytes: faceData,
    );
  }

  @override
  Widget build(BuildContext context) {
    var useTxt = "使用说明：\n    第一步，选择你要替换的表盘。第二步授权。"
        "第三步，点击立即替换后，打开表盘商城中的表盘管理，在本地表盘中有个[$targetName]表盘，点击同步表盘即可。";

    return Scaffold(
      appBar: AppBar(title: const Text("复制表盘->Zepp Life")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(useTxt),
                const Text(
                  "\n此页面的功能仅适用于小米手环7+Zepp Life",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
          MaterialButton(
            onPressed: () => ctl.selectWatchFace(),
            child: ValueListenableBuilder(
              valueListenable: ctl.selectName,
              builder: (context, String val, child) {
                var selectText = "1. 选择你要替换的表盘";
                if (val.isNotEmpty) {
                  selectText = "$selectText(已选择：$val)";
                }
                return SizedBox(
                  width: double.infinity,
                  child: Text(selectText),
                );
              },
            ),
          ),
          MaterialButton(
            onPressed: () => ctl.getPermission(),
            child: ValueListenableBuilder(
              valueListenable: ctl.havePromise,
              builder: (ctx, bool val, child) {
                var promise = "2. 授权访问 Zepp Life 内部数据";
                if (val) {
                  promise = "$promise(已授权)";
                }
                return SizedBox(
                  width: double.infinity,
                  child: Text(promise),
                );
              },
            ),
          ),
          MaterialButton(
            onPressed: startReplace,
            child: const SizedBox(
              width: double.infinity,
              child: Text("3. 立即替换"),
            ),
          ),
        ],
      ),
    );
  }
}

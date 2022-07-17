import 'dart:io';
import 'dart:typed_data';

import 'package:app_launcher/app_launcher.dart';
import 'package:copy_watch_face/face_controller.dart';
import 'package:copy_watch_face/generated/l10n.dart';
import 'package:copy_watch_face/util.dart';
import 'package:flutter/material.dart';
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
    var s = S.of(context);
    if (!ctl.havePromise.value) {
      ctl.toast(msg: s.firstGivePromise);
      return;
    }
    if (ctl.customWatchPath.value.isEmpty) {
      ctl.toast(msg: s.firstSelectFace);
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
      String text = formatString(s.zepplife_success, "targetName", targetName);
      ctl.toast(msg: text);
      AppLauncher.openApp(androidApplicationId: "com.xiaomi.hm.health");
    } catch (e) {
      ctl.toast(msg: s.replaceFail);
    }
  }

  // 创建XML文件以及封面图
  Future createXml() async {
    await saf.createDirectory(ctl.directoryUri, "CUSTOM");
    var xml = await rootBundle.load("assets/infos.xml");
    var xmlData = xml.buffer.asUint8List();
    var child = await saf.child(ctl.directoryUri, "CUSTOM");
    if (child == null) ctl.toast(msg: S.current.zepplife_createDirFail);
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
    var s = S.of(context);
    var useTxt = formatString(
      s.zepplife_shiYongShuoMing,
      "targetName",
      targetName,
    );

    return Scaffold(
      appBar: AppBar(title: Text(s.zepplife_appbarTitle)),
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
                Text(
                  s.zepplife_waring,
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
          MaterialButton(
            onPressed: () => ctl.selectWatchFace(),
            child: ValueListenableBuilder(
              valueListenable: ctl.selectName,
              builder: (context, String val, child) {
                var selectText = "1. ${s.zepplife_step1}";
                if (val.isNotEmpty) {
                  selectText = "${s.zepplife_step1_state}$val";
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
                var promise = "2. ${s.zepplife_step2}";
                if (val) {
                  promise = "$promise${s.zepplife_step2_state}";
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
            child: SizedBox(
              width: double.infinity,
              child: Text("3. ${s.zepplife_step3}"),
            ),
          ),
        ],
      ),
    );
  }
}

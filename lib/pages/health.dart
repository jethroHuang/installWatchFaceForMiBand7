// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:app_launcher/app_launcher.dart';
import 'package:copy_watch_face/face_controller.dart';
import 'package:copy_watch_face/generated/l10n.dart';
import 'package:copy_watch_face/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_storage/saf.dart' as saf;

class HealthPage extends StatefulWidget {
  const HealthPage({Key? key}) : super(key: key);

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> with RouteAware {
  var ctl = FaceController(
    directory: "Android/data/com.mi.health/files/WatchFace",
    target: "db7e13acae9163d1d6e314fc95d391a6",
    targetSize: 1231681,
  );

  String targetName = S.current.targetName;

  bool listening = false; // 处理中

  @override
  void dispose() {
    App.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    resetTarget();
    super.didPopNext();
  }

  // 从配置中读取target信息，如果有则重新设置target
  resetTarget() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("fileName");
    int? size = prefs.getInt("fileSize");
    String? faceName = prefs.getString("faceName");
    if (name == null || size == null || faceName == null) return;
    setState(() {
      ctl.target = name;
      ctl.targetSize = size;
      targetName = faceName;
    });
  }

  @override
  void didChangeDependencies() {
    App.routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Permission.storage.request();
    resetTarget();
    super.initState();
  }

  updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  void startFind() async {
    if (ctl.customWatchPath.value.isEmpty) {
      ctl.toast(msg: S.of(context).firstSelectFace);
      return;
    }
    if (!ctl.havePromise.value) {
      ctl.toast(msg: S.of(context).firstGivePromise);
      return;
    }
    bool success = await ctl.delFace();
    if (success) {
      ctl.toast(msg: "${S.of(context).deletedNowFace}($targetName)");
    } else {
      ctl.toast(msg: "${S.of(context).dontFundWatchFace}$targetName");
      return;
    }
    listening = true;
    if (mounted) {
      setState(() {});
    }
    syncFile();
  }

  // 同步处理文件
  void syncFile() {
    // 同步文件
    var uri = ctl.directoryUri;
    final Stream<saf.PartialDocumentFile> onNewFileLoaded =
        saf.listFiles(uri, columns: ctl.columns);

    onNewFileLoaded.listen((file) {
      if (file.data?[saf.DocumentFileColumn.displayName] == ctl.target &&
          file.data?[saf.DocumentFileColumn.size] == ctl.targetSize) {
        listening = false;
        if (mounted) {
          setState(() {});
        }
        onFileFind(file);
      }
    }, onDone: () {
      if (listening) {
        syncFile();
      }
      print('All files were loaded');
    });
  }

  void onFileFind(saf.PartialDocumentFile file) async {
    Uri? uri = file.metadata?.uri;
    if (uri != null) {
      var bytes = await saf.getDocumentContent(uri);
      var mimeType = file.data?[saf.DocumentFileColumn.mimeType];
      var displayName = file.data?[saf.DocumentFileColumn.displayName];
      print("文件大小: ${bytes?.length}");
      print("文件类型: $mimeType");
      print("文件名称: $displayName");
      File selectFile = File(ctl.customWatchPath.value);
      bytes = selectFile.readAsBytesSync();

      var dUri = ctl.directoryUri;
      await saf.delete(uri);
      await saf.createFileAsBytes(dUri,
          mimeType: "application/octet-stream",
          displayName: file.data![saf.DocumentFileColumn.displayName],
          bytes: bytes);
      ctl.toast(msg: S.of(context).replaceSuccess);
    }
  }

  // 打开小米运动
  void openXMYD() {
    AppLauncher.openApp(androidApplicationId: "com.mi.health");
  }

  // 打开设置页面
  void goSet() async {
    if (!ctl.havePromise.value) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(S.of(context).tips_title),
          content: Text(S.of(context).health_setTipsContent),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(S.of(context).gotIt),
            ),
          ],
        ),
      );
      await ctl.getPermission();
    }
    if (ctl.havePromise.value) {
      context.push("/set_target");
    }
  }

  @override
  Widget build(BuildContext context) {
    var useTxt = S.of(context).health_shiYongShuoMing.replaceAll(
          RegExp(r"\$targetName"),
          targetName,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text("复制表盘->小米运动健康"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: goSet,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(useTxt),
                  const Text(
                    "\n此页面的功能仅适用于小米手环7+小米运动健康",
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
            Center(
              child: Text(
                "工作状态: ${listening ? "替换中" : "等待开始"}",
                style:
                    TextStyle(color: listening ? Colors.green : Colors.black87),
              ),
            ),
            MaterialButton(
              onPressed: () => ctl.getPermission(),
              child: ValueListenableBuilder(
                valueListenable: ctl.havePromise,
                builder: (ctx, bool val, child) {
                  var promise = "1. 授权访问小米运动健康内部数据";
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
              onPressed: () => ctl.selectWatchFace(),
              child: ValueListenableBuilder(
                valueListenable: ctl.selectName,
                builder: (context, String val, child) {
                  var selectText = "2. 选择你要替换的表盘";
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
              onPressed: startFind,
              child: const SizedBox(
                width: double.infinity,
                child: Text("3. 开始替换"),
              ),
            ),
            MaterialButton(
              onPressed: openXMYD,
              child: SizedBox(
                width: double.infinity,
                child: Text("4. 打开小米运动健康，启用[$targetName]表盘"),
              ),
            ),
            buildTools(),
          ],
        ),
      ),
    );
  }

  buildTools() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 64.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "其他工具",
            style: Theme.of(context).textTheme.headline6,
          ),
          ElevatedButton(
            onPressed: () => ctl.delAllFile(),
            child: const Text("清空WatchFace目录"),
          )
        ],
      ),
    );
  }
}

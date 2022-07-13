import 'package:copy_watch_face/saf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_storage/saf.dart' as saf;

class FaceController {
  final String directory;
  String target;
  int targetSize;
  late Uri directoryUri;

  ValueNotifier<String> customWatchPath = ValueNotifier("");
  ValueNotifier<String> selectName = ValueNotifier(""); // 已选择的表盘

  ValueNotifier<bool> havePromise = ValueNotifier(false); // 是否拥有权限

  final List<saf.DocumentFileColumn> columns = <saf.DocumentFileColumn>[
    saf.DocumentFileColumn.displayName,
    saf.DocumentFileColumn.size,
    saf.DocumentFileColumn.lastModified,
    saf.DocumentFileColumn.id,
    // Optional column, will be available/queried regardless if is or not included here
    saf.DocumentFileColumn.mimeType,
  ];

  FaceController({
    required this.directory,
    required this.target,
    required this.targetSize,
  }) {
    directoryUri = Uri.parse(makeTreeUriString(directory));
  }

  toast({required String msg}) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }

  Future<bool> delFace() async {
    try {
      var file = await saf.findFile(directoryUri, target);
      if (file != null) {
        await file.delete();
        return true;
      } else {
        return false;
      }
    } catch (err) {
      toast(msg: "删除表盘失败");
      throw Exception("删除表盘失败");
    }
  }

  Future delAllFile() async {
    final Stream<saf.PartialDocumentFile> onNewFileLoaded = saf.listFiles(
      directoryUri,
      columns: columns,
    );
    onNewFileLoaded.listen((file) {
      if (file.metadata != null && file.metadata?.uri != null) {
        saf.delete(file.metadata!.uri!);
      }
    }, onDone: () {
      toast(msg: "所有文件已删除");
    });
  }

  Future<void> getPermission() async {
    if (havePromise.value) return;
    final Uri? grantedUri = await saf.openDocumentTree(
        grantWritePermission: true, initialUri: directoryUri);
    if (grantedUri != null) {
      toast(msg: "已成功获取权限");
      havePromise.value = true;
    } else {
      toast(msg: "未获取权限");
    }
  }

  // 选择表盘
  void selectWatchFace() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      customWatchPath.value = result.files.single.path!;
      selectName.value = result.files.single.name;
      if (kDebugMode) {
        print("选择的表盘文件地址： ${customWatchPath.value}");
      }
    }
  }
}

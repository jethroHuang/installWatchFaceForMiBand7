import 'package:copy_watch_face/saf.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_storage/saf.dart' as saf;

class SetTargetPage extends StatefulWidget {
  const SetTargetPage({Key? key}) : super(key: key);

  @override
  State<SetTargetPage> createState() => _SetTargetPageState();
}

class _SetTargetPageState extends State<SetTargetPage> {
  final List<saf.DocumentFileColumn> columns = <saf.DocumentFileColumn>[
    saf.DocumentFileColumn.displayName,
    saf.DocumentFileColumn.size,
    saf.DocumentFileColumn.lastModified,
    saf.DocumentFileColumn.id,
    // Optional column, will be available/queried regardless if is or not included here
    saf.DocumentFileColumn.mimeType,
  ];

  List<saf.PartialDocumentFile> files = [];

  setFile(saf.PartialDocumentFile file) async {
    String? faceName = await setName();
    if (faceName == null) return;
    final prefs = await SharedPreferences.getInstance();
    // 存储名称
    await prefs.setString(
        "fileName", file.data![saf.DocumentFileColumn.displayName]);
    // 存储文件大小
    await prefs.setInt(
      "fileSize",
      file.data![saf.DocumentFileColumn.size],
    );
    await prefs.setString("faceName", faceName);
    Fluttertoast.showToast(msg: "设置成功");
    Navigator.pop(context);
  }

  Future<String?> setName() async {
    var ctl = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("备注表盘名称"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "因为文件名称不具有可读性，因此需要您手动输入文件对应的表盘名称，以方便以后对应起来。",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            TextField(
              controller: ctl,
              decoration: const InputDecoration(hintText: "请在此输入表盘名称"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (ctl.text.isEmpty) {
                Fluttertoast.showToast(msg: "请输入您所选择的表盘对应的名称，以作备注");
                return;
              }
              Navigator.pop(context, ctl.text);
            },
            child: const Text("确认"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    var path = "Android/data/com.mi.health/files/WatchFace";
    var uri = Uri.parse(makeTreeUriString(path));
    saf.listFiles(uri, columns: columns).listen((event) {
      if (event.metadata!.isDirectory == false) {
        files.add(event);
        if (mounted) {
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String hint =
        "如果你知道被替换的表盘对应的文件名称，你可以在这里选择对应的文件。设置后软件将会保存设置，以后都会替换你选择的文件。\n\n";
    hint = "$hint建议在选择前先正常安装一次要选择的表盘，以免偷天换日获取到不正确的信息。";
    return Scaffold(
      appBar: AppBar(title: const Text("自定义被替换的表盘")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(hint),
          ),
          Text(
            "表盘文件列表",
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: itemBuilder,
              itemCount: files.length,
            ),
          )
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    var file = files[index];
    var size = file.data![saf.DocumentFileColumn.size];
    var name = file.data![saf.DocumentFileColumn.displayName] ?? "未知文件";
    return ListTile(
      title: Text("文件名称：$name"),
      subtitle: Text("文件大小：$size字节"),
      trailing: ElevatedButton(
        onPressed: () => setFile(file),
        child: const Text("选择此表盘"),
      ),
    );
  }
}

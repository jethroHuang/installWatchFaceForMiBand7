import 'package:copy_watch_face/generated/l10n.dart';
import 'package:copy_watch_face/saf.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    Fluttertoast.showToast(msg: S.current.set_target_setSuccess);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<String?> setName() async {
    var ctl = TextEditingController();
    var s = S.current;
    return showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.set_target_noteTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.set_target_noteDesc,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            TextField(
              controller: ctl,
              decoration: InputDecoration(hintText: s.set_target_inputHint),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (ctl.text.isEmpty) {
                Fluttertoast.showToast(msg: s.set_target_noNameToast);
                return;
              }
              Navigator.pop(context, ctl.text);
            },
            child: Text(s.sure),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
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
    var s = S.of(context);
    String hint = s.set_target_shuoMing;
    return Scaffold(
      appBar: AppBar(title: Text(s.set_target_appbar_title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(hint),
          ),
          Text(
            s.set_target_file_list,
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
    var s = S.of(context);
    var file = files[index];
    var size = file.data![saf.DocumentFileColumn.size];
    var name = file.data![saf.DocumentFileColumn.displayName] ??
        s.set_target_unknownFile;
    return ListTile(
      title: Text("${s.set_target_fileName}$name"),
      subtitle: Text("${s.set_target_fileSize}${size}byte"),
      trailing: ElevatedButton(
        onPressed: () => setFile(file),
        child: Text(s.set_target_select),
      ),
    );
  }
}

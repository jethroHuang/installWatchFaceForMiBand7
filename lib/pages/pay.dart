import 'package:copy_watch_face/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  void openPaypal() async {
    final Uri url = Uri.parse('https://paypal.me/jethroHEX');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(
          msg:
              "Unable to open paypal, please manually enter the link in your browser");
    }
  }

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    Locale myLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.pay_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: myLocale.languageCode == "zh" ? buildChina() : buildOther(),
      ),
    );
  }

  // 其他语言的打赏界面
  Widget buildOther() {
    return Column(
      children: [
        const Text(
            "If you think it's a good APP, buy the developer a cup of coffee. Please click the PayPal link to pay me. Or make your suggestions at https://www.bandbbs.cn/."),
        GestureDetector(
          onTap: openPaypal,
          child: Container(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                const Text("Paypal link: "),
                SelectableText(
                  "https://paypal.me/jethroHEX",
                  onTap: openPaypal,
                  style: const TextStyle(decoration: TextDecoration.underline),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  // 中文的打赏页面
  Widget buildChina() {
    return Column(
      children: [
        const Text(
          "截图后在支付宝/微信中打开扫一扫选择相册中的截图即可。感谢小可爱的支持！！！",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 100),
        Row(
          children: [
            Expanded(child: Image.asset("assets/alipay.jpg")),
            const SizedBox(width: 8),
            Expanded(child: Image.asset("assets/wechat.png")),
          ],
        )
      ],
    );
  }
}

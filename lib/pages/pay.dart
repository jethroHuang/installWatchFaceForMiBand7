import 'package:flutter/material.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("打赏作者"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
        ),
      ),
    );
  }
}

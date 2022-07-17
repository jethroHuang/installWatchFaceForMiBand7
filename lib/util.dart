/// 格式化字符串
String formatString(String string, String variable, String val) {
  var reg = RegExp(r"\$" + variable);
  return string.replaceAll(reg, val);
}

import 'dart:ffi';
import 'dart:typed_data';

void main(List<String> args) {
  var a = Uint8List.fromList([0x10, 0x22]);
  var b = Uint8List.fromList([0x10, 0x22]);

  print("a == b: ${a == b}");
}

import 'dart:typed_data';

extension Uint8ListExt on Uint8List {

  Uint8List addList(Uint8List other) {
    Uint8List result = Uint8List.fromList(this.toList() + other.toList());
    return result;
  }
}
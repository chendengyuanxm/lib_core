extension StringExt on String {
  bool get isNullOrEmpty => this == null || isEmpty;
  bool get isNotNullAndEmpty => this != null && isNotEmpty;
}

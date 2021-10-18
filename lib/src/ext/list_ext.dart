extension ListExt<E> on List<E> {

  int get safeLength => this == null ? 0 : length;

  bool get isNullOrEmpty => this == null || isEmpty;

  bool get isNotNullAndEmpty => this != null && isNotEmpty;

  E? get safeFirst => this.safeLength > 0 ? this.first : null;
}
class Enum {
  static String getName(dynamic enumItem) {
    if (enumItem == null) {
      return null;
    }
    return enumItem.toString().split('.').last;
  }
}

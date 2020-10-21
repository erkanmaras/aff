class Hash {

 
  /// Generates a hash code for multiple [objects].
static  int hashObjects(Iterable objects) => _finish(objects?.fold(0, _combine)?? 0);

  /// Generates a hash code for two objects.
 static int hash2(dynamic a,dynamic b) => _finish(_combine(_combine(0, a.hashCode), b.hashCode));

  /// Generates a hash code for three objects.
  static int hash3(dynamic a, dynamic b, dynamic c) => _finish(_combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode));

  /// Generates a hash code for four objects.
 static int hash4( dynamic a, dynamic b,  dynamic c, dynamic  d) =>
      _finish(_combine(_combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode), d.hashCode));

// Jenkins hash functions

 static int _combine(int hash, dynamic object) {
      if (object is Map) {
    object.forEach((dynamic key, dynamic value) {
      hash = hash ^ _combine(hash, <dynamic>[key, value]);
    });
    return hash;
  }
  if (object is Iterable) {
    for (final value in object) {
      hash = hash ^ _combine(hash, value);
    }
    return hash ^ object.length;
  }

    hash = 0x1fffffff & (hash + object.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

static int _finish(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

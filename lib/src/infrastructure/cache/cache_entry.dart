import 'package:clock/clock.dart';

class CacheEntry<K, V> {
  CacheEntry(this.key, this.value, this.insertTime, {this.expiration}) {
    lastUse = insertTime;
  }

  K key;
  V value;
  DateTime insertTime;
  Duration expiration;
  DateTime lastUse;

  bool expired() {
    if (expiration == null) {
      return false;
    }
    return clock.now().difference(insertTime) > expiration;
  }
}

import 'dart:collection';
import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'cache_entry.dart';

/// Basic LRU cache
/// when storage is full , try remove an expired item, if not exist remove Least Recently Used
class MemoryCache<K, V> {
  MemoryCache({@required int capacity}) {
    _capacity = capacity;
  }

  //ignore: prefer_collection_literals
  var _storageMap = LinkedHashMap<K, CacheEntry<K, V>>();
  var _capacity = 0;

  /// return the element by [key]
  V get(K key) {
    var entry = _storageMap[key];

    if (entry == null || entry.expired()) {
      _storageMap.remove(key);
      return null;
    }

    //Change order, because first item removed when capacity is full
    _storageMap.remove(key);
    _storageMap[key] = entry;

    entry.lastUse = clock.now();
    return entry.value;
  }

  /// add [element] in the cache at [key]
  void set(K key, V element, {Duration expiration}) {
    if (!_storageMap.containsKey(key) && length >= _capacity) {
      //try remove an expired entry first
      var entry = _storageMap.entries.firstWhere((p) => p.value.expired(), orElse: () => null);

      if (entry != null) {
        _storageMap.remove(entry.key);
      } else {
        _storageMap.remove(_storageMap.keys.first);
      }
    }

    _storageMap[key] = CacheEntry(
      key,
      element,
      clock.now(),
      expiration: expiration,
    );
  }

  bool containsKey(K key) => _storageMap.containsKey(key);

  void clear() {
    _storageMap.clear();
  }

  int get length => _storageMap.length;
}

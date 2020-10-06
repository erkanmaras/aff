import 'dart:io';
import 'package:aff/infrastructure.dart';
import 'package:test/test.dart';

void main() {
  group('Cache Tests', () {
    test('initialization', () {
      MemoryCache cache = MemoryCache<int, int>(capacity: 20);
      expect(cache, isNotNull);
    });
    //
    test('set and get same value', () {
      MemoryCache c = MemoryCache<String, int>(capacity: 20);
      c.set('key', 42);
      expect(c.get('key'), equals(42));
    });

    test('expiration', () {
      MemoryCache c = MemoryCache<String, int>(capacity: 20);
      c.set('key', 42, expiration: Duration(milliseconds: 1));
      sleep(const Duration(milliseconds: 10));
      expect(c.get('key'), equals(null));
      expect(c.length, equals(0));
    });

    test('size exceed remove first', () {
      MemoryCache<int, int> c = MemoryCache<int, int>(capacity: 3);

      c.set(4, 40);
      c.set(5, 50);
      c.set(6, 60);
      c.set(7, 70);

      expect(c.containsKey(4), equals(false));
      expect(c.get(5), equals(50));
      expect(c.get(6), equals(60));
      expect(c.get(7), equals(70));
    });

    test('size exceed remove expired', () {
      MemoryCache<int, int> c = MemoryCache<int, int>(capacity: 3);

      c.set(4, 40);
      c.set(5, 50, expiration: Duration(milliseconds: 1));
      sleep(const Duration(milliseconds: 10));
      c.set(6, 60);
      c.set(7, 70);
      expect(c.containsKey(4), equals(true));
      expect(c.get(4), equals(40));
      expect(c.get(6), equals(60));
      expect(c.get(7), equals(70));
    });

    test('size exceed remove LFU', () {
      MemoryCache<int, int> c = MemoryCache<int, int>(capacity: 3);

      c.set(4, 40);
      c.set(5, 50);
      //change order to 4
      expect(c.get(4), equals(40));
      c.set(6, 60);
      c.set(7, 70);
      expect(c.get(4), equals(40));
      expect(c.get(6), equals(60));
      expect(c.get(7), equals(70));
    });

    // test('performance', () {
    //   MemoryCache<String, int> cache = MemoryCache<String, int>(capacity: 100);
    //   Stopwatch stopwatch = Stopwatch()..start();
    //   for (var i = 0; i < 100000; i++) {
    //     cache.set(i.toString(), i);
    //   }
    //   debugPrint('### cache executed in ${stopwatch.elapsed}');
    // });
  });
}

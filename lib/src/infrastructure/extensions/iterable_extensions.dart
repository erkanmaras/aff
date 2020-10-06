import 'package:collection/collection.dart' as collections;

extension IterableExtensions<TElement> on Iterable<TElement> {
  ///Returns `true` this collection is null or there are no elements in this collection.
  bool isNullOrEmpty() => this == null || isEmpty;

  /// Returns the first element of a sequence, or a default value if the
  /// sequence contains no elements.
  /// Or returns the first element of the sequence that satisfies a condition
  /// or a default value if no such element is found if predicate was
  /// specified.
  TElement firstOrDefault([bool Function(TElement) predicate]) {
    TElement result;
    final it = iterator;
    if (predicate == null) {
      if (it.moveNext()) {
        return it.current;
      }
    } else {
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          return current;
        }
      }
    }

    return result;
  }



  /// Returns the last element of a sequence, or a default value if the
  /// sequence contains no elements.
  /// Or returns the last element of a sequence that satisfies a condition or a
  /// default value if no such element is found if predicate was specified.
  TElement lastOrDefault([bool Function(TElement) predicate]) {
    final it = iterator;
    TElement result;
    if (predicate == null) {
      while (it.moveNext()) {
        result = it.current;
      }
    } else {
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          result = current;
        }
      }
    }

    return result;
  }

  /// Computes the sum of the sequence of values that are obtained by invoking
  /// a transform function on each element of the input sequence.
  TResult sum<TResult extends num>(TResult Function(TElement) selector) {
    return _compute<TResult>((r, v) => r + v as TResult, selector);
  }

  TResult _compute<TResult extends num>(
    TResult Function(TResult, TResult) operation,
    TResult Function(TElement) selector,
  ) {
    TResult result;
    var first = true;
    final it = iterator;
    while (it.moveNext()) {
      final current = it.current;
      if (current == null) {
        continue;
      }

      final value = selector(current);
      result ??= value;
      if (value != null) {
        if (!first) {
          result = operation(result, value);
        } else {
          first = false;
        }
      }
    }

    return result ?? (result is int ? 0 : 0.0) as TResult;
  }

  Map<TKey, List<TElement>> groupBy<TKey>(TKey key(TElement element)) {
    return collections.groupBy(this, key);
  }

  TElement minBy<TValue>(TValue orderBy(TElement element), {int compare(TValue value1, TValue value2)}) {
    return collections.minBy(this, orderBy, compare: compare);
  }

  TElement maxBy<TValue>(TValue orderBy(TElement element), {int compare(TValue value1, TValue value2)}) {
    return collections.maxBy(this, orderBy, compare: compare);
  }

}

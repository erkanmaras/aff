import 'package:aff/infrastructure.dart';
import 'package:collection/collection.dart';

/// [Equatable] does the override of the `==` operator as well as `hashCode`.
/// Sample usage
/// ```dart
///class Person extends Equatable {
///  String name;
///  String age;
///
///  @override
///  List<Object> get equatableProperties => [name, age];
///}
///```
abstract class Equatable {
  /// The [List] of `properties` (properties) which will be used to determine whether
  /// two [Equatable] are equal.
  List<Object> get equatableProperties;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            EquatableUtils.propertiesEquals(equatableProperties, other.equatableProperties);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ Hash.hashObjects(equatableProperties);

  @override
  String toString() => '$runtimeType';
}

mixin EquatableMixin {
  /// The [List] of `properties` (properties) which will be used to determine whether
  /// two [Equatable] are equal.
  List<Object> get equatableProperties;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            EquatableUtils.propertiesEquals(equatableProperties, other.equatableProperties);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ Hash.hashObjects(equatableProperties);

  @override
  String toString() => '$runtimeType';
}

class EquatableUtils {
  static DeepCollectionEquality _equality = DeepCollectionEquality();

  static bool propertiesEquals(List<Object> objectProperties, List<Object> otherProperties) {
    if (identical(objectProperties, otherProperties)) {
      return true;
    }
    if (objectProperties == null || otherProperties == null) {
      return false;
    }
    final length = objectProperties.length;
    if (length != otherProperties.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      final dynamic objectProperty = objectProperties[i];
      final dynamic otherProperty = otherProperties[i];

      if (objectProperty is Iterable || objectProperty is Map) {
        if (!_equality.equals(objectProperty, otherProperty)) {
          return false;
        }
      } else if (objectProperty?.runtimeType != otherProperty?.runtimeType) {
        return false;
      } else if (objectProperty != otherProperty) {
        return false;
      }
    }
    return true;
  }
}

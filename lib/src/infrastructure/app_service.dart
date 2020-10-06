typedef ServiceFactoryFunc<T> = T Function();

class AppService {
  AppService._();
  static final _factories = <Type, _AppServiceFactory<dynamic>>{};

  /// Get registered service
  /// If service not found ,throw Exception
  static T get<T>() {
    var object = _factories[T];
    if (object == null) {
      throw Exception('Object of type ${T.toString()} is not registered!');
    }
    return object.getInstance() as T;
  }

  /// Get registered service
  /// If service not found ,returns null
  static T tryGet<T>() {
    var object = _factories[T];
    if (object == null) {
      return null;
    }
    return object.getInstance() as T;
  }

  /// Register transient with  factory method.
  static void addTransient<T>(ServiceFactoryFunc<T> func) {
    _factories[T] = _AppServiceFactory<T>(_AppServiceFactoryType.transient, factoryFunc: func);
  }

  /// Register singleton instance.
  static void addSingleton<T>(T instance) {
    _factories[T] = _AppServiceFactory<T>(_AppServiceFactoryType.singleton, instance: instance);
  }

  /// Register singleton with  factory method.
  static void addSingletonFactory<T>(ServiceFactoryFunc<T> func) {
    _factories[T] = _AppServiceFactory<T>(_AppServiceFactoryType.singletonFactory, factoryFunc: func);
  }

  ///Clears all registered types(required for test)
  static void reset() {
    _factories.clear();
  }
}

enum _AppServiceFactoryType { transient, singleton, singletonFactory }

class _AppServiceFactory<T> {
  _AppServiceFactory(this.type, {this.factoryFunc, this.instance});

  _AppServiceFactoryType type;
  ServiceFactoryFunc<T> factoryFunc;
  T instance;

  T getInstance() {
    switch (type) {
      case _AppServiceFactoryType.transient:
        return factoryFunc();
      case _AppServiceFactoryType.singleton:
        return instance;
      case _AppServiceFactoryType.singletonFactory:
        instance ??= factoryFunc();
        return instance;
    }

    throw Exception('AppService cannot resolve factory type:${type.toString()}!');
  }
}

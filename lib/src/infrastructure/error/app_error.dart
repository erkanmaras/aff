import '../extensions/extensions.dart';

/// Program hatası vb istisna durumlarında kullanılacak, null referance vb...
/// Hatayı tanımlayan bir mesaj içerirmelidir. Hata mesajı kullanıcıya gösterilmez.
/// Kullanılcıyı bilgilendirmenin gerektiği hata durumlarında [AppException] sınıfı kullanılabilir.
class AppError implements Error {
  AppError({this.message, this.innerException});

  String message;
  dynamic innerException;

  @override
  String toString() {
    try {
      var buffer = StringBuffer();

      if (!message.isNullOrWhiteSpace()) {
        buffer.writeln('$runtimeType:$message');
      } else {
        buffer.writeln(runtimeType.toString());
      }

      if (innerException != null) {
        buffer.writeln('inner exception:$innerException');
      } else {
        buffer.writeln('stack trace:$stackTrace');
      }

      return buffer.toString();
    } catch (e) {
      return '${runtimeType}Message cannot resolved!';
    }
  }

  @override
  StackTrace get stackTrace {
    if (innerException is Error) {
      return (innerException as Error).stackTrace;
    }
    return StackTrace.current;
  }
}

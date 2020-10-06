import '../extensions/extensions.dart';

/// Kullanıcıya hata mesajı gösterilmesi istenen istisna durumlarında kullanılacak , validation exception vb..
/// İçerdiği mesaj  translate edilebilir olmalıdır -> bknz: [Localizer.translate].
/// Kullanılcıyı bilgilendirmenin gerekmediği hata durumlarında [AppError] sınıfı kullanılabilir.
class AppException implements Exception {
  AppException({this.code, this.message});

  String code;
  String message;

  @override
  String toString() {
    return message.isNullOrWhiteSpace()
        ? runtimeType.toString()
        : '${runtimeType.toString()}:$message';
  }
}

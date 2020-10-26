import 'dart:io';

class Connectivity {
  Future<bool> checkInternetConnection() async {
    try {
      //google.com çinde çalışmıyor -> example.com
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}

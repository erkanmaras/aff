import 'package:aff/infrastructure.dart';
import 'package:test/test.dart';

void main() {
  group('Logger Tests', () {
    test('call log and read correct values onListen', () {
      var logger = Logger();
      var message = 'warning';
      String expectedMessage;
      LogLevel expectedLevel;
      Logger.onLog.listen((log) {
        expectedMessage = log.message;
        expectedLevel = log.level;
      });

      logger.log(
        LogLevel.warning,
        'warning',
      );
      expect(expectedMessage, equals(message));
      expect(expectedLevel, equals(LogLevel.warning));
    });
  });
}

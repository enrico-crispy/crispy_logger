import 'package:logger/logger.dart';
import 'package:logger/web.dart';

class LoggerDefaults {
  static PrettyPrinter get consolePrinter => PrettyPrinter(
        lineLength: 60,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        methodCount: 4,
      );

  static ConsoleOutput get consoleOutput => ConsoleOutput();

  static PrettyPrinter get filePrinter => PrettyPrinter(
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        colors: false,
        printEmojis: false,
        lineLength: 60,
      );
}

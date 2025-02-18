import 'dart:io';
import 'dart:developer';

import 'package:crispy_logger/crispy_logger.dart';
import 'package:crispy_logger/utils/date_formatter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LoggerConfig {
  static Future<String> get logsDirectory async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final logDir =
          await Directory('${appDir.path}/logs').create(recursive: true);
      log('Log dir: ${logDir.path}');
      return '${logDir.path}/';
    } catch (e) {
      log('Error: $e');
    }
    return '';
  }

  static Future<File> createLogFile() async {
    final dir = await logsDirectory;
    final dateTime = DateTime.now();
    final formattedDateTime = DateFormatter.logFormat(dateTime);

    return File('$dir$formattedDateTime.log').create(recursive: true);
  }

  static Future<CrispyLogger> crispyLoggerProvider() async {
    return CrispyLogger(
      consoleLogger: Logger(
        printer: LoggerDefaults.consolePrinter,
        output: LoggerDefaults.consoleOutput,
      ),
      fileLogger: Logger(
        printer: LoggerDefaults.filePrinter,
        output: FileOutput(file: await createLogFile()),
      ),
    );
  }
}

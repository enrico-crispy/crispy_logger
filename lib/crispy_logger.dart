import 'package:logger/logger.dart';

export 'package:crispy_logger/logger_defaults.dart';
export 'package:crispy_logger/manager/logger_config.dart';
export 'package:crispy_logger/manager/logger_manager.dart';

class CrispyLogger {
  const CrispyLogger({this.consoleLogger, this.fileLogger});

  final Logger? consoleLogger;
  final Logger? fileLogger;

  /// Log a message at level [Level.trace].
  void t(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    bool shouldPrintToFile = false,
    bool shouldPrintToConsole = true,
  }) {
    if (shouldPrintToConsole) {
      consoleLogger?.t(message, error: error, stackTrace: stackTrace);
    }
    if (shouldPrintToFile) {
      fileLogger?.t(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at level [Level.debug].
  void d(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    bool shouldPrintToFile = false,
    bool shouldPrintToConsole = true,
  }) {
    if (shouldPrintToConsole) {
      consoleLogger?.d(message, error: error, stackTrace: stackTrace);
    }
    if (shouldPrintToFile) {
      fileLogger?.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at level [Level.info].
  void i(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    bool shouldPrintToFile = false,
    bool shouldPrintToConsole = true,
  }) {
    if (shouldPrintToConsole) {
      consoleLogger?.i(message, error: error, stackTrace: stackTrace);
    }
    if (shouldPrintToFile) {
      fileLogger?.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at level [Level.warning].
  void w(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    bool shouldPrintToFile = true,
    bool shouldPrintToConsole = true,
  }) {
    if (shouldPrintToConsole) {
      consoleLogger?.w(message, error: error, stackTrace: stackTrace);
    }
    if (shouldPrintToFile) {
      fileLogger?.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at level [Level.error].
  void e(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    bool shouldPrintToFile = true,
    bool shouldPrintToConsole = true,
  }) {
    if (shouldPrintToConsole) {
      consoleLogger?.e(message, error: error, stackTrace: stackTrace);
    }
    if (shouldPrintToFile) {
      fileLogger?.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at level [Level.fatal].
  void wtf(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    bool shouldPrintToFile = true,
    bool shouldPrintToConsole = true,
  }) {
    if (shouldPrintToConsole) {
      consoleLogger?.f(message, error: error, stackTrace: stackTrace);
    }
    if (shouldPrintToFile) {
      fileLogger?.f(message, error: error, stackTrace: stackTrace);
    }
  }
}

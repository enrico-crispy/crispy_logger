import 'package:logger/logger.dart';

export 'package:crispy_logger/manager/logger_manager.dart';

class CrispyLogger {
  const CrispyLogger({
    Logger? consoleLogger,
    Logger? fileLogger,
    bool shouldBlockPrintToFileGlobal = false,
  })  : _fileLogger = fileLogger,
        _consoleLogger = consoleLogger,
        _shouldBlockPrintToFileGlobal = shouldBlockPrintToFileGlobal;

  final Logger? _consoleLogger;
  final Logger? _fileLogger;
  final bool _shouldBlockPrintToFileGlobal;

  /// Log a message at level [Level.trace].
  void t(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    bool shouldPrintToFile = false,
    bool shouldPrintToConsole = true,
  }) {
    if (shouldPrintToConsole) {
      _consoleLogger?.t(message, error: error, stackTrace: stackTrace);
    }
    if (!_shouldBlockPrintToFileGlobal && shouldPrintToFile) {
      _fileLogger?.t(message, error: error, stackTrace: stackTrace);
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
      _consoleLogger?.d(message, error: error, stackTrace: stackTrace);
    }
    if (!_shouldBlockPrintToFileGlobal && shouldPrintToFile) {
      _fileLogger?.d(message, error: error, stackTrace: stackTrace);
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
      _consoleLogger?.i(message, error: error, stackTrace: stackTrace);
    }
    if (!_shouldBlockPrintToFileGlobal && shouldPrintToFile) {
      _fileLogger?.i(message, error: error, stackTrace: stackTrace);
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
      _consoleLogger?.w(message, error: error, stackTrace: stackTrace);
    }
    if (!_shouldBlockPrintToFileGlobal && shouldPrintToFile) {
      _fileLogger?.w(message, error: error, stackTrace: stackTrace);
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
      _consoleLogger?.e(message, error: error, stackTrace: stackTrace);
    }
    if (!_shouldBlockPrintToFileGlobal && shouldPrintToFile) {
      _fileLogger?.e(message, error: error, stackTrace: stackTrace);
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
      _consoleLogger?.f(message, error: error, stackTrace: stackTrace);
    }
    if (!_shouldBlockPrintToFileGlobal && shouldPrintToFile) {
      _fileLogger?.f(message, error: error, stackTrace: stackTrace);
    }
  }
}

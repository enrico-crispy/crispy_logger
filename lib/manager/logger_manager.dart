import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crispy_logger/crispy_logger.dart';
import 'package:crispy_logger/logger_defaults.dart';
import 'package:crispy_logger/utils/date_formatter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

abstract class LoggerManager {
  LoggerManager({
    this.storageLimit = 50000000,
    this.maxFileAgeInDays = 7,
    this.shouldBlockLogToFile = false,
  }) {
    init();
  }

  late final CrispyLogger? logger;

  /// If true the logger will not log anything to file. If false the parameter set in the logger will be respected.
  final bool shouldBlockLogToFile;

  /// The maximum size of the logs directory. Default is 50 MB
  final int storageLimit;

  /// File that are older than these value will be deleted. Default is 7 days.
  final int maxFileAgeInDays;

  late final String logDirPath;
  late final String currentFilePath;

  /// Initialize the manager:
  /// 1. Setup needed fields
  /// 2. Clean the log's directory
  /// 3. Compress past session log file
  Future<void> init() async {
    logDirPath = await logsDirectory;
    logger = await crispyLoggerProvider();

    await pruneDirectory();
    await compressFiles();
  }

  Future<CrispyLogger> crispyLoggerProvider() async {
    return CrispyLogger(
      shouldBlockPrintToFileGlobal: shouldBlockLogToFile,
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

  /// Create the log file that will be used by the logger during this session
  Future<File> createLogFile() async {
    final dir = await logsDirectory;
    final dateTime = DateTime.now();
    final formattedDateTime = DateFormatter.logFormat(dateTime);
    final filePath = '$dir$formattedDateTime.log';
    currentFilePath = filePath;

    return File(filePath).create(recursive: true);
  }

  /// Return the path of the directory that will be used to save the logs
  Future<String> get logsDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final logDir =
        await Directory('${appDir.path}/logs').create(recursive: true);
    return '${logDir.path}/';
  }

  /// Check if file is older than [maxFileAgeInDays] and if so deletes it.
  ///
  /// Returns true if the file is expired, false otherwise.
  bool _isFileExpired(FileSystemEntity file) {
    final expirationDate = DateTime.now().subtract(
      Duration(days: maxFileAgeInDays),
    );

    return expirationDate.compareTo(file.statSync().modified) > 0;
  }

  /// This function will delete log files that are expired or the older ones if size exceeds [storageLimit].
  Future<void> pruneDirectory() async {
    final logsDirectory = Directory(logDirPath);
    bool shouldDelete = false;
    int size = 0;

    // Ordered list of file, newest first
    List<FileSystemEntity> files = logsDirectory.listSync();

    List<FileSystemEntity> zippedFiles =
        files.where((file) => file.path.contains('.zip')).toList();
    files.removeWhere((file) => file.path.contains('.zip'));
    for (final zippedFile in zippedFiles) {
      final file = File(zippedFile.absolute.path);
      await decompressArchive(file);
      logger?.d('Deleting zip file: ${file.absolute.path}');
      await file.delete();
    }

    // Ordered list of file, newest first
    files = logsDirectory.listSync()
      ..sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );

    for (final file in files) {
      if (shouldDelete) {
        await file.delete();
      } else {
        if (_isFileExpired(file)) {
          // This file and the following ones are expired so we can delete them.
          shouldDelete = true;
        } else {
          // File is not expired so we add its size to the total
          size += (await file.stat()).size;
          shouldDelete = size > storageLimit;
        }
      }
    }
  }

  /// Extract the given archive into the log folder
  Future<void> decompressArchive(File file) async {
    final decoder = ZipDecoder();
    final bytes = await file.readAsBytes();
    final archive = decoder.decodeBytes(bytes);

    for (final entry in archive) {
      if (entry.isFile) {
        final fileBytes = entry.readBytes();
        final file = File('$logDirPath/${entry.name}');
        await file.create(recursive: true, exclusive: false);
        await file.writeAsBytes(fileBytes?.toList() ?? []);
      }
    }
  }

  /// Compress files inside the logs folder. 
  /// 
  /// If [includeCurrentFile] is true then every file will be included, otherwise the current file will not be included in the archive.
  Future<void> compressFiles({bool includeCurrentFile = false}) async {
    final logsDirectory = Directory(logDirPath);

    try {
      // Ordered list of file, newest first
      List<FileSystemEntity> files = logsDirectory.listSync();

      // Do not compress current log file
      if (!includeCurrentFile) {
        files.removeWhere((file) => file.absolute.path == currentFilePath);
      }

      if (files.isEmpty) {
        return;
      }

      // Decompress zipped files
      List<FileSystemEntity> zippedFiles =
          files.where((file) => file.path.contains('.zip')).toList();
      // Remove zipped file from the compressing list
      files.removeWhere((file) => file.path.contains('.zip'));
      for (final zippedFile in zippedFiles) {
        final file = File(zippedFile.absolute.path);
        await decompressArchive(file);
        logger?.d('Deleting zip file: ${file.absolute.path}');
        await file.delete();
      }

      // Reload file list because of extracted files
      files = logsDirectory.listSync();

      if (!includeCurrentFile) {
        files.removeWhere((file) => file.absolute.path == currentFilePath);
      }

      final encoder = ZipFileEncoder();
      final zipPath = _getZipPath();

      encoder.create(zipPath);

      for (final uncompressedFile in files) {
        await encoder.addFile(File(uncompressedFile.absolute.path));
        if (uncompressedFile.absolute.path != currentFilePath) {
          await uncompressedFile.delete();
        }
      }

      await encoder.close();
    } catch (e) {
      logger?.e(e);
    }
  }

  Future<void> sendLogs();

  /// Returns the archive containing the logs
  File get zipFile => (Directory(logDirPath)
      .listSync()
      .firstWhere((file) => file.path.contains('.zip')) as File);

  String _getZipPath() {
    final dateTime = DateTime.now();
    final formattedDateTime = DateFormatter.logFormat(dateTime);

    return '$logDirPath$formattedDateTime.zip';
  }
}

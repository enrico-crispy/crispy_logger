import 'dart:developer';

import 'package:logger/logger.dart';

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final StringBuffer buffer = StringBuffer();
    event.lines.forEach(buffer.writeln);
    log(buffer.toString());
  }
}

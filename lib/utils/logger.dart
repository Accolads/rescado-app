import 'package:logger/logger.dart';

Logger addLogger(String className) => Logger(printer: RescadoLogPrinter(className));

class RescadoLogPrinter extends LogPrinter {
  final String className;

  RescadoLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final now = DateTime.now();
    final emoji = PrettyPrinter.levelEmojis[event.level]!;
    final print = ['$emoji $now  ${_format(event.level)}  [$className]: ${event.message}'];

    if (event.error != null) {
      print.add('🙈  $now    ↳ ${event.error.toString()}');
    }
    if (event.stackTrace != null) {
      print.add(event.stackTrace.toString());
    }

    return print;
  }

  String _format(Level level) => level.toString().toUpperCase().substring(6);
}

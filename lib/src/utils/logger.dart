import 'package:logger/logger.dart';

Logger getLogger(String className) => Logger(printer: RescadoLogPrinter(className));

class RescadoLogPrinter extends LogPrinter {
  final String className;

  RescadoLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    var emoji = PrettyPrinter.levelEmojis[event.level]!;
    return ['$emoji ${DateTime.now()}  ${_format(event.level)}  [$className]: ${event.message}'];
  }

  String _format(Level level) => level.toString().toUpperCase().substring(6);
}

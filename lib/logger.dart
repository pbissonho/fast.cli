//Copyright 2020 Pedro Bissonho
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

import 'dart:convert';

import 'package:logger/logger.dart';

var logger = Logger(
    filter: MyFilter(),
    printer: MyPrettyPrinter(
      methodCount: 0, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 0, // width of the output
    ));

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class AnsiColor {
  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  static const ansiEsc = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  static const ansiDefault = '${ansiEsc}0m';

  final int fg;
  final int bg;
  final bool color;

  AnsiColor.none()
      : fg = null,
        bg = null,
        color = false;

  AnsiColor.fg(this.fg)
      : bg = null,
        color = true;

  AnsiColor.bg(this.bg)
      : fg = null,
        color = true;

  @override
  String toString() {
    if (fg != null) {
      return '${ansiEsc}38;5;${fg}m';
    } else if (bg != null) {
      return '${ansiEsc}48;5;${bg}m';
    } else {
      return '';
    }
  }

  String call(String msg) {
    if (color) {
      return '${this}$msg$ansiDefault';
    } else {
      return msg;
    }
  }

  AnsiColor toFg() => AnsiColor.fg(bg);

  AnsiColor toBg() => AnsiColor.bg(fg);

  /// Defaults the terminal's foreground color without altering the background.
  String get resetForeground => color ? '${ansiEsc}39m' : '';

  /// Defaults the terminal's background color without altering the foreground.
  String get resetBackground => color ? '${ansiEsc}49m' : '';

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}

class MyPrettyPrinter extends LogPrinter {
  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  static final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final bool colors;

  MyPrettyPrinter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    this.colors = true,
  });
  @override
  void log(LogEvent event) {
    final messageStr = stringifyMessage(event.message);

    String stackTraceStr;
    if (event.stackTrace == null) {
      if (methodCount > 0) {
        stackTraceStr = formatStackTrace(StackTrace.current, methodCount);
      }
    } else if (errorMethodCount > 0) {
      stackTraceStr = formatStackTrace(event.stackTrace, errorMethodCount);
    }

    final errorStr = event.error?.toString();

    formatAndPrint(event.level, messageStr, '', errorStr, stackTraceStr);
  }

  String formatStackTrace(StackTrace stackTrace, int methodCount) {
    var lines = stackTrace.toString().split('\n');

    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      var match = stackTraceRegex.matchAsPrefix(line);
      if (match != null) {
        if (match.group(2).startsWith('package:logger')) {
          continue;
        }
        var newLine = ('#$count   ${match.group(1)} (${match.group(2)})');
        formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
        if (++count == methodCount) {
          break;
        }
      } else {
        formatted.add(line);
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  String stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  AnsiColor _getLevelColor(Level level) {
    if (colors) {
      return levelColors[level];
    } else {
      return AnsiColor.none();
    }
  }

  AnsiColor _getErrorColor(Level level) {
    if (colors) {
      if (level == Level.wtf) {
        return levelColors[Level.wtf].toBg();
      } else {
        return levelColors[Level.error].toBg();
      }
    } else {
      return AnsiColor.none();
    }
  }

  Future<void> formatAndPrint(Level level, String message, String time,
      String error, String stacktrace) async {
    var color = _getLevelColor(level);

    if (error != null) {
      var errorColor = _getErrorColor(level);
      for (var line in error.split('\n')) {
        println(
          color('') +
              errorColor.resetForeground +
              errorColor(line) +
              errorColor.resetBackground,
        );
      }
    }

    if (stacktrace != null) {
      for (var line in stacktrace.split('\n')) {
        println('${color}$line');
      }
    }

    for (var line in message.split('\n')) {
      println(color('$line'));
    }
  }
}

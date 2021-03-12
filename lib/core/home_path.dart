import 'dart:io';

import 'package:fast/core/exceptions.dart';

String homePath() {
  final environmentVars = Platform.environment;
  if (Platform.isMacOS || Platform.isLinux) return environmentVars['HOME'];
  if (Platform.isWindows) return environmentVars['UserProfile'];

  throw UnsupportedPlatformException();
}

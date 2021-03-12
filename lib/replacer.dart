class Replacer {
  RegExp regex;
  final String argName;
  String value;

  Replacer(this.argName, [this.value]) {
    regex = RegExp('@$argName');
  }

  String replace(String string) {
    if (regex.hasMatch(string)) {
      return string.replaceAllMapped(regex, (mathe) => value);
    }

    return string;
  }
}

List<Replacer> createReplacers(Map<String, String> args) {
  final replacers = <Replacer>[];

  args.forEach((arg, value) {
    replacers.add(Replacer('${arg[0].toUpperCase()}${arg.substring(1)}',
        '${value[0].toUpperCase()}${value.substring(1)}'));
    replacers.add(Replacer(arg, value));
  });

  return replacers;
}

String replacerFile(String content, List<Replacer> replacers) {
  var newContent = content;
  for (var replacer in replacers) {
    newContent = replaceData(newContent, replacer);
  }

  return newContent;
}

String replaceData(String content, Replacer replacer) {
  String replaced;
  final contains = replacer.regex.hasMatch(content);
  if (contains) {
    replaced =
        content.replaceAllMapped(replacer.regex, (mathe) => replacer.value);
  }

  if (replaced == null) return content;
  return replaced;
}

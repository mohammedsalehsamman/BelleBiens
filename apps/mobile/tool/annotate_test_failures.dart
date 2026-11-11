// Turns `flutter test --reporter json` output into GitHub annotations, so a
// failing CI run shows which test failed and why without opening the log.
// Usage: dart run tool/annotate_test_failures.dart test-results.json
import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final names = <int, String>{};
  final errors = <int, StringBuffer>{};
  final failed = <int>{};

  for (final line in File(args.single).readAsLinesSync()) {
    if (!line.startsWith('{')) continue;
    final event = jsonDecode(line) as Map<String, dynamic>;
    switch (event['type']) {
      case 'testStart':
        final test = event['test'] as Map<String, dynamic>;
        names[test['id'] as int] = test['name'] as String;
      case 'error':
        (errors[event['testID'] as int] ??= StringBuffer())
          ..writeln(event['error'])
          ..writeln(event['stackTrace']);
      case 'testDone':
        if (event['result'] != 'success' && event['hidden'] != true) {
          failed.add(event['testID'] as int);
        }
    }
  }

  for (final id in failed) {
    final message = (errors[id]?.toString() ?? 'no error message')
        .replaceAll('%', '%25')
        .replaceAll('\r', '')
        .replaceAll('\n', '%0A');
    final short = message.length > 3000 ? message.substring(0, 3000) : message;
    stdout.writeln('::error title=${names[id] ?? 'test $id'}::$short');
  }
  stdout.writeln('${failed.length} failed test(s).');
}

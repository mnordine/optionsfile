import 'package:options_file/options_file.dart';

void main() {
  OptionsFile options =
      OptionsFile('example/local.options', defaults: 'example/default.options');

  // these values are read from default.options, as they aren't in local.options
  String? user = options.getString('user', defaultValue: 'bob');
  String? type = options.getString('type', defaultValue: 'advanced');

  // these values are read from local.options
  int? port = options.getInt('port', defaultValue: 1234);
  String? host = options.getString('host', defaultValue: 'www.dartlang.org');

  // this value isn't in either file, so the default here is used
  String? parity = options.getString('parity', defaultValue: 'even');

  print("user=$user");
  print("type=$type");
  print("port=$port");
  print("host=$host");
  print("parity=$parity");
}

library unittests;

import 'package:test/test.dart';
import 'package:options_file/options_file.dart';

import 'dart:io';

class FileIOExceptionMatcher extends Matcher {
  const FileIOExceptionMatcher();
  Description describe(Description description) =>
      description.add("FileIOException");
  bool matches(item, Map matchState) => item is FileSystemException;
}

class FormatExceptionMatcher extends Matcher {
  const FormatExceptionMatcher();
  Description describe(Description description) =>
      description.add("FormatException");
  bool matches(item, Map matchState) => item is FormatException;
}

void main() {
  test('Should throw exception when file is missing', () {
    expect(() {
      OptionsFile('bob');
    }, throwsA(FileIOExceptionMatcher()));
  });

  test('Should not throw exception when file is present', () {
    OptionsFile('pubspec.yaml');
  });

  test('Should read string value', () {
    var options = OptionsFile('test/options');
    var name = options.getString("name");
    expect("James", name);
  });

  test('Should ignore space around keys', () {
    var options = OptionsFile('test/options');
    var name = options.getString("name1");
    expect("James", name);

    name = options.getString("name2");
    expect("James", name);
  });

  test('Should ignore space around values', () {
    var options = OptionsFile('test/options');
    var name = options.getString("name3");
    expect("James", name);
  });

  test('Should read int value', () {
    var options = OptionsFile('test/options');
    var age = options.getInt("age");
    expect(90, age);
  });

  test('Should throw format exception when reading bad int', () {
    var options = OptionsFile('test/options');
    expect(() {
      options.getInt("name");
    }, throwsA(FormatExceptionMatcher()));
  });

  test('Should ignore comment lines', () {
    var options = OptionsFile('test/options');
    var thing = options.getInt("thing");
    expect(null, thing);
  });

  test('Should use default string value when option is missing', () {
    var options = OptionsFile('test/options');
    var wibble = options.getString("wibble", defaultValue: "default");
    expect("default", wibble);
  });

  test('Should use default int value when option is missing', () {
    var options = OptionsFile('test/options');
    var wibble = options.getInt("wibble", defaultValue: 123);
    expect(123, wibble);
  });

  test(
      'Should use default string value from default file when option is missing',
      () {
    var options = OptionsFile('test/options', defaults: 'test/defaultoptions');
    var wibble = options.getString("thing");
    expect("default", wibble);
  });

  test('Should use default int value from default file when option is missing',
      () {
    var options = OptionsFile('test/options', defaults: 'test/defaultoptions');
    var wibble = options.getInt("number");
    expect(12, wibble);
  });

  test('Should use default string value when option is missing in both files',
      () {
    var options = OptionsFile('test/options', defaults: 'test/defaultoptions');
    var wibble = options.getString("thing2", defaultValue: "xyz");
    expect("xyz", wibble);
  });

  test('Should use default int value when option is missing in both files', () {
    var options = OptionsFile('test/options', defaults: 'test/defaultoptions');
    var wibble = options.getInt("number2", defaultValue: 123);
    expect(123, wibble);
  });
}

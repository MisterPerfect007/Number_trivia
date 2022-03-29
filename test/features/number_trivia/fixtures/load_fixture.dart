import 'dart:io';

String loadFixture(String name) {
  return File('test/features/number_trivia/fixtures/$name').readAsStringSync();
  }

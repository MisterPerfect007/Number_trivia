import 'dart:io';

String loadFixture(String name) {
  return File('test/features/fixtures/$name').readAsStringSync();
  }

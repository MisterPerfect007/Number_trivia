import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  test('Should return the integer when the input is a valid',
      () {
    const String stringNumber = '1';
    const int number = 1;
    final result = inputConverter.stringToInt(stringNumber);

    expect(result, const Right(number));
  });

  test('Should return an InputConverterFailure when the input is not a valid integer', (){
    const String stringNumber = '1aa';
    final result = inputConverter.stringToInt(stringNumber);

    expect(result, Left(InputConverterFailure()));
  });

  test('Should return an InputConverterFailure when the input is negative int', (){
    const String stringNumber = '-2';
    final result = inputConverter.stringToInt(stringNumber);

    expect(result, Left(InputConverterFailure()));
  });
}

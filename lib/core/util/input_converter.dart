import 'package:dartz/dartz.dart';

import '../../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToInt(String stringNumber) {
    try {
      int number = int.parse(stringNumber);
      if (number >= 0) {
        return Right(number);
      } else {
        throw const FormatException();
      }
    } on FormatException {
      return Left(InputConverterFailure());
    }
  }
}

class InputConverterFailure extends Failure {}

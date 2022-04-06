import 'package:dartz/dartz.dart';

import '../../../../error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository{
  Future <Either<Failure, NumberTrivia>> getContreteNumberTrivia(int number);
  Future <Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  /// 
  /// throws a [ServerException] for all errors code.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  /// Calls the http://numbersapi.com/random endpoint.
  /// 
  /// throws a [ServerException] for all errors code.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
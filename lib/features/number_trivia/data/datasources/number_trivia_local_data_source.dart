import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource{
  /// Gets the cached [NumberTriviaModel] which was gotten the last time the user had internet connection.
  /// 
  /// Throws a [CacheException] when there is no cached data to retrieve
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Caches the last gotten [NumberTriviaModel]
  Future<void> cacheLastNumberTrivia(NumberTriviaModel triviaToCache);
}
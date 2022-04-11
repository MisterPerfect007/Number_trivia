import 'dart:convert';

import 'package:number_trivia_app/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

const String triviaKey = 'CACHED_TRIVIA_KEY';

abstract class NumberTriviaLocalDataSource{
  /// Gets the cached [NumberTriviaModel] which was gotten the last time the user had internet connection.
  /// 
  /// Throws a [CacheException] when there is no cached data to retrieve
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Caches the last gotten [NumberTriviaModel]
  Future<void> cacheLastNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<void> cacheLastNumberTrivia(NumberTriviaModel triviaToCache) async {
    await sharedPreferences.setString(triviaKey, jsonEncode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final String? triviaString = sharedPreferences.getString(triviaKey);
    if(triviaString != null){
      final triviaJson = jsonDecode(triviaString);
      return NumberTriviaModel.fromJson(triviaJson);
    }else {
      throw CacheException();
    }
  }
  
}
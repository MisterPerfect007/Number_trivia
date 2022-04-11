import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/error/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences sharedPreferences;
  late NumberTriviaLocalDataSourceImpl localDataSource;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    localDataSource =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });
  const NumberTriviaModel numberTriviaModel =
      NumberTriviaModel(text: 'test', number: 1);
  final String triviaString = jsonEncode(numberTriviaModel.toJson());

  test('Should cache data when cacheLastNumberTrivia will be call', () async {
    when(sharedPreferences.setString(
            triviaKey, triviaString))
        .thenAnswer((_) async => true);

    await localDataSource.cacheLastNumberTrivia(numberTriviaModel);

    verify(sharedPreferences.setString(
        triviaKey, triviaString));
    verifyNoMoreInteractions(sharedPreferences);
  });
  test(
      'Should return a valid NumberTriviaModel when a cached trivia is present',
      () async {
    when(sharedPreferences.getString(any)).thenReturn(triviaString);

    final result = await localDataSource.getLastNumberTrivia();

    expect(result, numberTriviaModel);
    verify(sharedPreferences.getString(triviaKey));
    verifyNoMoreInteractions(sharedPreferences);
  });
  test('Should return a CacheException when there no cached trivia present',
      () async {
    when(sharedPreferences.getString(triviaKey)).thenReturn(null);

    final call = localDataSource.getLastNumberTrivia;

    expect(() => call(), throwsA(isA<CacheException>()));
    verify(sharedPreferences.getString(triviaKey));
    verifyNoMoreInteractions(sharedPreferences);
  });
}

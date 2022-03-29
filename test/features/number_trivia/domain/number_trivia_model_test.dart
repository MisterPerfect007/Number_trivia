import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import '../fixtures/load_fixture.dart';

void main(){
  const  tNumberTriviaModel =  NumberTriviaModel(text: 'test', number: 0);

  test('Should NumberTriviaModel be a subclass of NumberTrivia entity', (){
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  
  test('Should return a valid model from json', () {
    //arrange
    final Map<String, dynamic> jsonMap = jsonDecode(loadFixture('number_trivia.json'));
    //act
    final result = NumberTriviaModel.fromJson(jsonMap);
    //assert
    expect(result, tNumberTriviaModel);
  });

  // test('Should return a valid json from model', () {
  //   //arrange
  //   final Map<String, dynamic> jsonMap = {
  //     "text": 'test',
  //     "number": 0
  //   };
  //   //act
  //   final result = tNumberTriviaModel.toJson();
  //   //assert
  //   expect(result, tNumberTriviaModel.toJson());
  // });
}
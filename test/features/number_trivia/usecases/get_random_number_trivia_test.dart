import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/usecases/usecase.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

void main(){
  final MockNumberTriviaRepository mockNumberTriviaRepository = MockNumberTriviaRepository();
  late GetRandomNumberTrivia usecases;

  setUp(
    () {
      usecases = GetRandomNumberTrivia(mockNumberTriviaRepository);
    }
  );
  const tNumberTrivia = NumberTrivia(text: 'test', number: 0);

  test('Should get a trivia from random number', () async {
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
      .thenAnswer((_) async => const Right(tNumberTrivia));
    //act
    final result = await usecases(NoParams());
    //assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
    
  });
}


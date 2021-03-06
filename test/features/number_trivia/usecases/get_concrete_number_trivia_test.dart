import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])

void main() {
  late GetConcreteNumberTrivia usecases;
  final MockNumberTriviaRepository mockNumberTriviaRepository = MockNumberTriviaRepository();
  
  setUp(() {
    usecases = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);/* The result we want to have */
  test('Should get trivia for the number from repository', () async {
    //arrage
    when(mockNumberTriviaRepository.getContreteNumberTrivia(tNumber))
        .thenAnswer((_) async => const Right(tNumberTrivia));
    //act
    final result = await usecases(const Params(tNumber));
    //assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getContreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}

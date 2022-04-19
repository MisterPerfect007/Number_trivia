import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';
import 'package:number_trivia_app/error/failures.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/presenter/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia])
@GenerateMocks([GetRandomNumberTrivia])
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia concrete;
  late MockGetRandomNumberTrivia random;
  late MockInputConverter inputConverter;

  setUp(() {
    concrete = MockGetConcreteNumberTrivia();
    random = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();

    numberTriviaBloc = NumberTriviaBloc(
        concrete: concrete, random: random, inputConverter: inputConverter);
  });

  group('GetTriviaForConcreteNumber : ', () {
    test('Should initial State be [NumberTriviainitial]', () {
      expect(numberTriviaBloc.state, NumberTriviaInitial());
    });

    const String tNumberString = "1";
    const int tNumber = 1;
    const numberTrivia = NumberTrivia(text: 'text', number: 1);

    void whenCallToConcreteSucceeded() => when(concrete.call(any))
        .thenAnswer((_) async => const Right(numberTrivia));

    void whenCallToInputConverterSucceeded() =>
        when(inputConverter.stringToInt(any)).thenReturn(const Right(tNumber));

    test(
        'numberTriviaBloc should make a call the inputConverter when event is GetTriviaForConcreteNumber',
        () async {
      whenCallToInputConverterSucceeded();
      whenCallToConcreteSucceeded();

      numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(inputConverter.stringToInt(any));

      verify(inputConverter.stringToInt(tNumberString));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should emit [NumberTriviaError] when inputConverter throws a Failure',
        setUp: () {
          when(inputConverter.stringToInt(any))
              .thenReturn(Left(InputConverterFailure()));
        },
        build: () => numberTriviaBloc,
        act: (bloc) =>
            bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [const NumberTriviaError(message: 'Erro')]);

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      '''Should emit [NumberTriviaLoading] 
        when the GetTriviaForConcreteNumber event is triggered 
      and inputConverter return a valid int''',
      setUp: () {
        whenCallToInputConverterSucceeded();
        whenCallToConcreteSucceeded();
      },
      build: () => numberTriviaBloc,
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          [NumberTriviaLoading(), const NumberTriviaLoaded(numberTrivia)],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should call the GetConcreteNumberTrivia 
        when the GetTriviaForConcreteNumber event is triggered 
      and inputConverter return a valid int''',
        setUp: () {
          whenCallToInputConverterSucceeded();
          whenCallToConcreteSucceeded();
        },
        build: () => numberTriviaBloc,
        act: (bloc) =>
            bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        verify: (_) {
          verify(concrete.call(const Params(tNumber))).called(1);
        });
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should emit [NumberTriviaLoaded] when call to getConcreteNumberTrivia succeeded''',
        setUp: () {
          whenCallToInputConverterSucceeded();
          whenCallToConcreteSucceeded();
        },
        build: () => numberTriviaBloc,
        act: (bloc) =>
            bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        // skip: 1,
        expect: () =>
            [NumberTriviaLoading(), const NumberTriviaLoaded(numberTrivia)]);
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should emit [NumberTriviaError] when call to getConcreteNumberTrivia failed''',
        setUp: () {
          whenCallToInputConverterSucceeded();
          when(concrete.call(const Params(tNumber)))
              .thenAnswer((_) async => Left(CacheFailure()));
        },
        build: () => numberTriviaBloc,
        act: (bloc) =>
            bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        // skip: 1,
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaError(message: '')
            ]);
    test('sss', () async {
      whenCallToInputConverterSucceeded();
          when(concrete.call(any))
              .thenAnswer((_) async => Left(CacheFailure()));
      numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(concrete.call(const Params(tNumber)));

      verify(concrete.call(const Params(tNumber)));
    });
  });
}

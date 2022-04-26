import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/usecases/usecase.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';
import 'package:number_trivia_app/error/errors_message.dart';
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
  const numberTrivia = NumberTrivia(text: 'text', number: 1);

  group('GetTriviaForConcreteNumber : ', () {
    test('Should initial State be [NumberTriviainitial]', () {
      expect(numberTriviaBloc.state, NumberTriviaInitial());
    });

    const String tNumberString = "1";
    const int tNumber = 1;

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
        'Should emit [NumberTriviaLoading, NumberTriviaError] when inputConverter throws a Failure',
        setUp: () {
          when(inputConverter.stringToInt(any))
              .thenReturn(Left(InputConverterFailure()));
        },
        build: () => numberTriviaBloc,
        act: (bloc) =>
            bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [NumberTriviaLoading() , const NumberTriviaError(message: inputErrorMessage)]);

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
        '''Should emit [NumberTriviaError] when call to 
        getConcreteNumberTrivia failed''',
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
              const NumberTriviaError(message: cacheErrorMessage)
            ]);
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should emit [NumberTriviaError] with the correct 
        message when call to getConcreteNumberTrivia failed''',
        setUp: () {
          whenCallToInputConverterSucceeded();
          when(concrete.call(const Params(tNumber)))
              .thenAnswer((_) async => Left(ServerFailure()));
        },
        build: () => numberTriviaBloc,
        act: (bloc) =>
            bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        // skip: 1,
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaError(message: serverErrorMessage)
            ]);
  });
  group('GetTriviaForConcreteNumber : ', () {
    void whenCallToRandomsucceeded() => when(random.call(NoParams()))
        .thenAnswer((_) async => const Right(numberTrivia));
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should emit [NumberTriviaLoading] when the 
      GetTriviaForRandomNumber event is trigger''',
        setUp: () {
          whenCallToRandomsucceeded();
        },
        build: () => numberTriviaBloc,
        act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaLoaded(numberTrivia),
            ]);
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should make a call to the GetRandomNumberTrivia 
      usecase when the GetTriviaForRandomNumber event is trigger''',
        setUp: () {
          whenCallToRandomsucceeded();
        },
        build: () => numberTriviaBloc,
        act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
        verify: (_) {
          verify(random.call(NoParams())).called(1);
        });
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should emit [NumberTriviaError] 
        with serverErrorMessage when a ServerFailure is 
        return from GetRandomNumberTrivia call''',
        setUp: () {
          when(random.call(NoParams()))
              .thenAnswer((_) async => Left(ServerFailure()));
        },
        build: () => numberTriviaBloc,
        act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaError(message: serverErrorMessage),
            ]);
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should emit [NumberTriviaError] 
        with cacheErrorMessage when a CacheFailure is 
        return from GetRandomNumberTrivia call''',
        setUp: () {
          when(random.call(NoParams()))
              .thenAnswer((_) async => Left(CacheFailure()));
        },
        build: () => numberTriviaBloc,
        act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaError(message: cacheErrorMessage),
            ]);
    blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''Should emit [NumberTriviaLoaded] 
        when a NumberTrivia is 
        return from GetRandomNumberTrivia call''',
        setUp: () {
          whenCallToRandomsucceeded();
        },
        build: () => numberTriviaBloc,
        act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaLoaded(numberTrivia),
            ]);
  });
}

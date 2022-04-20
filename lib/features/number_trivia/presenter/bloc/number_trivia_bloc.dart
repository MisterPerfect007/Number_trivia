import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_app/core/usecases/usecase.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';
import 'package:number_trivia_app/error/errors_message.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../../../error/failures.dart';
import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final intOrFailure = inputConverter.stringToInt(event.stringNumber);
        intOrFailure.fold(
            (failure) =>
                emit(const NumberTriviaError(message: inputErrorMessage)),
            (number) async {
          emit(NumberTriviaLoading());
          final triviaOrFailure = await concrete.call(Params(number));
          triviaOrFailure!.fold(
              (failure) => emit(
                  NumberTriviaError(message: _cacheOrServerMessage(failure))),
              (trivia) => emit(NumberTriviaLoaded(trivia)));
        });
      }
      if (event is GetTriviaForRandomNumber) {
        emit(NumberTriviaLoading());
        final failureOrTrivia = await random.call(NoParams());
        failureOrTrivia!.fold(
            (failure) => emit(
                NumberTriviaError(message: _cacheOrServerMessage(failure))),
            (trivia) => emit(NumberTriviaLoaded(trivia)));
      }
    });
  }
  String _cacheOrServerMessage(Failure failure) {
    if (failure is CacheFailure) {
      return cacheErrorMessage;
    } else if (failure is ServerFailure) {
      return serverErrorMessage;
    } else {
      return 'Unexpected Error';
    }
  }
}

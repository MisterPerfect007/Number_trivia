import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

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
    on<NumberTriviaEvent>((event, emit) {
      if (event is GetTriviaForConcreteNumber) {
        final eitherOuput = inputConverter.stringToInt(event.stringNumber);
        eitherOuput
            .fold((failure) => emit(const NumberTriviaError(message: 'Error')),
                (number) async {
          emit(NumberTriviaLoading());
          final eitherGetTriviaCall = await concrete.call(Params(number));
          eitherGetTriviaCall!.fold(
              (_) => emit(const NumberTriviaError(message: 'message')),
              (trivia) => emit(NumberTriviaLoaded(trivia)));
        });
      }

      //==> event is GetTriviaForRandomNumber
      //call the GetRandomNumberTrivia
      //emit [NumberTriviaLoading]
      //when success
      // emit [NumberTriviaLoaded] state
      //when failed
      // emit [NumberTriviaError] state
    });
  }
}

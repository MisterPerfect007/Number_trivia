
import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/error/failures.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>?> call(int number) async {
    return await repository.getContreteNumberTrivia(number);
  }
}
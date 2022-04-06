import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/core/platform/network_info.dart';
import 'package:number_trivia_app/error/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../error/failures.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  //if device is connected
  //then get fresh data from remote data source
  // otherwise get data from local data source
  @override
  Future<Either<Failure, NumberTrivia>> getContreteNumberTrivia(
      int number) async {
    networkInfo.isConnected;
    try {
      final NumberTriviaModel numberTriviaModel =
          await remoteDataSource.getConcreteNumberTrivia(number);
      await localDataSource.cacheLastNumberTrivia(numberTriviaModel);
      return Right(numberTriviaModel);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}

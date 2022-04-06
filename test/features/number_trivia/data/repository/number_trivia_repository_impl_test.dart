import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:number_trivia_app/core/platform/network_info.dart';
import 'package:number_trivia_app/error/exceptions.dart';
import 'package:number_trivia_app/error/failures.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaLocalDataSource])
@GenerateMocks([NumberTriviaRemoteDataSource])
@GenerateMocks([NetworkInfo])
//

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaLocalDataSource =
        MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSource =
        MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumbertrivia', () {
    const int tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(text: 'test', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
        'Should always check if device is connected or not when the getConcreteNumberTrivia is called',
        () async {
      //assert
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      await repository.getContreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });
    group('When device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'Should return remote data when the call to the remote data source is successful',
          () async {
        //arrage
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getContreteNumberTrivia(tNumber);
        //assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
          'Should cache remote data when call to the remote data source is successful',
          () async {
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getContreteNumberTrivia(tNumber);

        verify(mockNumberTriviaLocalDataSource
            .cacheLastNumberTrivia(tNumberTriviaModel));
      });
      test(
          'Should return a ServerFailure when the call to the remote data source failed',
          () async {
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        when(mockNumberTriviaLocalDataSource
                .cacheLastNumberTrivia(tNumberTriviaModel))
            .thenAnswer((realInvocation) async => print('object'));

        final result = await repository.getContreteNumberTrivia(tNumber);
        
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Left(ServerFailure())));
      });
    });
    group('When device is offline', () {});
  });
}

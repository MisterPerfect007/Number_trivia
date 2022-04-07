import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:number_trivia_app/core/networkInfo/network_info.dart';
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
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnLine(Function body) {
    group('When device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffLine(Function body) {
    group('When device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

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
    runTestOnLine(() {
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
    runTestOffLine(() {
      test(
          'Should return the last cached trivia when there is a cached number trivia existing',
          () async {
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getContreteNumberTrivia(tNumber);

        expect(result, const Right(tNumberTrivia));
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNever(mockNumberTriviaLocalDataSource.cacheLastNumberTrivia(any));
      });
      test(
          'Should return a cached failure when there is no cached number trivia',
          () async {
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getContreteNumberTrivia(tNumber);

        expect(result, Left(CacheFailure()));
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verifyNever(mockNumberTriviaLocalDataSource.cacheLastNumberTrivia(any));
      });
    });
  });
  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'text', number: 1);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
        'Should always check if device is online or not when getRandomNumberTrivia is called',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);

      await repository.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnLine(() {
      test(
          'Should return a number trivia when the call the remote data is successful',
          () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });
      test(
          'Should cache number trivia when the call the remote data is successful',
          () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getRandomNumberTrivia();

        verify(mockNumberTriviaLocalDataSource
            .cacheLastNumberTrivia(tNumberTriviaModel));
      });
      test(
          'Should return a Server failure when the call to the remote data is unsuccessful',
          () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        expect(result, Left(ServerFailure()));
      });
    });
    runTestOffLine(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('Should get cached data when there is present data', () async {
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        expect(result, const Right(tNumberTrivia));
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
      });
      test(
          'Should return a CacheFailure when there is no data present in the cacha',
          () async {
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        expect(result, Left(CacheFailure()));
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/platform/network_info.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/repository/number_trivia_repository_impl.dart';

class MockNumberTriviaLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}
class MockNumberTriviaRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{}
class MockNetworkInfo extends Mock implements NetworkInfo{}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    ); 
  });
}
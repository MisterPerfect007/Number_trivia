import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../fixtures/load_fixture.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late Map<String, String> defaultHeaders;
  late NumberTriviaModel tNumberTriviaModel;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
    defaultHeaders = {'Content-type': 'application/json'};
    tNumberTriviaModel = const NumberTriviaModel(text: 'test', number: 1);
  });

  void whenGetRequestSucceeded(){
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(loadFixture('number_from_api.json'), 200));
  }
   void whenGetRequestFailed(){
     when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Something went wrong', 404));
   }


  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final Uri uri = Uri.http('numbersapi.com', '/$tNumber');
    test(
        '''Should perform the GET request with a uri with number being the endpoint 
      and the right Content-type in the headers''', () async {
      whenGetRequestSucceeded();

      await dataSource.getConcreteNumberTrivia(tNumber);

      verify(
          mockClient.get(uri, headers: defaultHeaders));
      verifyNoMoreInteractions(mockClient);
    });

    //test a successful request
    test('Should return a valid NumberTriviaModel when GET request is successful', () async {
      whenGetRequestSucceeded();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(result, tNumberTriviaModel);
    });

    //test a unsuccessful request
    test('Should throw a ServerException when the GET request is unsuccessful', () async {
      whenGetRequestFailed();

      final call =  dataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(isA<ServerException>()));

    });
  });

  //GetRandomNumberTrivia
  group('getRandomNumberTrivia', (){
    final Uri uri = Uri.http('numbersapi.com', '/random');
    //test if the url and the headers are the correct ones
    test('Should perform the GET request with right URL and Headers', () async {
      whenGetRequestSucceeded();

      await dataSource.getRandomNumberTrivia();

      verify(mockClient.get(uri, headers: defaultHeaders));
    });
    //test a successful request
    test('Should return a valid NumberTriviaModel when the GET request is successful', () async {
      whenGetRequestSucceeded();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, tNumberTriviaModel);
    });
    //test an unsuccessful request
    test('Should throw a ServerException when the GET request is unsuccessful', (){
      whenGetRequestFailed();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}

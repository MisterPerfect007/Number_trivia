import 'dart:convert';

import 'package:http/http.dart';
import 'package:number_trivia_app/error/exceptions.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  /// 
  /// throws a [ServerException] for all errors code.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  /// Calls the http://numbersapi.com/random endpoint.
  /// 
  /// throws a [ServerException] for all errors code.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async{
    final uri = Uri.http('numbersapi.com', '/$number');
    final response = await client.get(uri, 
    headers: {'Content-type': 'application/json'});
    if(response.statusCode == 200){
      final body = response.body;
      return NumberTriviaModel.fromJson(jsonDecode(body));
    } else {
      throw ServerException();
    }
    
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final uri = Uri.http('numbersapi.com', '/random');
    final response = await client.get(uri, 
    headers: {'Content-type': 'application/json'});
    if(response.statusCode == 200){
      final body = response.body;
      return NumberTriviaModel.fromJson(jsonDecode(body));
    } else {
      throw ServerException();
    }
  }

}
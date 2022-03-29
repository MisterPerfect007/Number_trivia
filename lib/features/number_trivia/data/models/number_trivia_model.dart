import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia{

  const NumberTriviaModel({required String text, required int number})  : super(number: number, text: text);

  factory NumberTriviaModel.fromJson( Map<String, dynamic> json ){
    return NumberTriviaModel(text: json['text'], number: (json['number']).toInt());
  }
}
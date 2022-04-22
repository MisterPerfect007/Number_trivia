import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia_app/features/number_trivia/presenter/bloc/number_trivia_bloc.dart';
import 'package:number_trivia_app/features/number_trivia/presenter/pages/number_page.dart';
import 'package:number_trivia_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocProvider(
        create: (context) => di.sl<NumberTriviaBloc>(),
        child: const NumberTriviaPage()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/presenter/bloc/number_trivia_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            height: size.height * 0.8,
            child: BuildBody()),
      ),
    );
  }

}

class BuildBody extends StatefulWidget {
  const BuildBody({
    Key? key,
  }) : super(key: key);

  @override
  State<BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<BuildBody> {
  late String inputStr;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height: 20),
        // Upper half
        Display(),
        SizedBox(height: 20),
        //Lower half
        Expanded(
          child: Center(
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => inputStr = value,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () => context.read<NumberTriviaBloc>().add(
                            GetTriviaForConcreteNumber(inputStr)),
                        child: Text('Search'),
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Get random trivia'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey))),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class TriviaTextField extends StatefulWidget {
  const TriviaTextField({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaTextField> createState() => _TriviaTextFieldState();
}

class _TriviaTextFieldState extends State<TriviaTextField> {
  late String inputStr;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) => inputStr = value,
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }
}

class Display extends StatelessWidget {
  const Display({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height / 3,
        child: Center(
          child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) {
              if (state is NumberTriviaInitial) {
                return ShowInfo(info: 'Start Searching !');
              }
              // NumberTriviaIntial
              // NumberTriviaLoading
              else if (state is NumberTriviaLoading) {
                return CircularProgressIndicator();
              }
              // NumberTriviaLoaded
              else if (state is NumberTriviaLoaded) {
                return ShowNumberTrivia(
                  numberTrivia: state.trivia,
                );
              } else if (state is NumberTriviaError) {
                return ShowInfo(info: state.message);
              } else {
                return Text('Something went wrong');
              }
              // NumberTriviaError
            },
          ),
        ));
  }
}

class ShowNumberTrivia extends StatelessWidget {
  final NumberTrivia numberTrivia;
  const ShowNumberTrivia({Key? key, required this.numberTrivia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        '${numberTrivia.number}',
        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
      ),
      Expanded(child: ShowInfo(info: numberTrivia.text))
    ]);
  }
}

class ShowInfo extends StatelessWidget {
  final String info;
  const ShowInfo({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(
        info,
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

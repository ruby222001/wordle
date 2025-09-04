import 'package:flutter/material.dart';
import 'package:wordle_app/page/dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_app/wordle/wordle_bloc.dart';


void main() {
  runApp(const WordleApp());
}

class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WordleBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wordle Game',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: WordleGame(),
      ),
    );
  }
}

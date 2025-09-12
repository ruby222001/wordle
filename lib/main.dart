import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_app/page/dashboard.dart';
import 'package:wordle_app/theme/theme.dart';
import 'package:wordle_app/wordle/wordle_bloc.dart';

void main() {
  runApp(const WordleApp());
}

class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WordleBloc()),
        BlocProvider(create: (_) => ThemeBloc()), // <-- add ThemeBloc
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Wordle Game',
            theme: themeState.themeData, // <-- dynamic theme
            home: WordleGame(),
          );
        },
      ),
    );
  }
}

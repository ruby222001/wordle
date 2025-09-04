import 'package:flutter/material.dart';

abstract class WordleEvent {}

class AddLetter extends WordleEvent {
  final String letter;
  AddLetter(this.letter);
}

class RemoveLetter extends WordleEvent {}

class SubmitGuess extends WordleEvent {
  final VoidCallback onCorrect;
  final VoidCallback onFail;

  SubmitGuess({required this.onCorrect, required this.onFail});
}

class NextGame extends WordleEvent {}

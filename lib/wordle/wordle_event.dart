import 'package:flutter/material.dart';

abstract class WordleEvent {}
//add letter
class AddLetter extends WordleEvent {
  final String letter;
  AddLetter(this.letter);
}

//remove letter

class RemoveLetter extends WordleEvent {}

//submit guess
class SubmitGuess extends WordleEvent {
  final VoidCallback onCorrect;
  final VoidCallback onFail;
  final VoidCallback onInvalidWord; 

  SubmitGuess({
    required this.onCorrect,
    required this.onFail,
    required this.onInvalidWord,
  });
}


//next game
class NextGame extends WordleEvent {}

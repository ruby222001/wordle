import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wordle_event.dart';
import 'wordle_state.dart';

class WordleBloc extends Bloc<WordleEvent, WordleState> {
  //word
  final List<String> words = [
    "APPLE",
    "GRAPE",
    "PEARL",
    "PLUMB",
    "CRANE",
    "SLATE",
    "FROST",
    "GUILD",
    "SHARP",
    "TRACK",
    "VOUCH"
  ];
//initial phase will load the app here
  late final List<String> validWords;

  WordleBloc() : super(WordleState.initial()) {
    validWords = all
        .where((word) => word.length == 5)
        .map((word) => word.toUpperCase())
        .toList();

//in any event invokes these functions
    on<AddLetter>(_onAddLetter);
    on<RemoveLetter>(_onRemoveLetter);
    on<SubmitGuess>(_onSubmitGuess);
    on<NextGame>(_onNextGame);
  }

//to add letter in box

  void _onAddLetter(AddLetter event, Emitter<WordleState> emit) {
    if (state.currentGuess.length < state.targetWord.length) {
      emit(state.copyWith(currentGuess: state.currentGuess + event.letter));
    }
  }

//In your Bloc, emit is how you send out a new state to the UI.
//clear the letter
  void _onRemoveLetter(RemoveLetter event, Emitter<WordleState> emit) {
    if (state.currentGuess.isNotEmpty) {
      emit(state.copyWith(
          currentGuess:
              state.currentGuess.substring(0, state.currentGuess.length - 1)));
    }
  }

  //to submit guess
  void _onSubmitGuess(SubmitGuess event, Emitter<WordleState> emit) {
    //if letter is not equal to targetted word length
    if (state.currentGuess.length != state.targetWord.length) return;

    final guess = state.currentGuess.toUpperCase();

    if (!validWords.contains(guess)) {
      event.onInvalidWord();
      emit(state.copyWith(currentGuess: ""));
      return;
    }

    final updatedGuesses = List<String>.from(state.guesses)..add(guess);

//if guess is equal to target word
    if (guess == state.targetWord) {
      // then show event
      event.onCorrect();
    } else if (updatedGuesses.length >= state.maxAttempts) {
      event.onFail();
    }

    emit(state.copyWith(
      guesses: updatedGuesses,
      currentGuess: "",
    ));
  }
//next game

  void _onNextGame(NextGame event, Emitter<WordleState> emit) {
    //increase current word index
    final nextIndex = state.currentWordIndex + 1;
    if (nextIndex < words.length) {
      emit(WordleState(
        targetWord: words[nextIndex],
        guesses: [],
        currentGuess: "",
        currentWordIndex: nextIndex,
        maxAttempts: state.maxAttempts,
      ));
    }
  }

  /// Return feedback for a guess
  List<String> checkGuess(String guess) {
    List<String> feedback = List.filled(state.targetWord.length, "white");
    for (int i = 0; i < state.targetWord.length; i++) {
      // if guess index and target word index matches
      if (guess[i] == state.targetWord[i]) {
        feedback[i] = "green";
        // if the index contain in any idex then yellow
      } else if (state.targetWord.contains(guess[i])) {
        feedback[i] = "yellow";
      }
    }
    return feedback;
  }
}

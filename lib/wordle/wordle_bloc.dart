import 'package:english_words/english_words.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wordle_event.dart';
import 'wordle_state.dart';

class WordleBloc extends Bloc<WordleEvent, WordleState> {

  //word
  final List<String> words = [
    "APPLE",
    "GRAPE",
    "MANGO",
    "PEACH",
    "BERRY",
    "LEMON",
    "OLIVE",
    "CHILI",
    "BREAD",
    "CRISP"
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

  void _onRemoveLetter(RemoveLetter event, Emitter<WordleState> emit) {
    if (state.currentGuess.isNotEmpty) {
      emit(state.copyWith(
          currentGuess:
              state.currentGuess.substring(0, state.currentGuess.length - 1)));
    }
  }

  void _onSubmitGuess(SubmitGuess event, Emitter<WordleState> emit) {
  if (state.currentGuess.length != state.targetWord.length) return;

  final guess = state.currentGuess.toUpperCase();

  // ✅ Check if the guess is a real English word
  if (!validWords.contains(guess)) {
    // You can show a dialog or just ignore
    event.onFail(); // or call a separate "invalid word" callback
    return;
  }

  final updatedGuesses = List<String>.from(state.guesses)..add(guess);

  if (guess == state.targetWord) {
    event.onCorrect();
  } else if (updatedGuesses.length >= state.maxAttempts) {
    event.onFail();
  }

  emit(state.copyWith(
    guesses: updatedGuesses,
    currentGuess: "",
  ));
}


  void _onNextGame(NextGame event, Emitter<WordleState> emit) {
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
    List<String> feedback = List.filled(state.targetWord.length, "gray");
    for (int i = 0; i < state.targetWord.length; i++) {
      if (guess[i] == state.targetWord[i]) {
        feedback[i] = "green";
      } else if (state.targetWord.contains(guess[i])) {
        feedback[i] = "yellow";
      }
    }
    return feedback;
  }
}

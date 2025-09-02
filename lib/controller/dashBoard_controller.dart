
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:english_words/english_words.dart';

class WordleController extends GetxController {
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

  var currentWordIndex = 0.obs;
  late String targetWord;

  var guesses = <String>[].obs; // completed guesses
  var currentGuess = "".obs; // typing guess
  final int maxAttempts = 6;

  @override
  void onInit() {
    super.onInit();
    _loadNextWord();
    loadValidWords();
  }

  List<String> validWords = [];

  void loadValidWords() {
    validWords = all
        .where((word) => word.length == 5) 
        .map((word) => word.toUpperCase()) 
        .toList();
  }

  void _loadNextWord() {
    if (currentWordIndex < words.length) {
      targetWord = words[currentWordIndex.value];
      guesses.clear();
      currentGuess.value = "";
    } else {
    }
  }

  void addLetter(String letter) {
    if (currentGuess.value.length < targetWord.length) {
      currentGuess.value += letter;
    }
  }

  void removeLetter() {
    if (currentGuess.value.isNotEmpty) {
      currentGuess.value =
          currentGuess.value.substring(0, currentGuess.value.length - 1);
    }
  }

void submitGuess({required VoidCallback onCorrect, required VoidCallback onFail}) {
  if (currentGuess.value.length != targetWord.length) return;

  final guess = currentGuess.value.toUpperCase();
  guesses.add(guess);

  if (guess == targetWord) {
    onCorrect(); 
  } else if (guesses.length >= maxAttempts) {
    onFail(); 
  } else {
    currentGuess.value = "";
  }
}


  void nextGame() {
    currentWordIndex++;
    _loadNextWord();
  }

  /// Return feedback for a guess (list of colors for each letter)
  List<String> checkGuess(String guess) {
    List<String> feedback = List.filled(targetWord.length, "gray");

    for (int i = 0; i < targetWord.length; i++) {
      if (guess[i] == targetWord[i]) {
        feedback[i] = "green";
      } else if (targetWord.contains(guess[i])) {
        feedback[i] = "yellow";
      }
    }
    return feedback;
  }
}

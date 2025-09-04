class WordleState {
  final String targetWord;
  final List<String> guesses;
  final String currentGuess;
  final int currentWordIndex;
  final int maxAttempts;
  final Map<String, String> letterStatus; // stores color info

  WordleState({
    required this.targetWord,
    required this.guesses,
    required this.currentGuess,
    required this.currentWordIndex,
    required this.maxAttempts,
    required this.letterStatus,
  });

  factory WordleState.initial() {
    return WordleState(
      targetWord: "APPLE",
      guesses: [],
      currentGuess: "",
      currentWordIndex: 0,
      maxAttempts: 6,
      letterStatus: {}, // start empty
    );
  }

  WordleState copyWith({
    String? targetWord,
    List<String>? guesses,
    String? currentGuess,
    int? currentWordIndex,
    int? maxAttempts,
    Map<String, String>? letterStatus,
  }) {
    return WordleState(
      targetWord: targetWord ?? this.targetWord,
      guesses: guesses ?? this.guesses,
      currentGuess: currentGuess ?? this.currentGuess,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      letterStatus: letterStatus ?? this.letterStatus,
    );
  }
}

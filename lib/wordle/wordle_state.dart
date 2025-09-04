class WordleState {
  final String targetWord;
  final List<String> guesses;
  final String currentGuess;
  final int currentWordIndex;
  final int maxAttempts;

  WordleState({
    required this.targetWord,
    required this.guesses,
    required this.currentGuess,
    required this.currentWordIndex,
    required this.maxAttempts,
  });

  factory WordleState.initial() {
    return WordleState(
      targetWord: "APPLE",
      guesses: [],
      currentGuess: "",
      currentWordIndex: 0,
      maxAttempts: 6,
    );
  }

  WordleState copyWith({
    String? targetWord,
    List<String>? guesses,
    String? currentGuess,
    int? currentWordIndex,
    int? maxAttempts,
  }) {
    return WordleState(
      targetWord: targetWord ?? this.targetWord,
      guesses: guesses ?? this.guesses,
      currentGuess: currentGuess ?? this.currentGuess,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      maxAttempts: maxAttempts ?? this.maxAttempts,
    );
  }
}

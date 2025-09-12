import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wordle_app/theme/theme.dart';
import 'package:wordle_app/wordle/wordle_bloc.dart';
import 'package:wordle_app/wordle/wordle_event.dart';
import 'package:wordle_app/wordle/wordle_state.dart';

class WordleGame extends StatefulWidget {
  const WordleGame({super.key});

  @override
  State<WordleGame> createState() => _WordleGameState();
}

class _WordleGameState extends State<WordleGame> {
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();

    // ✅ Show welcome dialog only once
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Welcome!!!",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: Image.asset('assets/wordle.png'),
        ),
      );
    });
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordleBloc, WordleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Wordle Game",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Round ${state.currentWordIndex + 1}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: List.generate(state.maxAttempts, (row) {
                    String guess = row < state.guesses.length
                        ? state.guesses[row]
                        : (row == state.guesses.length
                            ? state.currentGuess
                            : "");

                    List<String> feedback = row < state.guesses.length
                        ? context.read<WordleBloc>().checkGuess(guess)
                        : List.filled(state.targetWord.length, "empty");

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(state.targetWord.length, (i) {
                        String letter = i < guess.length ? guess[i] : "";
                        Color color;
                        if (feedback[i] == "green") {
                          color = Colors.green;
                        } else if (feedback[i] == "yellow") {
                          color = Colors.orange;
                        } else if (feedback[i] == "gray") {
                          color =
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade700;
                        } else {
                          color =
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade900
                                  : Colors.black12;
                        }

                        return Container(
                          margin: const EdgeInsets.all(4),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
              buildKeyboard(context),
            ],
          ),
        );
      },
    );
  }

  Widget buildKeyboard(BuildContext context) {
    final keys = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"];

    return Column(
      children: [
        for (var row in keys)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.split("").map((letter) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () =>
                      context.read<WordleBloc>().add(AddLetter(letter)),
                  child: Container(
                    width: 30,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: () {
                        final status = context
                            .read<WordleBloc>()
                            .state
                            .letterStatus[letter];
                        if (status == "green") return Colors.green;
                        if (status == "yellow") return Colors.orange;
                        if (status == "gray") return Colors.black;
                        return Colors.blueGrey.shade700; // default
                      }(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      letter,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //CLEAR text
              GestureDetector(
                onTap: () => context.read<WordleBloc>().add(RemoveLetter()),
                child: Container(
                  width: 80,
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("Clear",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //submit
              GestureDetector(
                onTap: () {
                  context.read<WordleBloc>().add(
                        SubmitGuess(
                          onInvalidWord: () {
                            showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                title: Text("Not a Word",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                                content: Text("Please enter a valid word.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                              ),
                            );
                          },
                          onCorrect: () async {
                            confettiController.play();

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.white,
                                content: SizedBox(
                                  height: 150,
                                  child: Lottie.asset('assets/json/sucess.json',
                                      repeat: false),
                                ),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<WordleBloc>()
                                          .add(NextGame());
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Next Round",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onFail: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text(
                                  "Out of tries!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                content: const Text("Better luck next time!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<WordleBloc>()
                                          .add(NextGame());
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Next Round",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                },
                child: Container(
                  width: 80,
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("Submit",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_app/wordle/wordle_bloc.dart';
import 'package:wordle_app/wordle/wordle_event.dart';
import 'package:wordle_app/wordle/wordle_state.dart';


class WordleGame extends StatelessWidget {
  WordleGame({super.key});
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(title: Text("Welcome!")),
      );
    });

    return BlocBuilder<WordleBloc, WordleState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: const Text("Wordle"), centerTitle: true),
              body: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      children: List.generate(state.maxAttempts, (row) {
                        String guess = row < state.guesses.length
                            ? state.guesses[row]
                            : (row == state.guesses.length ? state.currentGuess : "");

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
                              color = Colors.grey.shade700;
                            } else {
                              color = Colors.black12;
                            }

                            return Container(
                              margin: const EdgeInsets.all(4),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
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
            ),
          ],
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
                  onTap: () => context.read<WordleBloc>().add(AddLetter(letter)),
                  child: Container(
                    width: 30,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade700,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            GestureDetector(
              onTap: () {
                context.read<WordleBloc>().add(
                      SubmitGuess(
                        onCorrect: () {
                          confettiController.play();
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("🎉 Correct!"),
                              content: const Text("You guessed correctly!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.read<WordleBloc>().add(NextGame());
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Next Round"),
                                ),
                              ],
                            ),
                          );
                        },
                        onFail: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Out of tries!"),
                              content: const Text("Better luck next time!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.read<WordleBloc>().add(NextGame());
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Next Round"),
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
      ],
    );
  }
}

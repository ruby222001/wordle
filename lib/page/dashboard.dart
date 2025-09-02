import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_app/component/pop_up.dart';
import 'package:wordle_app/controller/dashBoard_controller.dart';

class WordleGame extends StatelessWidget {
  WordleGame({super.key});
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WordleController());
    Future.delayed(Duration.zero, () {
      Get.dialog(const PopUp());
    });
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text("Wordle"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            // Guess Grid
            Expanded(
              child: Obx(() {
                return Column(
                  children: List.generate(controller.maxAttempts, (row) {
                    String guess = row < controller.guesses.length
                        ? controller.guesses[row]
                        : (row == controller.guesses.length
                            ? controller.currentGuess.value
                            : "");

                    List<String> feedback = row < controller.guesses.length
                        ? controller.checkGuess(guess)
                        : List.filled(controller.targetWord.length, "empty");

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(controller.targetWord.length, (i) {
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
                );
              }),
            ),

            // Custom Keyboard
            buildKeyboard(controller),
          ],
        ),
      ),
    ]);
  }
            // Custom Keyboard

  Widget buildKeyboard(WordleController controller) {
    final keys = [
      "QWERTYUIOP",
      "ASDFGHJKL",
      "ZXCVBNM",
    ];

    return Column(
      children: [
        for (var row in keys)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.split("").map((letter) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () => controller.addLetter(letter),
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
        // Clear + Submit row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: controller.removeLetter,
              child: Container(
                width: 80,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Clear",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.submitGuess(
                  onCorrect: () {
                    confettiController.play();
                    Get.dialog(
                      AlertDialog(
                        title: const Text("🎉 Correct!"),
                        content: Text(
                            "You guessed '${controller.targetWord}' correctly!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              controller.nextGame();
                              Get.back();
                            },
                            child: const Text("Next Round"),
                          ),
                        ],
                      ),
                      barrierDismissible: false,
                    );
                  },
                  onFail: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Out of tries!"),
                        content: Text(
                            "The correct word was '${controller.targetWord}'"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              controller.nextGame();
                              Get.back();
                            },
                            child: const Text("Next Round"),
                          ),
                        ],
                      ),
                      barrierDismissible: false,
                    );
                  },
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
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

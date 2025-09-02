import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_app/page/dashboard.dart';

class PopUp extends StatelessWidget {
  const PopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/wordle.png'),
          SizedBox(width: 60,),
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Okay',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ))
        ],
      ),
    );
  }
}

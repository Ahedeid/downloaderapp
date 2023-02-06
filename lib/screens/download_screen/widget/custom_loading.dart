import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    super.key,
    required this.progress,
  });

  final double progress;


  @override
  Widget build(BuildContext context) {
    print(progress);
    return Column(children: [
       CircularProgressIndicator(
        backgroundColor: Colors.black,
        valueColor: const AlwaysStoppedAnimation(Colors.orange),
        strokeWidth: 10,
        value: progress,
      ),
      const SizedBox(
        height: 15,
      ),
      LinearProgressIndicator(
        backgroundColor: Colors.black,
        valueColor: const AlwaysStoppedAnimation(Colors.orange),
        minHeight: 10,
        color: Colors.white,
        value: progress,
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        '${(progress/100).toStringAsFixed(0)}%',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ]);
  }
}
//${(progress/100).toStringAsFixed(0)}
import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const CircularProgressIndicator(
        backgroundColor: Colors.black,
        valueColor: AlwaysStoppedAnimation(Colors.orange),
        strokeWidth: 10,
      ),
      const SizedBox(
        height: 15,
      ),
      LinearProgressIndicator(
        backgroundColor: Colors.black,
        valueColor: const AlwaysStoppedAnimation(Colors.orange),
        minHeight: 10,
        value: progress,
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        '${(progress / 100000).toStringAsFixed(1)}+%',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ]);
  }
}

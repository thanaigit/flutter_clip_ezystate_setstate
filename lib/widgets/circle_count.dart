import 'package:flutter/material.dart';

class CircleCount extends StatelessWidget {
  final int? value;
  const CircleCount({
    Key? key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          (value != null) ? value.toString() : '',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

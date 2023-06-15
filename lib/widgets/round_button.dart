import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false,
      this.color = Colors.deepPurple,
      this.borderRadius = 10.0});
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final Color color;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurple,
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}

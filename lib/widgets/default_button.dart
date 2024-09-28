import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final double radius;
  final Function()? onTap;
  const DefaultButton({super.key, required this.text, required this.radius, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Center(child: Text(text)),
      ),
    );
  }
}

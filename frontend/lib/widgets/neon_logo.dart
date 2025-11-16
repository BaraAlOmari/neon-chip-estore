import 'package:flutter/material.dart';

class NeonLogo extends StatelessWidget {
  const NeonLogo({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.7), blurRadius: 18, spreadRadius: 1),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.memory, color: color, size: size - 2),
        ),
      ),
    );
  }
}


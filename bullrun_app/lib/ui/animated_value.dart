import 'package:flutter/material.dart';

class AnimatedValue extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final String suffix;

  const AnimatedValue({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 600),
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: value, end: value),
      duration: duration,
      builder: (context, val, child) {
        return Text(
          '$prefix${val.toStringAsFixed(0)}$suffix',
          style: style,
        );
      },
    );
  }
}

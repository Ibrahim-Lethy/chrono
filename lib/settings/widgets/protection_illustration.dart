import 'package:flutter/material.dart';

class ProtectionIllustration extends StatelessWidget {
  const ProtectionIllustration({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = size * 0.68;
    final height = size;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.38),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          Positioned(
            top: height * 0.08,
            bottom: height * 0.08,
            left: 0,
            right: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            top: height * 0.19,
            left: width * 0.13,
            right: width * 0.13,
            child: Column(
              children: [
                _Bar(width: width * 0.74, color: colorScheme.onSurface),
                const SizedBox(height: 14),
                _Bar(width: width * 0.6, color: colorScheme.onSurface),
                const SizedBox(height: 26),
                _TaskRow(
                  color: Colors.amber,
                  checked: false,
                  accent: colorScheme.primary,
                ),
                const SizedBox(height: 20),
                _TaskRow(
                  color: colorScheme.primaryContainer,
                  checked: true,
                  accent: colorScheme.primary,
                ),
                const SizedBox(height: 20),
                _TaskRow(
                  color: colorScheme.secondaryContainer,
                  checked: false,
                  accent: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.color,
    required this.checked,
    required this.accent,
  });

  final Color color;
  final bool checked;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Bar(width: 44, height: 3, color: accent),
              const SizedBox(height: 8),
              _Bar(width: 68, height: 3, color: onSurface),
              const SizedBox(height: 8),
              _Bar(width: 88, height: 3, color: onSurface),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Icon(
          checked ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          color: checked ? Colors.green : color.withOpacity(0.8),
          size: 22,
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.width,
    required this.color,
    this.height = 14,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.82),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

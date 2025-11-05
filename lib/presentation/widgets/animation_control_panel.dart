import 'package:flutter/material.dart';

class AnimationControlPanel extends StatelessWidget {
  final bool isAnimating;
  final bool isPaused;
  final VoidCallback onToggle;
  final VoidCallback onStop;

  const AnimationControlPanel({
    super.key,
    required this.isAnimating,
    required this.isPaused,
    required this.onToggle,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  isAnimating && !isPaused
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                ),
                iconSize: 48,
                color: Theme.of(context).primaryColor,
                onPressed: onToggle,
              ),
              IconButton(
                icon: const Icon(Icons.stop_circle_outlined),
                iconSize: 48,
                color: Colors.red,
                onPressed: onStop,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

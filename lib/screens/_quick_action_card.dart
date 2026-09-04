import 'package:flutter/material.dart';

/// A small reusable card used in the home screen for quick actions.
/// It displays an icon and a label, and triggers [onTap] when the
/// user taps the card.
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard(
    {
      required this.icon,
      required this.label,
      required this.onTap,
      Key? key,
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The card is intentionally simple and theme‑aware. It casts
    // itself inside an Expanded so callers don’t need to worry
    // about sizing.
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

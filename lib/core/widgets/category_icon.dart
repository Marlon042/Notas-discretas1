import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool selected;

  const CategoryIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: selected ? 28 : 24,
            backgroundColor: color.withOpacity(selected ? 0.22 : 0.13),
            child: Icon(icon, color: color, size: selected ? 32 : 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? color : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

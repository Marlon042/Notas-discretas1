import 'package:flutter/material.dart';
import 'package:prueba/core/widgets/category_icon.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> kCategories = [
    {'label': 'General', 'icon': Icons.notes, 'color': Colors.blueGrey},
    {'label': 'Trabajo', 'icon': Icons.work, 'color': Colors.blue},
    {'label': 'Escuela', 'icon': Icons.school, 'color': Colors.red},
    {'label': 'Personal', 'icon': Icons.person, 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () => onCategorySelected('Todas'),
            child: Column(
              children: [
                const CategoryIcon(
                  icon: Icons.all_inclusive,
                  label: "Todas",
                  color: Colors.grey,
                ),
                if (selectedCategory == 'Todas')
                  Container(width: 48, height: 4, color: Colors.grey),
              ],
            ),
          ),
          ...kCategories.map((cat) {
            final isSelected = selectedCategory == cat['label'];
            return GestureDetector(
              onTap: () => onCategorySelected(cat['label']),
              child: Column(
                children: [
                  CategoryIcon(
                    icon: cat['icon'],
                    label: cat['label'],
                    color: cat['color'],
                  ),
                  if (isSelected)
                    Container(width: 48, height: 4, color: cat['color']),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

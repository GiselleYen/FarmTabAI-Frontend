import 'package:flutter/material.dart';

import '../../../models/organization.dart';
import '../../../theme/color_extension.dart';

class FilterBar extends StatelessWidget {
  final List<Organization> organizations;
  final String? selectedFilter;
  final Function(String?) onFilterChanged;

  const FilterBar({
    Key? key,
    required this.organizations,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TColor.primaryColor1.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Filter by: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(null, 'All Users'),
                  _buildFilterChip('unassigned', 'Unassigned'),
                  _buildFilterChip('managers', 'Managers'),
                  ...organizations.map((org) => _buildFilterChip(org.id, org.name)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String? value, String label) {
    final isSelected = selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          onFilterChanged(selected ? value : null);
        },
        backgroundColor: Colors.white,
        selectedColor: TColor.primaryColor1.withOpacity(0.2),
        checkmarkColor: TColor.primaryColor1,
        labelStyle: TextStyle(
          color: isSelected ? TColor.primaryColor1 : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
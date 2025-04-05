import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../theme/color_extension.dart';

class UserStats extends StatelessWidget {
  final List<User> users;

  const UserStats({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalUsers = users.length;
    final assignedUsers = users.where((u) => u.organizationId != null).length;
    final managerUsers = users.where((u) => u.role == 'manager').length;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            context,
            'Total Users',
            totalUsers.toString(),
            Icons.people,
            Colors.deepOrange,
          ),
          _buildStatCard(
            context,
            'Assigned',
            assignedUsers.toString(),
            Icons.business,
            Colors.green,
          ),
          _buildStatCard(
            context,
            'Managers',
            managerUsers.toString(),
            Icons.admin_panel_settings,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String count, IconData icon, Color color) {
    return Card(
      color: TColor.lightGray,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: MediaQuery.of(context).size.width / 3.5,
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
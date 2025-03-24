import 'package:flutter/material.dart';

import '../../../models/organization.dart';
import '../../../models/user.dart';
import '../widgets/filter_bar.dart';
import '../widgets/stats_widgets.dart';
import '../widgets/user_card.dart';

class UsersTab extends StatelessWidget {
  final List<User> users;
  final List<Organization> organizations;
  final List<User> filteredUsers;
  final String? selectedFilter;
  final Function(String?) onFilterChanged;
  final Function(User, String?) onAssignOrganization;
  final Function(User) onToggleRole;

  const UsersTab({
    Key? key,
    required this.users,
    required this.organizations,
    required this.filteredUsers,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onAssignOrganization,
    required this.onToggleRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterBar(
          organizations: organizations,
          selectedFilter: selectedFilter,
          onFilterChanged: onFilterChanged,
        ),
        UserStats(users: users),
        Expanded(
          child: _buildUsersList(),
        ),
      ],
    );
  }

  Widget _buildUsersList() {
    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return UserCard(
          user: user,
          organizations: organizations,
          onAssignOrganization: onAssignOrganization,
          onToggleRole: onToggleRole,
        );
      },
    );
  }
}
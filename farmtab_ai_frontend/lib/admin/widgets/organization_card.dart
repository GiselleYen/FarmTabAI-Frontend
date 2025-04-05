import 'package:flutter/material.dart';

import '../../../models/organization.dart';
import '../../../models/user.dart';
import '../../../theme/color_extension.dart';
import '../dialog_utils.dart';

class OrganizationCard extends StatelessWidget {
  final Organization organization;
  final List<User> orgUsers;
  final Function(String) onUpdateOrganization;
  final VoidCallback onDelete;

  const OrganizationCard({
    Key? key,
    required this.organization,
    required this.orgUsers,
    required this.onUpdateOrganization,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final managerCount = orgUsers.where((u) => u.role == 'manager').length;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TColor.primaryColor1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.business,
                    color: TColor.primaryColor1,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organization.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${organization.id}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Confirm Delete'),
                        content: Text('Are you sure you want to delete "${organization.name}"? This cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text('Cancel',
                            style: TextStyle(
                              color: TColor.primaryColor1,
                            ),),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColor.primaryColor1,
                            ),
                            child: const Text('Delete',
                            style: TextStyle(
                              color: Colors.white
                            ),),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      onDelete(); // Trigger the delete callback
                    }
                  },
                  color: Colors.red[400],
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    DialogUtils.showEditOrganizationDialog(
                      context,
                      organization.name,
                      onUpdateOrganization,
                    );
                  },
                  color: Colors.grey[700],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildOrgStat('Total Users', orgUsers.length.toString(), Icons.people),
                  const SizedBox(width: 16),
                  _buildOrgStat('Managers', managerCount.toString(), Icons.admin_panel_settings),
                ],
              ),
            ),
            if (orgUsers.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Members',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: orgUsers.map((user) => Chip(
                  label: Text(user.name),
                  avatar: CircleAvatar(
                    backgroundColor: user.role == 'manager' ? TColor.primaryColor1 : Colors.grey[300],
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: user.role == 'manager' ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.grey[100],
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrgStat(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text('$label: '),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
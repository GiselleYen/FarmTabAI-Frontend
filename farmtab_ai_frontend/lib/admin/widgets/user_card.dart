import 'package:flutter/material.dart';

import '../../../models/organization.dart';
import '../../../models/user.dart';
import '../../../theme/color_extension.dart';
import '../dialog_utils.dart';

class UserCard extends StatelessWidget {
  final User user;
  final List<Organization> organizations;
  final Function(User, String?) onAssignOrganization;
  final Function(User) onToggleRole;

  const UserCard({
    Key? key,
    required this.user,
    required this.organizations,
    required this.onAssignOrganization,
    required this.onToggleRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String orgName = "No Organization";
    if (user.organizationId != null) {
      orgName = organizations
          .firstWhere((org) => org.id == user.organizationId,
          orElse: () => Organization(id: "unknown", name: "Unknown"))
          .name;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: TColor.primaryColor1.withOpacity(0.2),
              radius: 28,
              child: Text(
                user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TColor.primaryColor1,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (user.role == 'manager')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: TColor.primaryColor1,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Manager',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: user.organizationId != null ? TColor.primaryColor1 : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        orgName,
                        style: TextStyle(
                          fontSize: 14,
                          color: user.organizationId != null ? TColor.primaryColor1 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.business, size: 16),
                          label: const Text('Organization'),
                          onPressed: () {
                            DialogUtils.showOrganizationDialog(
                              context,
                              user,
                              organizations,
                              onAssignOrganization,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black87,
                            textStyle: const TextStyle(fontSize: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(
                            user.role == 'user'
                                ? Icons.admin_panel_settings_outlined
                                : Icons.person_outlined,
                            size: 16,
                          ),
                          label: Text(user.role == 'user' ? 'Make Manager' : 'Make User'),
                          onPressed: () {
                            onToggleRole(user);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primaryColor1.withOpacity(0.1),
                            foregroundColor: TColor.primaryColor1,
                            textStyle: const TextStyle(fontSize: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
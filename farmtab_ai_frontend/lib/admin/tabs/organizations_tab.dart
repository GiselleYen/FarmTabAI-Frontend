import 'package:flutter/material.dart';

import '../../../models/organization.dart';
import '../../../models/user.dart';
import '../widgets/organization_card.dart';

class OrganizationsTab extends StatelessWidget {
  final List<Organization> organizations;
  final List<User> users;
  final Function(int, String) onUpdateOrganization;

  const OrganizationsTab({
    Key? key,
    required this.organizations,
    required this.users,
    required this.onUpdateOrganization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: organizations.length,
      itemBuilder: (context, index) {
        final organization = organizations[index];
        final orgUsers = users.where((u) => u.organizationId == organization.id).toList();

        return OrganizationCard(
          organization: organization,
          orgUsers: orgUsers,
          onUpdateOrganization: (name) => onUpdateOrganization(index, name),
        );
      },
    );
  }
}
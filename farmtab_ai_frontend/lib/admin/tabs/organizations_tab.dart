import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../models/organization.dart';
import '../../../models/user.dart';
import '../../services/organization_service.dart';
import '../../theme/color_extension.dart';
import '../widgets/organization_card.dart';

class OrganizationsTab extends StatelessWidget {
  final List<Organization> organizations;
  final List<User> users;
  final Function(int, String) onUpdateOrganization;
  final VoidCallback onAddOrganization;

  const OrganizationsTab({
    Key? key,
    required this.organizations,
    required this.users,
    required this.onUpdateOrganization,
    required this.onAddOrganization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                organizations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final organization = entry.value;
                  final orgUsers = users.where((u) => u.organizationId == organization.id).toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: OrganizationCard(
                      organization: organization,
                      orgUsers: orgUsers,
                      onUpdateOrganization: (name) => onUpdateOrganization(index, name),
                      onDelete: () => _handleDeleteOrganization(context, organization.id, index), // 👈
                    ).animate().fadeIn(duration: 300.ms).slideX(
                      begin: 0.1,
                      duration: 300.ms,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingAddButton(context),
    );
  }

  Widget _buildFloatingAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: onAddOrganization,
      backgroundColor: TColor.primaryColor1,
      elevation: 10,
      child: Icon(
        Icons.add,
        color: TColor.white,
        size: 30,
      ),
    ).animate().fadeIn(duration: 400.ms).scaleXY(
      begin: 0.7,
      duration: 400.ms,
    );
  }

  void _handleDeleteOrganization(BuildContext context, String orgId, int index) async {
    try {
      final orgName = organizations[index].name;
      await OrganizationService().deleteOrganization(orgId);
      organizations.removeAt(index);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted organization: $orgName'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting organization: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
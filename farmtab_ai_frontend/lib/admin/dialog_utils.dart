import 'package:flutter/material.dart';

import '../models/organization.dart';
import '../models/user.dart';
import '../theme/color_extension.dart';

class DialogUtils {
  static void showOrganizationDialog(BuildContext context,
      User user,
      List<Organization> organizations,
      Function(User, String?) onAssignOrganization,) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Assign ${user.name} to Organization'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...organizations.map((org) =>
                      ListTile(
                        title: Text(org.name),
                        leading: Radio<String>(
                          value: org.id,
                          groupValue: user.organizationId,
                          onChanged: (value) {
                            Navigator.of(context).pop();
                            if (value != null) {
                              onAssignOrganization(user, value);
                            }
                          },
                          activeColor: TColor.primaryColor1,
                        ),
                      )),
                  ListTile(
                    title: const Text('No Organization'),
                    leading: Radio<String?>(
                      value: null,
                      groupValue: user.organizationId,
                      onChanged: (value) {
                        Navigator.of(context).pop();
                        onAssignOrganization(user, value);
                      },
                      activeColor: TColor.primaryColor1,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: TColor.primaryColor1),
                ),
              ),
            ],
          ),
    );
  }

  static void showEditOrganizationDialog(
      BuildContext context,
      String currentName,
      Function(String) onUpdateOrganization,
      ) {
    final TextEditingController nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Organization'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Organization Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: TColor.primaryColor1),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                onUpdateOrganization(nameController.text.trim());
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primaryColor1,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
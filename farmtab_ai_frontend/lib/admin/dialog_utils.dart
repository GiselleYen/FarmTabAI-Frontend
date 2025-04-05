import 'package:flutter/material.dart';

import '../models/organization.dart';
import '../models/user.dart';
import '../theme/color_extension.dart';

class DialogUtils {
  static void showOrganizationDialog(
      BuildContext context,
      User user,
      List<Organization> organizations,
      Function(User, String?) onAssignOrganization,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: TColor.primaryColor1.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: TColor.primaryColor1.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.corporate_fare,
                      color: TColor.primaryColor1,
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Assign Organization',
                        style: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'For ${user.name}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              // Organizations List
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: organizations.length + 1,
                  itemBuilder: (context, index) {
                    if (index < organizations.length) {
                      final org = organizations[index];
                      final isSelected = user.organizationId == org.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? TColor.primaryColor1.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                            title: Text(
                              org.name,
                              style: TextStyle(
                                color: isSelected
                                    ? TColor.primaryColor1
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
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
                          ),
                        ),
                      );
                    }
                    final isNoOrgSelected = user.organizationId == null;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isNoOrgSelected
                              ? TColor.primaryColor1.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          title: Text(
                            'No Organization',
                            style: TextStyle(
                              color: isNoOrgSelected
                                  ? TColor.primaryColor1
                                  : Colors.black87,
                              fontWeight: isNoOrgSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
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
                      ),
                    );
                  },
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: TColor.primaryColor1,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
        backgroundColor: Colors.white,
        title: Text('Edit Organization',
          style: TextStyle(
            fontSize: 23,
            color: TColor.primaryColor1,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          cursorColor: TColor.primaryColor1,
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Organization Name',
            labelStyle: TextStyle(color: TColor.primaryColor1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: TColor.primaryColor1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: TColor.primaryColor1,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.business,
              color: TColor.primaryColor1,
            ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Update',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
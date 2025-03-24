import 'package:farmtab_ai_frontend/profile/edit_profile.dart';
import 'package:farmtab_ai_frontend/widget/custome_input_decoration.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import '../../theme/color_extension.dart';

class EditNamePage extends StatefulWidget {
  final String currentName;

  const EditNamePage({Key? key, required this.currentName}) : super(key: key);

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userProfile;

  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() async {
    try {
      String newName = _nameController.text.trim();

      if (newName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Name cannot be empty")),
        );
        return;
      }

      final response = await _userService.updateUserName(newName);

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Name updated successfully")),
        );

        FocusScope.of(context).unfocus();
        Future.delayed(Duration(milliseconds: 250), () {
          Navigator.pop(context);
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update name")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Name',
          style: TextStyle(
              color: TColor.primaryColor1,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.primaryColor1,),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Future.delayed(Duration(milliseconds: 250), () {
              Navigator.pop(context);
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: TColor.primaryColor2,
                  selectionHandleColor:TColor.primaryColor1,
                ),
              ),
              child: TextField(
                controller: _nameController,
                cursorColor: TColor.primaryColor1,
                decoration: CustomInputDecoration.build(
                  label: "Name",
                ),
                autofocus: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _saveName,
              child: const Text('Save',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
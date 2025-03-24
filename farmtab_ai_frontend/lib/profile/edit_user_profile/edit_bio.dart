import 'package:farmtab_ai_frontend/widget/custome_input_decoration.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import '../../theme/color_extension.dart';

class EditBioPage extends StatefulWidget {
  final String currentBio;

  const EditBioPage({Key? key, required this.currentBio}) : super(key: key);

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userProfile;

  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.currentBio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _saveBio() async {
    try {
      String newBio = _bioController.text.trim();

      if (newBio.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bio cannot be empty")),
        );
        return;
      }

      final response = await _userService.updateUserBio(newBio);

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bio updated successfully")),
        );

        FocusScope.of(context).unfocus();
        Future.delayed(Duration(milliseconds: 250), () {
          Navigator.pop(context);
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update bio")),
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
        title: Text('Edit Your Bio',
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
                controller: _bioController,
                cursorColor: TColor.primaryColor1,
                decoration: CustomInputDecoration.build(
                  label: "Bio",
                ),
                autofocus: true,
                minLines: 3, // Minimum height of 3 lines
                maxLines: 5, // Maximum height of 5 lines (or adjust as needed)
                keyboardType: TextInputType.multiline, // Allows multi-line input
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _saveBio,
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
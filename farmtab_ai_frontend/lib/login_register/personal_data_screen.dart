import 'package:flutter/material.dart';

import '../theme/color_extension.dart';

class PersonalDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0, // Prevents background from darkening when scrolling
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(25.0, 6.0, 25.0, 50.0),
          child: DefaultTextStyle( // Apply font to all Text widgets inside
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Personal Data Policy",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryColor1,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Last Updated: February 2025\n",
                  style: TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic,),
                ),
                SizedBox(height: 10),
                Text(
                  "We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and store your personal information.",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 20),

                Text(
                  "1. Information We Collect",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  "- Name, email address, and contact information.\n"
                      "- Login credentials and account preferences.\n"
                      "- Device information, IP address, and browsing data.\n"
                      "- Any other data you provide while using our services.",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),

                SizedBox(height: 20),
                Text(
                  "2. How We Use Your Data",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  "- To provide and manage your account.\n"
                      "- To improve our services and user experience.\n"
                      "- To comply with legal obligations.\n"
                      "- To send important updates and promotional content (with your consent).",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),

                SizedBox(height: 20),
                Text(
                  "3. Data Sharing & Protection",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  "- We do not sell or rent your personal data to third parties.\n"
                      "- Your data is securely stored with encryption measures.\n"
                      "- We may share data with legal authorities when required by law.",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),

                SizedBox(height: 20),
                Text(
                  "4. Your Rights",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  "- You have the right to access and update your personal data.\n"
                      "- You can request the deletion of your account and data.\n"
                      "- You may opt out of marketing communications at any time.",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),

                SizedBox(height: 20),
                Text(
                  "5. Contact Us",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  "If you have any questions about this policy, please contact us at: support@example.com",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),

                // SizedBox(height: 30),
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     child: Text(
                //       "Back",
                //       style: TextStyle(color: Colors.white), // Change text color
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: TColor.primaryColor1,
                //       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                //       minimumSize: const Size(double.infinity, 50),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

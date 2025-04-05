import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttachImage;

  const ChatInputArea({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onAttachImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Increased vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IconButton(
            //   constraints: BoxConstraints.tight(Size(50, 50)),
            //   padding: EdgeInsets.zero,
            //   onPressed: onAttachImage,
            //   icon: Container(
            //     padding: EdgeInsets.all(6),
            //     decoration: BoxDecoration(
            //       color: TColor.primaryColor1.withOpacity(0.1),
            //       shape: BoxShape.circle,
            //     ),
            //     child: Icon(Icons.add, color: TColor.primaryColor1, size: 20),
            //   ),
            //   tooltip: 'Add Image',
            // ),
            Expanded(
              child: TextField(
                controller: controller,
                cursorColor: TColor.primaryColor1,
                decoration: InputDecoration(
                  hintText: "Ask Me anything...",
                  hintStyle: TextStyle(
                    fontFamily: "Inter",
                    color: Colors.grey.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: TColor.lightGray.withOpacity(0.4),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Increased vertical padding
                  isDense: false, // Changed to false to allow for more height
                ),
                onSubmitted: (_) => onSend(),
                keyboardType: TextInputType.text,
                maxLines: 2,
                textInputAction: TextInputAction.send,
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 46, // Slightly increased button size
                height: 46, // Slightly increased button size
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [TColor.primaryColor1, TColor.primaryColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class ImageAttachmentPreview extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;

  const ImageAttachmentPreview({
    Key? key,
    required this.image,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.black.withOpacity(0.05),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              image,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Text(
            "Image attached",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
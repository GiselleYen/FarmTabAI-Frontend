import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:farmtab_ai_frontend/models/message.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final int index;
  final Function(int, bool) onFeedback;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.index,
    required this.onFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              radius: 16,
              backgroundColor: TColor.primaryColor1,
              child: Icon(Icons.smart_toy, size: 20, color: Colors.white),
            ),
          SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? TColor.primaryColor1.withOpacity(0.9) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the image if available
                      if (message.image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            message.image!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (message.image != null && message.text.isNotEmpty)
                        SizedBox(height: 8),
                      if (message.text.isNotEmpty)
                        SelectableText(
                          message.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontFamily: "Inter",
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isUser && message.feedback == null)
                  _buildFeedbackButtons(),
                if (!isUser && message.feedback != null)
                  _buildFeedbackStatus(),
              ],
            ),
          ),
          if (isUser) SizedBox(width: 12),
        ],
      ).animate().slideX(
        begin: isUser ? 0.3 : -0.3,
        end: 0,
        duration: 300.ms,
        delay: (index * 100).ms,
      ),
    );
  }

  Widget _buildFeedbackButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onFeedback(index, true),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: TColor.primaryColor1.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.thumb_up, size: 16, color: TColor.primaryColor1),
                  SizedBox(width: 4),
                  Text(
                    "Like",
                    style: TextStyle(fontFamily: "Inter", fontSize: 12, color: TColor.primaryColor1),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => onFeedback(index, false),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.thumb_down, size: 16, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    "Dislike",
                    style: TextStyle(fontFamily: "Inter", fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackStatus() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        message.feedback! ? "You liked this" : "You didn't like this",
        style: TextStyle(
          fontFamily: "Inter",
          fontSize: 12,
          color: message.feedback! ? TColor.primaryColor1 : Colors.red,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/models/message.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'message_bubble.dart';

class ChatList extends StatelessWidget {
  final List<Message> messages;
  final bool isTyping;
  final ScrollController scrollController;
  final Function(int, bool) onFeedback;

  const ChatList({
    Key? key,
    required this.messages,
    required this.isTyping,
    required this.scrollController,
    required this.onFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: ListView.builder(
        controller: scrollController,
        itemCount: messages.length + (isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == messages.length) {
            return _buildTypingIndicator();
          }
          return MessageBubble(
            message: messages[index],
            index: index,
            onFeedback: onFeedback,
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return isTyping
        ? Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: TColor.primaryColor1,
            child: Icon(Icons.smart_toy, size: 20, color: Colors.white),
          ),
          SizedBox(width: 12),
          Text(
            "Typing...",
            style: TextStyle(
              fontFamily: "Inter",
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    )
        : SizedBox.shrink();
  }
}
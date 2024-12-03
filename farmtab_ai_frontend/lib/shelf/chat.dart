import 'package:flutter/material.dart';

import '../theme/color_extension.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [
    Message(
      text: "Hello! How can I help you today?",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    Message(
      text: "I have a question about my sensor readings.",
      isUser: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    Message(
      text: "Of course! I'd be happy to help. What specific readings are you concerned about?",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 3)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(
        text: _messageController.text,
        isUser: true,
        timestamp: DateTime.now(),
      ));

      // Add a mock response
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add(Message(
              text: "Thank you for your message. I'll look into that for you.",
              isUser: false,
              timestamp: DateTime.now(),
            ));
            _scrollToBottom();
          });
        }
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.backgroundColor1,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: message.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!message.isUser)
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundImage:
                            AssetImage("assets/images/shelfA.jpg"),
                            radius: 65.0,
                          ),
                        ),
                      SizedBox(width: !message.isUser ? 8 : 0),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? TColor.primaryColor1
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                blurRadius: 8, // Blur radius for soft edges
                                spreadRadius: 1, // Spread radius to increase/decrease shadow size
                                offset: Offset(2, 4), // Horizontal and vertical offset of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: message.isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: message.isUser
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatTimestamp(message.timestamp),
                                style: TextStyle(
                                  color: message.isUser
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: message.isUser ? 8 : 0),
                      if (message.isUser)
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/images/profile_photo.jpg"),
                            radius: 65.0,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(
                        color: TColor.primaryColor1.withOpacity(0.6),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: TColor.primaryColor1,
                          width: 2, // Border width
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: TColor.primaryColor1, // Border color when not focused
                          width: 1, // Border width
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    cursorColor: TColor.primaryColor1,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: TColor.primaryColor1,
                    size: 22.0,
                  ),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
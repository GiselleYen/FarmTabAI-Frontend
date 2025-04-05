import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

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
  ];

  bool _isLoading = false; // To show loading indicator

  String? sessionId;

  @override
  void initState() {
    super.initState();
    // _loadOrCreateSessionId();
    _generateNewSessionId();
  }

  void _generateNewSessionId() {
    final newSessionId = const Uuid().v4();
    setState(() {
      sessionId = newSessionId;
    });
  }

  Future<void> _loadOrCreateSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedSessionId = prefs.getString('chat_session_id');

    if (storedSessionId != null) {
      setState(() {
        sessionId = storedSessionId;
      });
    } else {
      final newSessionId = const Uuid().v4();
      await prefs.setString('chat_session_id', newSessionId);
      setState(() {
        sessionId = newSessionId;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Function to send user input to LLM via backend API
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String userInput = _messageController.text;

    setState(() {
      _messages.add(Message(
        text: userInput,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      const Duration apiTimeout = Duration(seconds: 180);

      final response = await http.post(
        Uri.parse("http://124.243.133.42:3000/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "prompt": userInput,
          "sessionId": sessionId,
          "serialNumber": "UTC-510GP-ATB1E",
        }),
      ).timeout(apiTimeout, onTimeout: () {
        throw TimeoutException('The request took too long to complete.');
      });

      if (response.statusCode == 200) {
        String aiResponse = jsonDecode(response.body)["response"];

        setState(() {
          _messages.add(Message(
            text: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      } else {
        setState(() {
          _messages.add(Message(
            text: "Error: Unable to get a response. Please try again.",
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: "Error: Network issue. Please check your connection.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
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
        scrolledUnderElevation: 0,
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0), // Add loader if active
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Avatar for the assistant while typing
                        // Container(
                        //   height: 40,
                        //   width: 40,
                        //   child: CircleAvatar(
                        //     backgroundImage: AssetImage("assets/images/shelfA.jpg"),
                        //     radius: 65.0,
                        //   ),
                        // ),
                        SizedBox(width: 8),
                        // Animated typing indicator
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: TypingIndicator(),
                        ),
                      ],
                    ),
                  );
                }

                final message = _messages[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: message.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      // if (!message.isUser)
                      //   Container(
                      //     height: 40,
                      //     width: 40,
                      //     child: CircleAvatar(
                      //       backgroundImage:
                      //       AssetImage("assets/images/shelfA.jpg"),
                      //       radius: 65.0,
                      //     ),
                      //   ),
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
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: message.isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                message.text,
                                style: TextStyle(
                                  color: message.isUser ? Colors.white : Colors.black87,
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
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: TColor.primaryColor1,
                          width: 1,
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

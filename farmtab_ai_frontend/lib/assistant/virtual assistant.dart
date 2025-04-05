import 'dart:io';
import 'package:farmtab_ai_frontend/assistant/components/input_area.dart';
import 'package:farmtab_ai_frontend/assistant/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:farmtab_ai_frontend/models/message.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:image_picker/image_picker.dart';

import 'components/assistant_app_bar.dart';
import 'components/chat_list.dart';
import 'components/image_attachment_preview.dart';

class VirtualAssistantPage extends StatefulWidget {
  const VirtualAssistantPage({Key? key}) : super(key: key);

  @override
  State<VirtualAssistantPage> createState() => _VirtualAssistantPageState();
}

class _VirtualAssistantPageState extends State<VirtualAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final ChatService _chatService = ChatService();

  List<Message> _messages = [];
  bool isTyping = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _messages.add(Message(
      text: "Hi! I'm your FarmTab AI Assistant. How can I help you with your farm today?",
      isUser: false,
      feedback: null,
    ));

    // Add a post-frame callback to scroll to bottom initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add Image",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.primaryColor1,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: TColor.primaryColor1.withOpacity(0.1),
                child: Icon(Icons.camera_alt, color: TColor.primaryColor1),
              ),
              title: Text("Take Photo", style: TextStyle(fontFamily: "Inter")),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: TColor.primaryColor1.withOpacity(0.1),
                child: Icon(Icons.photo_library, color: TColor.primaryColor1),
              ),
              title: Text("Upload from Gallery", style: TextStyle(fontFamily: "Inter")),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      Fluttertoast.showToast(
        msg: "Image selected. Add a message and send!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: TColor.secondaryColor1,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> _sendMessage() async {
    final userInput = _messageController.text.trim();

    if (userInput.isEmpty && _selectedImage == null) return;

    // Add user message to chat
    setState(() {
      _messages.add(Message(
        text: userInput,
        isUser: true,
        image: _selectedImage,
      ));
      isTyping = true;
    });
    _messageController.clear();

    // Save the current selected image and clear it from the state
    final currentImage = _selectedImage;
    setState(() {
      _selectedImage = null;
    });

    // Scroll to bottom after adding message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      String aiResponse;

      if (currentImage != null) {
        aiResponse = await _chatService.sendImageMessage(userInput, currentImage);
      } else {
        aiResponse = await _chatService.sendTextMessage(userInput);
      }

      setState(() {
        _messages.add(Message(text: aiResponse, isUser: false, feedback: null));
        isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: "Sorry, I couldn't process that. Error: $e. Please try again!",
          isUser: false,
          feedback: null,
        ));
        isTyping = false;
      });
    }

    // Scroll to bottom after response
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _submitFeedback(int index, bool isLiked) {
    setState(() {
      _messages[index] = _messages[index].copyWith(feedback: isLiked);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLiked ? "Thanks for your feedback!" : "Noted, I'll try to do better!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.backgroundColor1,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          AssistantAppBar(),
          Expanded(
            child: ChatList(
              messages: _messages,
              isTyping: isTyping,
              scrollController: _scrollController,
              onFeedback: _submitFeedback,
            ),
          ),
          if (_selectedImage != null)
            ImageAttachmentPreview(
              image: _selectedImage!,
              onRemove: () => setState(() => _selectedImage = null),
            ),
          ChatInputArea(
            controller: _messageController,
            onSend: _sendMessage,
            onAttachImage: _showImageOptions,
          ),
        ],
      ),
    );
  }
}
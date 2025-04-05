import 'dart:io';

class Message {
  final String text;
  final bool isUser;
  final bool? feedback;
  final File? image;

  Message({
    required this.text,
    required this.isUser,
    this.feedback,
    this.image,
  });

  Message copyWith({String? text, bool? isUser, bool? feedback, File? image}) {
    return Message(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      feedback: feedback ?? this.feedback,
      image: image ?? this.image,
    );
  }
}
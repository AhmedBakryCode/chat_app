import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderEmail;
  final String senderID;
  final String receverID;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderEmail,
      required this.senderID,
      required this.receverID,
      required this.message,
      required this.timestamp, String? imageUrl, String? fileUrl});

  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'senderID': senderID,
      'receverID': receverID,
      'message': message,
      'timestamp': timestamp
    };
  }
}

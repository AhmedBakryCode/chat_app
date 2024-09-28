import 'dart:io'; // Import the File class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vqa_graduation_project/models/messages.dart';
import 'package:vqa_graduation_project/services/auth_services.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message, {String? imageUrl, String? fileUrl}) async {
    final String currentID = _authService.getCurrentUser()!.uid;
    final String currentemail = _authService.getCurrentUser()!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderEmail: currentemail,
      senderID: currentID,
      message: message,
      timestamp: timestamp,
      imageUrl: imageUrl,
      fileUrl: fileUrl, 
      receverID: receiverID,
    );

    List<String> ids = [currentID, receiverID];
    ids.sort();
    String chatID = ids.join('-');

    await _firestore
        .collection('chats_rooms')
        .doc(chatID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String currentID, String receiverID) {
    List<String> ids = [currentID, receiverID];
    ids.sort();
    String chatID = ids.join('-');
    return _firestore
        .collection('chats_rooms')
        .doc(chatID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> blockUser(String userID) async {
    String currentID = _authService.getCurrentUser()!.uid;
    await _firestore
        .collection('blocked_users')
        .doc(currentID)
        .set({'blocked': FieldValue.arrayUnion([userID])}, SetOptions(merge: true));
  }

  Future<void> unblockUser(String userID) async {
    String currentID = _authService.getCurrentUser()!.uid;
    await _firestore
        .collection('blocked_users')
        .doc(currentID)
        .set({'blocked': FieldValue.arrayRemove([userID])}, SetOptions(merge: true));
  }

  Future<void> reportUser(String userID, String reason) async {
    await _firestore.collection('reports').add({
      'reportedBy': _authService.getCurrentUser()!.uid,
      'reportedUser': userID,
      'reason': reason,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteUser(String userID) async {
    await _firestore.collection('users').doc(userID).delete();
  }

  Stream<List<String>> getBlockedUsers() {
    String currentID = _authService.getCurrentUser()!.uid;
    return _firestore.collection('blocked_users').doc(currentID).snapshots().map((doc) {
      if (doc.exists) {
        return List<String>.from(doc.data()!['blocked']);
      }
      return [];
    });
  }

  Future<String> uploadFile(File file, String path) async {
    Reference ref = _storage.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<String?> uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String path = 'images/$fileName';
    return await uploadFile(image, path);
  }

  Future<String?> uploadDocument(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String path = 'files/$fileName';
    return await uploadFile(file, path);
  }

  // Method to delete a message
  Future<void> deleteMessage(String messageId, String receiverID) async {
    final String currentID = _authService.getCurrentUser()!.uid;
    List<String> ids = [currentID, receiverID];
    ids.sort();
    String chatID = ids.join('-');

    await _firestore
        .collection('chats_rooms')
        .doc(chatID)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  // Method to update a message
  Future<void> updateMessage(String messageId, String newMessage, String receiverID) async {
    final String currentID = _authService.getCurrentUser()!.uid;
    List<String> ids = [currentID, receiverID];
    ids.sort();
    String chatID = ids.join('-');

    await _firestore
        .collection('chats_rooms')
        .doc(chatID)
        .collection("messages")
        .doc(messageId)
        .update({'message': newMessage, 'timestamp': Timestamp.now()});
  }
}

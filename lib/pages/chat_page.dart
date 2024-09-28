import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:vqa_graduation_project/pages/chat_bubble.dart';
import 'package:vqa_graduation_project/services/auth_services.dart';
import 'package:vqa_graduation_project/services/chat_service.dart';
import 'package:vqa_graduation_project/themes/themes_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  final String receiveremail;
  final String currentemail;

  ChatPage({
    super.key,
    required this.receiveremail,
    required this.receiverID,
    required this.currentemail,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final List<Reaction> reactions = [
    Reaction(
      value: 1,
      icon: Icon(Icons.thumb_up, color: Colors.blue),
      previewIcon: Icon(Icons.thumb_up, color: Colors.blue, size: 30),
    ),
    Reaction(
      value: 2,
      icon: Icon(Icons.favorite, color: Colors.red),
      previewIcon: Icon(Icons.favorite, color: Colors.red, size: 30),
    ),
    Reaction(
      value: 3,
      icon: Icon(Icons.emoji_emotions, color: Colors.yellow),
      previewIcon: Icon(Icons.emoji_emotions, color: Colors.yellow, size: 30),
    ),
  ];

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    sendImage(File(pickedFile.path));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    sendImage(File(pickedFile.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> sendMessage() async {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  Future<void> sendImage(File image) async {
    String? imageUrl = await _chatService.uploadImage(image);
    if (imageUrl != null) {
      await _chatService.sendMessage(widget.receiverID, '', imageUrl: imageUrl);
    }
  }

  Future<void> sendDocument(File file) async {
    String? fileUrl = await _chatService.uploadDocument(file);
    if (fileUrl != null) {
      await _chatService.sendMessage(widget.receiverID, '', fileUrl: fileUrl);
    }
  }

  void _handleMenuSelection(String value) async {
    switch (value) {
      case 'Block':
        await _chatService.blockUser(widget.receiverID);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User blocked successfully.')),
        );
        break;
      case 'Unblock':
        await _chatService.unblockUser(widget.receiverID);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User unblocked successfully.')),
        );
        break;
      case 'Report':
        _showReportDialog();
        break;
      case 'Delete':
        await _chatService.deleteUser(widget.receiverID);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User deleted successfully.')),
        );
        Navigator.of(context).pop(); // Go back after deleting the user
        break;
    }
  }

  void _showReportDialog() {
    TextEditingController _reportController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report User'),
          content: TextField(
            controller: _reportController,
            decoration: InputDecoration(hintText: "Enter reason for report"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String reason = _reportController.text;
                if (reason.isNotEmpty) {
                  await _chatService.reportUser(widget.receiverID, reason);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User reported successfully.')),
                  );
                }
              },
              child: Text('Report'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.receiveremail),
          actions: [
            PopupMenuButton<String>(
              onSelected: _handleMenuSelection,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'Block',
                    child: Text('Block User'),
                  ),
                  PopupMenuItem(
                    value: 'Unblock',
                    child: Text('Unblock User'),
                  ),
                  PopupMenuItem(
                    value: 'Report',
                    child: Text('Report User'),
                  ),
                  PopupMenuItem(
                    value: 'Delete',
                    child: Text('Delete User'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildUserInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String? currentID = _authService.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(currentID, widget.receiverID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var doc = documents[index];
            return _buildMessage(doc);
          },
        );
      },
    );
  }

  Widget _buildMessage(DocumentSnapshot doc) {
    Map<String, dynamic> message = doc.data() as Map<String, dynamic>;
    bool isMe = message['senderID'] == _authService.getCurrentUser()!.uid;
    return ChatBubble(
      isMe: isMe,
      message: message['message'],
      reactions: reactions,
      onReactionChanged: (reaction) {
        print("Reaction selected: ${reaction!.value}");
      },
      messageId: doc.id,
      onDelete: () => _chatService.deleteMessage(doc.id, widget.receiverID),
      onEdit: (newMessage) =>
          _chatService.updateMessage(doc.id, newMessage, widget.receiverID),
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () async {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                sendDocument(File(pickedFile.path));
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _showImageSourceDialog(context),
          ),
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(35)),
                labelText: 'Type your message',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 3, right: 2, left: 2),
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: Icon(Icons.arrow_upward),
            ),
          )
        ],
      ),
    );
  }
}

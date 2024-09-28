import 'package:flutter/material.dart';
import 'package:vqa_graduation_project/services/chat_service.dart';

class BlockedUsersPage extends StatelessWidget {
  final ChatService _chatService = ChatService();

  BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked Users'),
      ),
      body: StreamBuilder<List<String>>(
        stream: _chatService.getBlockedUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          List<String> blockedUsers = snapshot.data!;
          if (blockedUsers.isEmpty) {
            return Center(child: Text('No blocked users.'));
          }
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              String userID = blockedUsers[index];
              return ListTile(
                title: Text('User: $userID'), // Replace with actual user info
                trailing: IconButton(
                  icon: Icon(Icons.block),
                  onPressed: () {
                    _chatService.unblockUser(userID);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

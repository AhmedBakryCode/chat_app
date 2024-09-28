import 'package:flutter/material.dart';
import 'package:vqa_graduation_project/pages/chat_page.dart';
import 'package:vqa_graduation_project/services/auth_services.dart';
import 'package:vqa_graduation_project/services/chat_service.dart';
import 'package:vqa_graduation_project/widgets/default_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DefaultDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
          elevation: 0.0,
          title: Center(
              child: Text(
            "Users",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          )),
        ),
        body: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              // Check if the user's email is different from the current user's email
              if (users[index]['email'] != _authService.getCurrentUser()?.email) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(users[index]['email']),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          receiveremail: users[index]["email"],
                          receiverID: users[index]["uid"],
                          currentemail: users[index]["email"],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                // Return an empty container if the user should not be displayed
                return Container();
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

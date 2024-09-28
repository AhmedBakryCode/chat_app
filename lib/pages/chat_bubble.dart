import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:provider/provider.dart';
import 'package:vqa_graduation_project/themes/themes_provider.dart';

class ChatBubble extends StatefulWidget {
  final bool isMe;
  final String message;
  final String messageId;
  final List<Reaction> reactions;
  final Function(Reaction<dynamic>?) onReactionChanged;
  final Function() onDelete;
  final Function(String) onEdit;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.messageId,
    required this.reactions,
    required this.onReactionChanged,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _isPressed = false;

  void _togglePressed() {
    setState(() {
      _isPressed = !_isPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemesProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: _togglePressed,
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isMe
                  ? (isDarkMode
                      ? Colors.green.shade600
                      : Colors.green.shade500)
                  : (isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The main message text
                Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.isMe
                        ? Colors.white
                        : (isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                // The row for the edit and delete buttons
                if (_isPressed)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            TextEditingController _editController =
                                TextEditingController(text: widget.message);
                            String? editedMessage = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Edit Message'),
                                  content: TextField(
                                    controller: _editController,
                                    decoration: InputDecoration(
                                        hintText: "Enter message"),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            _editController.text);
                                      },
                                      child: Text('Save'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, null);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (editedMessage != null &&
                                editedMessage.isNotEmpty) {
                              widget.onEdit(editedMessage);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: widget.onDelete,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ReactionButton(
              onReactionChanged: widget.onReactionChanged,
              reactions: widget.reactions,
              placeholder: Reaction(
                icon: Icon(Icons.favorite_border, color: Colors.grey),
                value: 0,
              ),
              boxRadius: 10,
              boxPadding: const EdgeInsets.all(8),
              itemsSpacing: 8,
              selectedReaction: Reaction(
                icon: Icon(Icons.favorite, color: Colors.red),
                value: 1,
              ),
              itemSize: Size(40, 60),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'friendlist.dart';
import 'user.dart';




class Message {
  final String senderName;
  final String text;
  final bool isSentByUser;

  Message(this.senderName, this.text, this.isSentByUser);
}

class ChatPage extends StatefulWidget {
  final FriendListItem friend; // 接收好友信息

  ChatPage({required this.friend});

  @override
  _ChatPageState createState() => _ChatPageState();
}
final List<Message> messages = [];

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.friendName),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
          Divider(height: 1),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), // 调整此值以获得所需的椭圆形
              border: Border.all(
                color: Colors.grey, // 边框颜色
                width: 0.7, // 边框宽度
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (text) {
                      setState(() {
                        _hasText = text.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '输入消息...',
                      border: InputBorder.none, // 去掉输入框的默认边框
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // 调整内边距
                    ),
                  ),
                ),
                if (_hasText)
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(Message message) {
    final isSentByUser = message.isSentByUser;

    return Row(
      //是好友显示在左边，用户显示在右边
      mainAxisAlignment: isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isSentByUser)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(widget.friend.avatarImagePath),
            ),
          ),

        Column(
          //显示昵称，在气泡上面
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!isSentByUser)
              Text(
                widget.friend.friendName,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: isSentByUser ? Colors.blue : Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSentByUser ? 10 : 0),
                  topRight: Radius.circular(isSentByUser ? 0 : 10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        if (isSentByUser)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(currentUser.avatarImageUrl), // 用户头像
            ),
          ),
      ],
    );
  }


  void _sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        messages.add(Message(widget.friend.friendName, message, true)); // 模拟用户发送消息
        messages.add(Message(widget.friend.friendName, message, false)); // 模拟用户发送消息
        _messageController.clear();
        _hasText = false;
      });
    }
  }
  // Function to clear messages
  void _clearMessages() {
    setState(() {
      messages.clear();
    });
  }
}


import 'package:arman_gpt/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatGptModel {
  String message;
  String sender;

  ChatGptModel({
    required this.message,
    required this.sender,
  });
}

class chat_screen extends StatefulWidget {
  const chat_screen({super.key});

  @override
  State<chat_screen> createState() => _chat_screenState();
}

class _chat_screenState extends State<chat_screen> {
  final Chat_GPT _chatGPT = Chat_GPT("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");
  final TextEditingController chatController = TextEditingController();

  List<ChatGptModel> chatlist = [];

  bool isloading = false;

  void send(String message) async {
    isloading = true;
    chatController.clear();
    setState(() {
      chatlist.add(ChatGptModel(message: message, sender: 'User'));
    });
    final response = await _chatGPT.sendMessage(message);
    setState(() {
      isloading = false;
      chatlist.add(ChatGptModel(
        message: response,
        sender: 'Bot',
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(12.0))),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(72, 0, 0, 0),
            child: const Text(
              'arman gpt',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  chatlist.clear();
                });
              },
              icon: const Icon(Icons.clear_all))),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: chatlist.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            CupertinoIcons.chat_bubble_2_fill,
                            size: 55.0,
                          ),
                          Text(
                            'Empty :)',
                            style: TextStyle(fontSize: 18.0),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: chatlist.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  borderRadius: BorderRadius.circular(12.0),
                                  onDoubleTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                          text: chatlist[index].message.trim()),
                                    ).then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('copied'),
                                      ));
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: chatlist[index].sender == 'User'
                                          ? const Color.fromARGB(
                                              255, 40, 40, 40)
                                          : const Color(0xFF6D67E4),
                                    ),
                                    child: ListTile(
                                        title: SelectableText(
                                            chatlist[index].message.trim()),
                                        leading: chatlist[index].sender ==
                                                'User'
                                            ? const Icon(Icons.person)
                                            : const Icon(Icons.bolt_rounded)),
                                  ),
                                );
                              },
                            ),
                          ),
                          isloading
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 16.0),
                                  child: CupertinoActivityIndicator(),
                                )
                              : const SizedBox(),
                        ],
                      )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onSubmitted: (value) {
                  send(chatController.text);
                },
                controller: chatController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                      onPressed: () {
                        send(chatController.text);
                      },
                      icon: const Icon(Icons.send)),
                  hintText: 'type your text here...',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

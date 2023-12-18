import 'package:chatgpt/page/chat/chat_page.dart';
import 'package:chatgpt/page/chat/message_model.dart';
import 'package:chatgpt/page/conversation/conversation_page.dart';
import 'package:chatgpt/page/home/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
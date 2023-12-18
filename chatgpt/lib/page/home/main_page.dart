import 'package:chatgpt/network/http/config.dart';
import 'package:chatgpt/page/conversation/conversation_page.dart';
import 'package:chatgpt/page/home/home_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();

    _initConfigBuilder();
  }


  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
  
  void _initConfigBuilder() {
    const apiKey = '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';
    const proxyKey = '127.0.0.1:7890';
    TKConfigBuilder.init(apiKey, proxyKey: proxyKey);
  }
}
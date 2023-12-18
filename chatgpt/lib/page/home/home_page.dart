import 'package:chatgpt/model/conversation_model.dart';
import 'package:chatgpt/page/conversation/conversation_page.dart';
import 'package:chatgpt/untils/navigator_util.dart';
import 'package:chatgpt/widget/custom_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            color: Colors.amberAccent,
            child: const Text(
              'Text组件正常高度是横线2 到 横线4的距离。如果使用了StrutStyle则要注意下顶部 和 底部 的 leading 间距。',
              style: TextStyle(fontSize: 20, height: 1),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            color: Colors.amberAccent,
            child: const Text(
              'Text组件正常高度是横线2 到 横线4的距离。如果使用了StrutStyle则要注意下顶部 和 底部 的 leading 间距。',
              style: TextStyle(
                fontSize: 20,
                height: 1.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                decorationStyle: TextDecorationStyle.dashed,
                decorationThickness: 2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            color: Colors.amberAccent,
            child: const Text(
              'Text组件正常高度是横线2 到 横线4的距离。如果使用了StrutStyle则要注意下顶部 和 底部 的 leading 间距。',
              style: TextStyle(fontSize: 20, height: 1.5),
              strutStyle: StrutStyle(
                fontSize: 20,
                leading: 0,
                // forceStrutHeight: true,
                leadingDistribution: TextLeadingDistribution.proportional,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(color: Colors.amberAccent, child: const TKText()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 44),
        onPressed: () {
          NavigatorUtil.push(
              context,
              ConVersationPage(
                conversationModel: ConversationModel(cid: 1, icon: 'icon'),
                conversationUpdate: (conversationModel) {},
              ));
        },
      ),
    );
  }
}


import 'package:chatgpt/page/home/main_page.dart';
import 'package:chatgpt/page/login/input_widget.dart';
import 'package:chatgpt/untils/local_storage.dart';
import 'package:chatgpt/untils/storage_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginEnable = false;
  String? userName;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [..._background, _buildContent()],
      ),
    );
  }

  get _background {
    return [
      Positioned.fill(
          child: Image.network(
        'https://o.devio.org/images/bg_cover/robot.webp',
        fit: BoxFit.cover,
      )),
      Positioned.fill(
        child: Container(decoration: const BoxDecoration(color: Colors.black54)),
      ),
    ];
  }

  Widget _buildContent() {
    return Positioned.fill(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            const Text(
              'ChatGPT',
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
            const SizedBox(height: 40),
            InputWidget(
              hint: '请输入账号',
              onChanged: (text) {
                userName = text;
                _checkInput();
              },
            ),
            const SizedBox(height: 40),
            InputWidget(
              hint: '请输入密码',
              obscureText: true,
              onChanged: (text) {
                password = text;
                _checkInput();
              },
            ),
            const SizedBox(height: 45),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              height: 45,
              onPressed: () {
                if (loginEnable) {
                  _login(context);
                }
              },
              disabledColor: Colors.white60,
              color: Colors.blueGrey,
              child: const Text(
                '登录',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: _jumpRegistration,
                child: const Text(
                  '注册账号',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _jumpRegistration() async {
    //跳转到接口后台注册账号
    Uri uri = Uri.parse('https://api.devio.org/uapi/swagger-ui.html#/Account/registrationUsingPOST');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }
  
  void _checkInput() async {
    bool enable;
    if ((userName?.isNotEmpty ?? false) && (password?.isNotEmpty ?? false)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
      debugPrint('loginEnable:$loginEnable');
    });
  }

  void _login(BuildContext context) async {
    if ((userName?.isNotEmpty ?? false) && (password?.isNotEmpty ?? false)) {
      LocalStorage.setBool(StorageConfig.isLogin, true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }
}



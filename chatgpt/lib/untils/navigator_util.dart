import 'package:chatgpt/page/login/login_page.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {
  ///用于在获取不到context的地方，如dao中跳转页面时使用，需要在HomePage赋值
  static BuildContext? _context;

  static updateContext(BuildContext context) {
    NavigatorUtil._context = context;
  }

  ///跳转到指定页面
  static Future<T?> push<T extends Object?>(BuildContext context, Widget page) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  ///跳转到登录页
  static goToLogin() {
    //跳转到登录页，并不让返回
    Navigator.pushReplacement(
        _context!, 
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}

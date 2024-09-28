
import 'package:flutter/material.dart';
import 'package:vqa_graduation_project/pages/chat_page.dart';
import 'package:vqa_graduation_project/pages/home_page.dart';
import 'package:vqa_graduation_project/pages/login_page.dart';
import 'package:vqa_graduation_project/pages/register_page.dart';
import 'package:vqa_graduation_project/pages/setting_page.dart';

abstract class AppRouter {
  static const String main = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String settings = '/settings';

 static Route<dynamic> generateRoute(RouteSettings settings ) {
    switch (settings.name) {
      case AppRouter.main:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRouter.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRouter.register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case AppRouter.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => SettingPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../router/AppRouter.dart';
import '../utils/acquireLocation.dart';
import '../style/popupMenu.dart';
import '../utils/method.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  int pageId;

// 判断页码 用于是否不响应跳转  1 首页 2 第二页
  BottomNavigationBarWidget(this.pageId, {Key? key}) : super(key: key);

//  这是通用底部导航栏  在所有界面使用
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
        color: Color(0x942390EA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomIconButton(
            icon: FontAwesomeIcons.home,
            onPressed: () {
              // 返回到主页（main.dart 中的页面），并移除之前的所有页面
              if (pageId == 0) return;
              AppRouter.router.navigateTo(context, '/home',
                  replace: true, transition: TransitionType.fadeIn);
              /*
              *
Fluro库提供了多种过渡动画选项，可以在TransitionType枚举中找到。以下是Fluro库中定义的一些常见过渡动画选项：
      transition: TransitionType.fadeIn
      TransitionType.fadeIn: 淡入动画
      TransitionType.native: 原生过渡动画（iOS为Cupertino，Android为Material）
      TransitionType.inFromLeft: 从左侧滑入
      TransitionType.inFromRight: 从右侧滑入
      TransitionType.inFromBottom: 从底部滑入
      TransitionType.inFromTop: 从顶部滑入
      TransitionType.scale: 缩放动画
      TransitionType.rightToLeftWithFade: 从右侧滑入并淡入
      TransitionType.leftToRightWithFade: 从左侧滑入并淡入
      TransitionType.upToDown: 从上往下滑入
      TransitionType.downToUp: 从下往上滑入
              *
              *
              * */
            },
          ),
          CustomIconButton(
            icon: FontAwesomeIcons.react,
            onPressed: () {
              if (pageId == 1) return;
              AppRouter.router.navigateTo(context, '/udpConnection',
                  transition: TransitionType.fadeIn);
            },
          ),
          CustomIconButton(
            icon: FontAwesomeIcons.cloudSun,
            onPressed: () async {
              if (pageId == 2) return;

              SharedPreferences prefs = await SharedPreferences.getInstance();
              String address = prefs.getString('address') ?? '';
              // 用于消除异步 BuildContext  警告
              if (!context.mounted) return;
              if (address.isEmpty) {
                // 如果 address 为空，显示弹窗
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('提示'),
                    content: const Text('获取位置失败，无法执行跳转操作。请检查权限'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
              } else {
                // 如果 address 不为空，执行跳转操作
                showWeatherOptions(context);
              }
            },
          ),
          CustomIconButton(
            icon: !kIsWeb && (Platform.isAndroid || Platform.isIOS) ? FontAwesomeIcons.mobileScreen: FontAwesomeIcons.computer,
            onPressed: () {
              if (pageId == 3) return;
              AppRouter.router.navigateTo(context, '/device',  transition: TransitionType.fadeIn);
            },
          ),
          CustomIconButton(
            icon: FontAwesomeIcons.user,
            onPressed: () {
              if (pageId == 4) return;
              Map<String, dynamic> data = {'key1': 'value1', 'key2': 'value2'};
              String jsonData = jsonEncode(data);
              AppRouter.router.navigateTo(context, '/blank',
                  transition: TransitionType.fadeIn);
            },
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(icon),
      onPressed: onPressed,
      color: Colors.white,
    );
  }
}

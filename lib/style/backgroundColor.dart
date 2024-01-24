import 'package:flutter/material.dart';

class SharedGradientContainer extends StatelessWidget {
  const SharedGradientContainer({Key? key, required this.childBuilder}) : super(key: key);

  final Widget Function(BuildContext) childBuilder;
// 背景色样式
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.purple],
        ),
      ),
      child: childBuilder(context),
    );
  }
}

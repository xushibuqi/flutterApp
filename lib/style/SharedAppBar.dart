import 'package:flutter/material.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  double appBarHeight = 10.0;
  final String title;

  SharedAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight * 0.08;

    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight), // 减少44像素高度
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 15), // 调整顶部距离为19px
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Align(
                  child: Text(title),
                ),
              ],
            ),

        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(10);
}

import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //定义列表widget的list
    List<Widget> list = <Widget>[];

    //Demo数据定义
    var data = [
      {"id": 1, "title": "测试数据AAA", "subtitle": "1"},
      {"id": 2, "title": "测试数据bbb", "subtitle": "2"},
      {"id": 3, "title": "测试数据ccc", "subtitle": "3"},
      {"id": 4, "title": "测试数据eee", "subtitle": "4"},
    ];

    //根据Demo数据，构造列表ListTile组件list
    for (var item in data) {
      list.add(ListTile(
        title: Text(item["title"].toString(), style: TextStyle(fontSize: 18.0)),
        subtitle: Text(item["subtitle"].toString()),
        leading: Icon(Icons.fastfood, color: Colors.orange),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          //点击的时候，进行路由跳转传参
          Navigator.pushNamed(context, "DetailPage", arguments: item);
        },
      ));
    }

    //返回整个页面
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Page"),
      ),
      body: Center(
          child: ListView(
        children: list,
      )),
    );
  }
}

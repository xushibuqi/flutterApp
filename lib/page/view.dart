import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../style/backgroundColor.dart';
import '../style/navigationBar.dart';
import 'cubit.dart';
import 'state.dart';

class BlCubitCounterPage extends StatelessWidget {
  const BlCubitCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BlCubitCounterCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<BlCubitCounterCubit>(context);

    return Scaffold(
      //  让背景延伸到顶部bar
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: Text('Bloc-Cubit范例'),
        backgroundColor: Colors.transparent, // 设置为透明
        elevation: 0, // 去除阴影
      ),
      body: SharedGradientContainer(
        childBuilder: (context) => Stack(
          children: [
            Center(
              child: BlocBuilder<BlCubitCounterCubit, BlCubitCounterState>(
                builder: (context, state) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          '点击了 ${cubit.state.count} 次',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // 底部导航栏
            Positioned(
              bottom: 1.5, // 调整底部间距
              left: 0,
              right: 0,
              child: BottomNavigationBarWidget(2),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0), // 调整底部间距
        child: FloatingActionButton(
          onPressed: () => cubit.increment(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

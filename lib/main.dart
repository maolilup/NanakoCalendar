import 'package:flutter/material.dart';

/// 应用程序入口点
void main() {
  runApp(const MyApp());
}

/// 主应用程序组件，作为应用的根部件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// 构建应用程序的主界面
  ///
  /// 返回一个 [MaterialApp] 实例，配置了应用标题、主题和主页
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // 这是应用程序的主题设置
        //
        // 尝试：运行应用程序后，尝试将下面的 seedColor 改为 Colors.green
        // 然后执行热重载（保存更改或在支持 Flutter 的 IDE 中点击“热重载”按钮，
        // 或在命令行中按 "r"）来查看效果
        //
        // 注意计数器不会重置为零；应用程序状态在重载过程中不会丢失。
        // 要重置状态，请使用热重启
        //
        // 这不仅适用于数值，也适用于代码：大多数代码更改都可以通过热重载测试
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// 主页组件，具有状态管理功能
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // 此部件是应用程序的主页。它是有状态的，意味着它包含一个 State 对象（如下定义），
  // 该对象包含影响其外观的字段。

  // 此类是状态的配置。它保存由父部件（在此为 App 部件）提供的值（在此为标题），
  // 并被 State 的 build 方法使用。Widget 子类中的字段始终标记为 "final"。

  /// 页面标题
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// 主页状态类，管理页面的状态数据
class _MyHomePageState extends State<MyHomePage> {
  /// 计数器变量，用于存储当前计数值
  int _counter = 0;

  /// 增加计数器的方法
  ///
  /// 调用 setState 通知 Flutter 框架状态已改变，需要重新构建界面
  /// 如果不调用 setState，即使改变了 _counter 的值，界面也不会更新
  void _incrementCounter() {
    setState(() {
      // 调用 setState 通知 Flutter 框架此状态中的某些内容已更改，
      // 从而导致下方的 build 方法重新运行，使显示能够反映更新后的值。
      // 如果我们在不调用 setState 的情况下更改 _counter，则 build 方法不会再次调用，
      // 因此看起来什么都没有发生。
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 每次调用 setState 时都会重新运行此方法，例如上面的 _incrementCounter 方法所做。
    //
    // Flutter 框架已经优化了 build 方法的重新运行速度，
    // 因此您可以直接重建任何需要更新的内容，而无需单独更改部件实例。
    return Scaffold(
      appBar: AppBar(
        // 尝试：尝试将此处的颜色更改为特定颜色（例如 Colors.amber），
        // 然后触发热重载以查看 AppBar 颜色变化而其他颜色保持不变的效果。
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // 这里我们获取由 App.build 方法创建的 MyHomePage 对象的值，
        // 并用它来设置我们的应用栏标题。
        title: Text(widget.title),
      ),
      body: Center(
        // Center 是一个布局部件。它接收单个子部件并将其放置在父部件的中间。
        child: Column(
          // Column 也是一个布局部件。它接收一组子部件并将它们垂直排列。
          // 默认情况下，它会调整自身大小以水平适应其子部件，并尽可能与父部件一样高。
          //
          // Column 有多种属性来控制其自身大小及子部件的位置。
          // 这里我们使用 mainAxisAlignment 来垂直居中子部件；
          // 这里的主轴是垂直轴，因为 Column 是垂直的（交叉轴将是水平的）。
          //
          // 尝试：调用“调试绘制”（在 IDE 中选择“切换调试绘制”操作，或在控制台按 "p"），
          // 以查看每个部件的线框。
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // 此尾随逗号使 build 方法的自动格式化更美观。
    );
  }
}

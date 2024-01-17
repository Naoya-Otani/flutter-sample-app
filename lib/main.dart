/*
  やったことメモ
  1. pubspec.yaml(npmでいうpackage.json)にproviderを追加 
  2. 必要なパッケージをインポート
  3. main関数を定義
      runApp関数でAppクラスを実行
  4. Appクラスを定義
      const App({Key? key}) : super(key: key); がよくわかっていない
  5. Appクラスのbuildメソッドを定義
      MultiProviderでChangeNotifierProviderをラップ
      ChangeNotifierProviderのcreateでToDoListModelを生成
      MaterialAppを返す
      MaterialAppのhomeにHomeScreenを指定
  6. HomeScreenクラスを定義
      StatefulWigetを継承
      HomeScreenのrouteNameを定義
  7. HomeScreenクラスのbuildメソッドを定義
      Provider.ofでToDoListModelを取得
      Scaffold = アプリの骨組み
      ScaffoldのappBarにAppBarを指定 (ヘッダー？)
      ScaffoldのbodyにColumnを指定
      ColumnのchildrenにTextFieldを指定 (Todoを入力するテキストボックス)
      ColumnのchildrenにElevatedButtonを指定 (チェックボックス)
      ColumnのchildrenにExpandedを指定 (Todoリスト)
  8. TodoListクラスを定義
      StatelessWidgetを継承 (なぜstatelessなのかよくわかっていない)
      Viewを返す
*/

/*
  Todo
  ・textEditingControllerと普通のStringで初期化の違い (document調べる)
    -> 普通のStringでは変更が検知されないから。
      controllerをTextFieldに渡すことで、TextFieldの変更を検知できるようになる。

      Flutter docs
      https://api.flutter.dev/flutter/widgets/TextEditingController-class.html

      <input>のvalueに値を渡すのと同じ?

  ・freezedを使って実装する
  
  ・branch切ってproviderなしでtodoリストを実装してみる
  -> StatefullWidgetで実装
*/

import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class ToDo {
  final String title;
  bool checked;

  ToDo({
    required this.title,
    this.checked = false,
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _todoController = TextEditingController();
  List<ToDo> _todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Sample without provider')),
      body: Column(
        children: [
          TextField(
            controller: _todoController,
            decoration: const InputDecoration(
              hintText: 'タスクを入力してください',
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addTodo();
            },
            child:
                Container(alignment: Alignment.center, child: const Text('追加')),
          ),
          Expanded(
            child: ListView(
              children: _todoList.map((todo) {
                return ListTile(
                  title: Text(
                    todo.title,
                    style: todo.checked
                        ? const TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough)
                        : const TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: todo.checked,
                        onChanged: (bool? value) {
                          _toggleTodoStatus(todo);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteTodo(todo);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    if (_todoController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('注意'),
            content: const Text('タスクを入力してください。'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('閉じる'),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      _todoList.add(ToDo(title: _todoController.text));
      _todoController.clear();
    });
  }

  void _deleteTodo(ToDo todo) {
    setState(() {
      _todoList.remove(todo);
    });
  }

  void _toggleTodoStatus(ToDo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }
}

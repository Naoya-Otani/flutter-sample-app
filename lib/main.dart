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
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'todo.dart';

void main() {
  runApp(const App());
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
      home: ChangeNotifierProvider(
        create: (_) => ToDoListModel(),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoListModel = Provider.of<ToDoListModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo Sample')),
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
              todoListModel.addToDo(
                _todoController.text,
              );
              _todoController.clear();
            },
            child: Container(
              alignment: Alignment.center,
              child: const Text('追加'),
            ),
          ),
          Expanded(
            child: ListView(
              children: todoListModel.todoList.map((todo) {
                return ListTile(
                  title: Text(
                    todo.title,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: Checkbox(
                    value: todo.checked,
                    onChanged: (bool? value) {
                      todoListModel.deleteToDo(todo);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

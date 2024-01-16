/*
  やったことメモ
  1. 必要なパッケージをインポート
  2. ToDoクラスを定義
  3. ToDoリストの状態管理クラスを定義
      ChangeNotifierを継承することで、データの変更時に通知を受け取ることができる
      ToDoクラスからなる配列を宣言
      ToDoリストを追加するメソッドを定義
      ToDoリストを完了(削除)にするメソッドを定義

  4. ToDoリストの表示を行うWidgetを定義
      ToDoリストの状態管理クラスを取得
      ToDoリストの配列をmapメソッドでWidgetの配列に変換(jsと似てる)
      ListTileを返す
      ListTileのtitleにはToDoのtitleを表示
      ListTileのtrailingにはCheckboxを表示
      CheckboxのvalueにはToDoのcheckedを表示
      CheckboxのonChangedにはToDoリストの状態管理クラスのmarkAsDoneメソッドを指定
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToDo {
  String title;
  bool? checked;

  ToDo([this.title = "", this.checked = false]);
}

class ToDoListModel extends ChangeNotifier {
  final List<ToDo> _todoList = [];

  List<ToDo> get todoList => _todoList;

  void addToDo(ToDo todo) {
    _todoList.add(todo);
    notifyListeners();
  }

  void markAsDone(ToDo todo) {
    todo.checked = true;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 500), () {
      _todoList.remove(todo);
      notifyListeners();
    });
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoListModel = Provider.of<ToDoListModel>(context);

    return ListView(
      children: todoListModel.todoList.map((todo) {
        return ListTile(
          title: Text(todo.title),
          trailing: Checkbox(
            value: todo.checked,
            onChanged: (value) {
              todoListModel.markAsDone(todo);
            },
          ),
        );
      }).toList(),
    );
  }
}

/*
  freezedでモデルを作成したが、ユースケースがよくわかっていない
  1/17
  freezedを使うことで、checkedの値はimuutableになる
  そのため、checkedの値を変更するには、copyWithメソッドを使う必要がある
  copyWithメソッドを使うと、新しくインスタンスが生成されるため、todoリスト配列の順番が変わってしまうので、不適合
*/

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

@freezed
class ToDo with _$ToDo {
  const factory ToDo({
    required String title,
    bool? checked,
  }) = _ToDo;

  factory ToDo.defaults() => const ToDo(
        title: '',
        checked: false,
      );
}

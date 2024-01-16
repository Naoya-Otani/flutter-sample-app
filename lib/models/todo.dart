/*
  freezedでモデルを作成したが、ユースケースがよくわかっていない
*/

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

@freezed
class ToDo with _$ToDo {
  const factory ToDo({
    required String title,
    bool? checked,
  }) = _ToDo;
}

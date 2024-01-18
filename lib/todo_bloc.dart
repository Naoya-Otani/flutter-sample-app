import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/todo.dart';

class ToDoList extends Equatable {
  const ToDoList({required this.toDoList});

  ToDoList.initial() : this(toDoList: <ToDo>[]);

  final List<ToDo> toDoList;

  ToDoList copyWith(List<ToDo>? toDoList) =>
      ToDoList(toDoList: toDoList ?? this.toDoList);

  @override
  List<Object?> get props => [toDoList];
}

@immutable
abstract class ToDoListEvent {}

class ToDoListAddEvent extends ToDoListEvent {
  ToDoListAddEvent(this.title);

  final String title;
}

class ToDoListCheckEvent extends ToDoListEvent {
  ToDoListCheckEvent(this.index);

  final int index;
}

class ToDoListBloc extends Bloc<ToDoListEvent, ToDoList> {
  ToDoListBloc() : super(ToDoList.initial()) {
    on<ToDoListAddEvent>(_onToDoListAdded);
    on<ToDoListCheckEvent>(_onToDoListChecked);
  }

  Future<void> _onToDoListAdded(
    ToDoListAddEvent event,
    Emitter<ToDoList> emit,
  ) async {
    final list = <ToDo>[];
    list.addAll(state.toDoList);
    list.add(ToDo(title: event.title, checked: false));
    emit(state.copyWith(list));
  }

  Future<void> _onToDoListChecked(
    ToDoListCheckEvent event,
    Emitter<ToDoList> emit,
  ) async {
    final index = event.index;
    final list = <ToDo>[];
    list.addAll(state.toDoList);
    if (index >= list.length) return;
    list[index] = ToDo(title: list[index].title, checked: true);
    emit(state.copyWith(list));
    list.removeAt(index);
    emit(state.copyWith(list));
  }
}

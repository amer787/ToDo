import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'todo_model.g.dart';
@HiveType(typeId: 0)
class ToDoModel{
  @HiveField(0)
  final String title;
  @HiveField(1)
    final String details;
 // bool  isCompleted;

 ToDoModel({required this.title, required this.details});
}
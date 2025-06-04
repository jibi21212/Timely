import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int prio;

  Task({required this.title, required this.prio});

  @override
  String toString() {
    return 'Task(title: $title, prio: $prio)';
  }
}
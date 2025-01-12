import 'package:isar/isar.dart';
// import 'package:uuid/uuid.dart';

part 'task.g.dart';

@collection
class Task {
  Id id;
  String title;
  String description;
  DateTime? deadline;

  @Enumerated(EnumType.ordinal32)
  Status status;

  Task({
    this.id = Isar.autoIncrement,
    String title = "Task",
    this.description = "",
    DateTime? deadline,
    this.status = Status.toDo
  }): // id = const Uuid().v4(),
      title = title.isEmpty ? "Task" : title,
      deadline = deadline ?? DateTime.now();

  @override
  String toString() {
    return "Task(id: $id, title: $title, description: $description, deadline: $deadline, status: $status)";
  }
}

enum Status {
  toDo,
  inProgress,
  done,
  length
}

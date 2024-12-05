import 'package:uuid/uuid.dart';

class Task {
  String uid;
  String title;
  String description;
  DateTime deadline;
  String status;

  Task({
    this.title = "Task",
    this.description = "",
    DateTime? deadline,
    this.status = 'To Do'
  }): uid = const Uuid().v4(),
      deadline = deadline ?? DateTime.now();

  @override
  String toString() {
    return "Task(uid: $uid, title: $title, description: $description, deadline: $deadline, status: $status)";
  }
}

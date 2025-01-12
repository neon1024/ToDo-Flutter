import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../models/task.dart';
import '../widgets/buttons.dart';


class HomeScreen extends StatefulWidget {
  final Isar isar;

  const HomeScreen({super.key, required this.isar});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Task> tasks = [];

  @override
  void initState() {
    super.initState();

    _loadTasks();  // Load tasks from the database when the screen first loads
  }

  Future<void> _loadTasks() async {
    final fetchedTasks = await widget.isar.tasks.where().findAll(); // Fetch all tasks from Isar

    // calls build() to re-build the widget with the updated data (doesn't call initState)
    setState(() {
      tasks = fetchedTasks;  // Update state with fetched tasks
    });
  }

  Future<void> addTask(Task task) async {
    await widget.isar.writeTxn(() async {
      await widget.isar.tasks.put(task); // Add task to Isar
    });

    // tasks.add(task);

    // load the updated data
    _loadTasks();
  }

  // void addTask(Task task) {
  //   setState(() {
  //     tasks.add(task);
  //   });
  // }

  Future<void> removeTaskById(Id idToRemove) async {
    await widget.isar.writeTxn(() async {
      await widget.isar.tasks.delete(idToRemove); // Remove task from Isar
    });

    // setState(() {
    //   tasks.removeWhere((task) => task.id == idToRemove);
    // });

    // load the updated data
    _loadTasks();
  }

  // void removeTaskById(Id idToRemove) {
  //   setState(() {
  //     tasks.removeWhere((task) { return task.id == idToRemove;});
  //   });
  // }

  Future<void> updateTask(Id updateId, Task newTask) async {
    await widget.isar.writeTxn(() async {
      await widget.isar.tasks.put(newTask); // Update task in Isar
    });

    // setState(() {
    //   int index = tasks.indexWhere((task) => task.id == updateId);
    //   tasks[index] = newTask;
    // });

    // load the updated data
    _loadTasks();
  }

  // void updateTask(Id updateId, Task newTask) {
  //   setState(() {
  //     int index = tasks.indexWhere((task) { return task.id == updateId; });
  //     tasks[index] = newTask;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  const Header(),
                  const FilterButtons(),

                  Expanded(
                    child: ListOfTasks(
                        tasks: tasks,
                        removeTaskById: removeTaskById,
                        updateTask: updateTask
                    ),
                  ),
                ],
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).size.height * 0.15,
                child: Align(
                  alignment: Alignment.center,
                  child: AddTaskButton(addTask: addTask),
                ),
              ),

            ]  // body: children
        ),
      ),
    );
  }
}

// Welcome message and avatar
class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<StatefulWidget> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  // TODO: change on login
  var username = "Ioan";

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,

      child: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF0F0F0F), // Background color of the container

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            // Text with the name
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Hello, ',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),

                  TextSpan(
                    text: username,
                    style: TextStyle(color: Colors.deepPurple[600], fontSize: 24),
                  ),
                ],
              ),
            ),

            // Profile icon
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,

              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ],  // children
        ),
      ),
    );
  }  // build
}  // _MainTopState

class ListOfTasks extends StatelessWidget {
  final List<Task> tasks;
  final Function(Id) removeTaskById;
  final Function(Id, Task) updateTask;

  const ListOfTasks({
    super.key,
    required this.tasks,
    required this.removeTaskById,
    required this.updateTask,
  });

  void _showTaskDetailsDialog(BuildContext context, Task task) {
    // Controllers for task fields
    TextEditingController titleController = TextEditingController(text: task.title);
    TextEditingController descriptionController = TextEditingController(text: task.description);
    TextEditingController deadlineController = TextEditingController(text: task.deadline.toString().split(' ')[0]);
    Status selectedStatus = task.status; // Track selected status

    bool isEditing = false;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title', border: InputBorder.none),
                        enabled: isEditing, // Editable only in edit mode
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description', border: InputBorder.none),
                        enabled: isEditing,
                      ),
                      TextField(
                        controller: deadlineController,
                        decoration: const InputDecoration(labelText: 'Deadline (YYYY-MM-DD)', border: InputBorder.none),
                        enabled: isEditing,
                      ),
                      // Use DropdownButtonFormField instead of DropdownButton
                      DropdownButtonFormField<String>(
                        value: _getStringFromStatus(selectedStatus),
                        items: <String>['To Do', 'In Progress', 'Done']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,

                                  decoration: BoxDecoration(
                                    color: _getStatusColor(_getStatusFromString(value)),
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                const SizedBox(width: 8), // Add spacing between the circle and text

                                Text(
                                  value, // Display task's status text
                                  style: TextStyle(
                                    color: _getStatusColor(_getStatusFromString(value)),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: isEditing ? (String? newStatus) {
                          if (newStatus != null) {
                            setState(() {
                              selectedStatus = _getStatusFromString(newStatus);
                            });
                          }
                        } : null, // Disable the dropdown if not editing
                        decoration: const InputDecoration(labelText: 'Status', border: InputBorder.none),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (isEditing) {
                                  // Save updates
                                  Task updatedTask = Task(
                                    id: task.id,  // Ensure the original id is preserved
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    deadline: DateTime.tryParse(deadlineController.text) ?? DateTime.now(),
                                    status: selectedStatus, // Use selected status
                                  );
                                  if(updatedTask.title.isNotEmpty) {
                                    updateTask(task.id, updatedTask);

                                    Navigator.of(context).pop();

                                    showConfirmationMessage(
                                        context, "Task updated successfully!");
                                  } else {
                                    Navigator.of(context).pop();

                                    showConfirmationMessage(
                                        context, "Couldn't update task!", isError: true);
                                  }
                                } else {
                                  isEditing = true; // Switch to edit mode
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(isEditing ? Icons.update : Icons.edit),
                                Text(isEditing ? 'Update' : 'Edit'),
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                // Confirm removal
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                        title: const Text("Confirm Removal"),
                                        content: const Text("Are you sure you want to remove this task?"),

                                        actions: <Widget>[
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(dialogContext).pop();
                                                    },
                                                    child: const Row(
                                                        children: [
                                                          Icon(Icons.cancel),
                                                          Text("Cancel")
                                                        ]
                                                    )
                                                ),

                                                const SizedBox(width: 8),

                                                TextButton(
                                                    onPressed: () {
                                                      removeTaskById(task.id);
                                                      showConfirmationMessage(context, "Task successfully removed!");

                                                      Navigator.of(dialogContext).pop();
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Row(
                                                        children: [
                                                          Icon(Icons.check),
                                                          Text("Remove")
                                                        ]
                                                    )
                                                )
                                              ]
                                          )
                                        ]
                                    );
                                  },
                                  barrierDismissible: false,
                                );  // showDialog
                              },  // onPressed
                              child: const Row(
                                  children: [
                                    Icon(Icons.delete),
                                    Text("Remove")
                                  ]
                              )
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];

        Color statusColor;

        switch (task.status) {
          case Status.toDo:
            statusColor = Colors.orange;
            break;

          case Status.inProgress:
            statusColor = Colors.blue;
            break;

          case Status.done:
            statusColor = Colors.green;
            break;

          default:
            statusColor = Colors.grey;
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Spacing around each task
          padding: const EdgeInsets.all(16), // Padding inside the task container

          decoration: BoxDecoration(
            color: const Color(0xFFEEF8FF), // Set background color of each task
            borderRadius: BorderRadius.circular(16), // Rounded corners for the task
          ),

          child: ListTile(
            title: Text(
              task.title,
              style: const TextStyle(color: Color(0xFF0F0F0F), fontSize: 24),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  task.description,
                  style: const TextStyle(color: Color(0xFF0F0F0F), fontSize: 16),
                ),
                const SizedBox(height: 8), // Add spacing between description and status

                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,

                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8), // Add spacing between the circle and text

                    Text(
                      _getStringFromStatus(task.status),  // Display task's status text
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            onTap: () {
              _showTaskDetailsDialog(context, task);
            },
          ),
        );
      },
    );
  }

  // TODO refactor the status methods? including the usage of status instead of DropDownMenu
  String _getStringFromStatus(Status status) {
    switch(status) {
      case Status.toDo:
        return "To Do";

      case Status.inProgress:
        return "In Progress";

      case Status.done:
        return "Done";

      default:
        return "";
    }
  }

  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.toDo:
        return Colors.orange;

      case Status.inProgress:
        return Colors.blue;

      case Status.done:
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  Status _getStatusFromString(String status) {
    switch(status) {
      case "To Do":
        return Status.toDo;

      case "In Progress":
        return Status.inProgress;

      case "Done":
        return Status.done;

      default:
        return Status.toDo;
    }
  }
}

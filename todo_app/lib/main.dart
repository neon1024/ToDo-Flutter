import 'package:flutter/material.dart';
import 'package:todo_app/task.dart';

void main() => runApp(const MainPage());

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Task> tasks = [];

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void removeTaskById(String idToRemove) {
    setState(() {
      tasks.removeWhere((task) { return task.uid == idToRemove;});
    });
  }

  void updateTask(String updateId, Task newTask) {
    setState(() {
      int index = tasks.indexWhere((task) { return task.uid == updateId; });
      tasks[index] = newTask;
    });
  }

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
                const MainTop(),
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
class MainTop extends StatefulWidget {
  const MainTop({super.key});

  @override
  State<StatefulWidget> createState() => _MainTopState();
}

class _MainTopState extends State<MainTop> {
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
  final Function(String) removeTaskById;
  final Function(String, Task) updateTask;

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
    String selectedStatus = task.status; // Track selected status

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
                        value: selectedStatus,
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
                                    color: _getStatusColor(value),
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                const SizedBox(width: 8), // Add spacing between the circle and text

                                Text(
                                  value, // Display task's status text
                                  style: TextStyle(
                                    color: _getStatusColor(value),
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
                              selectedStatus = newStatus;
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
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    deadline: DateTime.tryParse(deadlineController.text) ?? DateTime.now(),
                                    status: selectedStatus, // Use selected status
                                  );
                                  if(updatedTask.title.isNotEmpty) {
                                    updateTask(task.uid, updatedTask);

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
                              removeTaskById(task.uid);
                              Navigator.of(context).pop();

                              showConfirmationMessage(context, "Task removed successfully!");
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.delete),
                                Text('Remove'),
                              ],
                            ),
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
          case 'To Do':
            statusColor = Colors.orange;
            break;

          case 'In Progress':
            statusColor = Colors.blue;
            break;

          case 'Done':
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
                      task.status, // Display task's status text
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
}


Color _getStatusColor(String status) {
  switch (status) {
    case 'To Do':
      return Colors.orange;
    case 'In Progress':
      return Colors.blue;
    case 'Done':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

// TODO update all filter button states on each button press
// Filter buttons
class FilterButtons extends StatelessWidget {
  const FilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0f0f0f),
      padding: const EdgeInsets.all(16),

      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          ShowAllTasksButton(),
          ShowToDoTasksButton(),
          ShowInProgressTasksButton(),
          ShowDoneTasksButton()
        ],
      )
    );
  }
}

// Parent class for filter buttons
class FilterButton extends StatefulWidget {
  final buttonType;

  const FilterButton({super.key, required this.buttonType});

  @override
  State<StatefulWidget> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  var activatedButtonColor  = Colors.deepPurple[700];
  var deactivatedButtonColor = const Color(0xFFEEF8FF);
  var buttonColor = const Color(0xFFEEF8FF);
  var activatedTextColor = const Color(0xFFEEF8FF);
  var deactivatedTextColor = Colors.deepPurple[700];
  var textColor = Colors.deepPurple[700];

  void changeColor() {
    setState(() {
      buttonColor = ((buttonColor == deactivatedButtonColor) ? activatedButtonColor : deactivatedButtonColor)!;
      textColor = (textColor == deactivatedTextColor) ? activatedTextColor : deactivatedTextColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: changeColor,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(buttonColor),  // Set button color
          foregroundColor: WidgetStateProperty.all(textColor),  // Set text color
        ),
        child: Text(
            widget.buttonType == "ToDo" ? "To Do" :
            widget.buttonType == "InProgress" ? "In Progress" :
            widget.buttonType == "Done" ? "Done" :
            "All"
        )
    );
  }
}

// All button
class ShowAllTasksButton extends FilterButton {
  const ShowAllTasksButton({super.key}): super(buttonType: "All");
}

// ToDo button
class ShowToDoTasksButton extends FilterButton {
  const ShowToDoTasksButton({super.key}): super(buttonType: "ToDo");
}

// In Progress button
class ShowInProgressTasksButton extends FilterButton {
  const ShowInProgressTasksButton({super.key}): super(buttonType: "InProgress");
}

// Done button
class ShowDoneTasksButton extends FilterButton {
  const ShowDoneTasksButton({super.key}): super(buttonType: "Done");
}

class AddTaskButton extends StatelessWidget {
  final Function(Task) addTask; // AddTask method is passed from MainPage

  const AddTaskButton({super.key, required this.addTask});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddTaskDialog(context),
      backgroundColor: const Color(0xFF5E2BFF),
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Color(0xFFEEF8FF)),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String title = '';
    String description = '';
    DateTime deadline = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            elevation: 10,
            child: Padding(
              // Adjust the padding here
              padding: const EdgeInsets.all(16),  // Modify the padding value
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
                    onChanged: (value) {
                      deadline = DateTime.tryParse(value) ?? DateTime.now();
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Task newTask = Task(
                        title: title,
                        description: description,
                        deadline: deadline,
                      );
                      Navigator.of(context).pop(); // Close dialog

                      if(newTask.title != "" ) {
                        addTask(newTask);

                        showConfirmationMessage(
                            context, "Task added successfully!");
                      }
                      else {
                        showConfirmationMessage(
                            context, "Couldn't add task!", isError: true);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void showConfirmationMessage(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );
}

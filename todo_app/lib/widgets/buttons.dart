// TODO update all filter button states on each button press
// Filter buttons
import 'package:flutter/material.dart';

import '../models/task.dart';

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
  final String buttonType;

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

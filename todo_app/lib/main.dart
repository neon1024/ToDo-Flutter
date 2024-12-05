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

  // Function to add a task
  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MainTop(),
            const FilterButtons(),
            Expanded(
              child: ListOfTasks(tasks: tasks), // Passing the tasks to the list
            ),
            Expanded(
              child: AddTaskButton(addTask: addTask), // Passing the addTask method
            ),
          ],
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
          color: Colors.black, // Background color of the container

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

class ListOfTasks extends StatefulWidget {
  final List<Task> tasks;

  const ListOfTasks({super.key, required this.tasks});

  @override
  State<ListOfTasks> createState() => _ListOfTasksState();
}

class _ListOfTasksState extends State<ListOfTasks> {
  void _showTaskDetailsDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            elevation: 10,

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: TextEditingController(
                        text: task.title),
                    decoration: const InputDecoration(
                        labelText: 'Title',
                        border: InputBorder.none),
                    enabled: false, // Make it non-editable

                  ),

                  TextField(
                    controller: TextEditingController(
                        text: task.description),
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        border: InputBorder.none),
                    enabled: false, // Make it non-editable
                  ),

                  TextField(
                    controller: TextEditingController(
                        text: task.deadline.toString()),
                    decoration: const InputDecoration(
                        labelText: 'Deadline',
                        border: InputBorder.none),
                    enabled: false, // Make it non-editable
                  ),

                  TextField(
                    controller: TextEditingController(
                        text: task.status),
                    decoration: const InputDecoration(
                      labelText: "Status",
                      border: InputBorder.none),
                    enabled: false,
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: const Text('Close'),
                  ),
                ],
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
      itemCount: widget.tasks.length, // Access the tasks via the widget property
      itemBuilder: (context, index) {
        Task task = widget.tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          onTap: () {
            _showTaskDetailsDialog(context, task);
          },
        );
      },
    );
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

    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           TextField(
    //             decoration: const InputDecoration(labelText: 'Title'),
    //             onChanged: (value) {
    //               title = value;
    //             },
    //           ),
    //           TextField(
    //             decoration: const InputDecoration(labelText: 'Description'),
    //             onChanged: (value) {
    //               description = value;
    //             },
    //           ),
    //           TextField(
    //             decoration: const InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
    //             onChanged: (value) {
    //               deadline = DateTime.tryParse(value) ?? DateTime.now();
    //             },
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               Task newTask = Task(
    //                 title: title,
    //                 description: description,
    //                 deadline: deadline,
    //               );
    //               Navigator.of(context).pop(); // Close modal
    //               addTask(newTask); // Use the passed addTask function
    //             },
    //             child: const Text('Add'),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );

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
                      addTask(newTask); // Use the passed addTask function
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

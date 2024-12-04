import 'package:flutter/material.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
              child: Tasks()
            )
          ],
        )
      )
    );  // MaterialApp
  }  // build
}  // MainPage

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

class Tasks extends StatelessWidget {
  final List<String> tasks = List.generate(100, (index) => 'Task ${index + 1}');

  Tasks({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tasks[index]),
          onTap: () {
            print('Tapped on ${tasks[index]}');
          },
        );
      },
    );
  }
}

// TODO update all button states on each button press

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
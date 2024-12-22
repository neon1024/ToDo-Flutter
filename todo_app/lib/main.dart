import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/models/task.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures all bindings are initialized

  // Open the Isar instance
  final dir = await getApplicationDocumentsDirectory();  // Get the app's document directory
  final isar = await Isar.open([TaskSchema], directory: dir.path);  // Open the Isar database

  runApp(MainPage(isar: isar));  // Pass the Isar instance to your widget
  // runApp(const MainPage());
}

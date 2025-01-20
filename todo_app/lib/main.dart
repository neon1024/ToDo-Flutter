import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/models/task.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the Isar instance
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([TaskSchema], directory: dir.path);

  runApp(HomeScreen(isar: isar));
  // runApp(const MainPage());
}

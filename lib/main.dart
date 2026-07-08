import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'services/task_service.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'hive/hive_registrar.g.dart';

final todayTaskService = TaskService();
final recurringTaskService = TaskService(storageKey: "recurring_tasks");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapters();
  //great!
  await todayTaskService.init();
  await recurringTaskService.init();
  await recurringTaskService.resetDailyRoutineIfNeeded();
  runApp(const DandandoApp());
}

class DandandoApp extends StatelessWidget {
  const DandandoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DANDANDO',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

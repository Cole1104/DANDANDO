import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'services/task_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'models/task.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

final todayTaskService = TaskService(collectionName: "tasks");
final recurringTaskService = TaskService(collectionName: "recurring_tasks");
final authService = AuthService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await authService.signInAnonymously();
  print("UID: ${authService.currentUser?.uid}");
  todayTaskService.startListening();
  recurringTaskService.startListening();
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

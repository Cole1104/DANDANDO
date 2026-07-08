import 'dart:developer';

import 'package:dandando/services/task_service.dart';
import 'package:flutter/material.dart';
import '../theme/responsive.dart';
import '../components/dante_card.dart';
import '../components/task_section.dart';
import '../components/weekly_calendar.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DANDANDO"),

        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = Responsive.isTablet(context);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: isTablet
                ? Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Expanded(flex: 1, child: DanteCard()),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Column(
                              children: [
                                WeeklyCalendar(service: todayTaskService),
                                TaskSection(
                                  title: "To do lists",
                                  service: todayTaskService,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),
                      const Divider(color: Colors.white24, thickness: 1),
                      const SizedBox(height: 18),

                      TaskSection(
                        title: "Daily Routine",
                        service: recurringTaskService,
                        isRoutine: true,
                        showDateTitle: false,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      DanteCard(),

                      SizedBox(height: 20),

                      WeeklyCalendar(service: todayTaskService),

                      const SizedBox(height: 12),

                      TaskSection(
                        title: "To do lists",
                        service: todayTaskService,
                      ),

                      SizedBox(height: 18),
                      const Divider(color: Colors.white24, thickness: 1),
                      SizedBox(height: 18),
                      TaskSection(
                        title: "Daily Routine",
                        service: recurringTaskService,
                        isRoutine: true,
                        showDateTitle: false,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

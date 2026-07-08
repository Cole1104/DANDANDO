import 'package:flutter/material.dart';
import '../services/task_service.dart';

class WeeklyCalendar extends StatelessWidget {
  final TaskService service;

  const WeeklyCalendar({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final selected = service.selectedDate;
        final today = DateTime.now();

        final startOfWeek = selected.subtract(
          Duration(days: selected.weekday - 1),
        );

        const weekNames = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xff1E1E1E),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),

          child: Column(
            children: [
              /// 상단
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      service.setSelectedDate(
                        selected.subtract(const Duration(days: 7)),
                      );
                    },

                    icon: const Icon(Icons.chevron_left),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        "${selected.year}.${selected.month}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      service.setSelectedDate(
                        selected.add(const Duration(days: 7)),
                      );
                    },

                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: List.generate(7, (i) {
                  final date = startOfWeek.add(Duration(days: i));

                  final isSelected =
                      date.year == selected.year &&
                      date.month == selected.month &&
                      date.day == selected.day;

                  final isToday =
                      date.year == today.year &&
                      date.month == today.month &&
                      date.day == today.day;

                  final hasTask = service.hasTaskOnDate(date);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        service.setSelectedDate(date);
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),

                        margin: const EdgeInsets.symmetric(horizontal: 2),

                        padding: const EdgeInsets.symmetric(vertical: 10),

                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFF8A3D)
                              : Colors.transparent,

                          borderRadius: BorderRadius.circular(14),

                          border: isToday
                              ? Border.all(color: Colors.white30, width: 1.5)
                              : null,
                        ),

                        child: Column(
                          children: [
                            Text(
                              weekNames[i],

                              style: TextStyle(
                                fontSize: 11,

                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "${date.day}",

                              style: TextStyle(
                                fontSize: 18,

                                fontWeight: FontWeight.bold,

                                color: isSelected ? Colors.white : Colors.white,
                              ),
                            ),

                            const SizedBox(height: 6),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),

                              width: 5,

                              height: 5,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                color: hasTask
                                    ? const Color(0xFFFF8A3D)
                                    : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskSection extends StatefulWidget {
  final TaskService service;

  const TaskSection({
    super.key,
    required this.service,
    required this.title,
    this.showDateTitle = true,
    this.isRoutine = false,
  });

  final String title;
  final bool showDateTitle;
  final bool isRoutine;

  @override
  State<TaskSection> createState() => _TaskSectionState();
}

class _TaskSectionState extends State<TaskSection> {
  void _showTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? "");

    DateTime selectedDate = task?.date ?? widget.service.selectedDate;

    DateTime? startTime = task?.startTime;
    DateTime? endTime = task?.endTime;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(task == null ? "새 업무 추가" : "업무 수정"),

            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "업무"),
                  ),

                  const SizedBox(height: 16),
                  if (!widget.isRoutine)
                    ListTile(
                      title: Text(
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                      ),

                      leading: const Icon(Icons.calendar_today),

                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),

                  ListTile(
                    title: Text(
                      startTime == null
                          ? "시작 시간"
                          : TimeOfDay.fromDateTime(startTime!).format(context),
                    ),

                    leading: const Icon(Icons.schedule),

                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: startTime == null
                            ? TimeOfDay.now()
                            : TimeOfDay.fromDateTime(startTime!),
                      );

                      if (picked != null) {
                        setDialogState(() {
                          final baseDate = widget.isRoutine
                              ? DateTime(2000, 1, 1)
                              : selectedDate;

                          startTime = DateTime(
                            baseDate.year,
                            baseDate.month,
                            baseDate.day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      }
                    },
                  ),

                  ListTile(
                    title: Text(
                      endTime == null
                          ? "종료 시간"
                          : TimeOfDay.fromDateTime(endTime!).format(context),
                    ),

                    leading: const Icon(Icons.access_time),

                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: endTime == null
                            ? TimeOfDay.now()
                            : TimeOfDay.fromDateTime(endTime!),
                      );

                      if (picked != null) {
                        setDialogState(() {
                          final baseDate = widget.isRoutine
                              ? DateTime(2000, 1, 1)
                              : selectedDate;

                          endTime = DateTime(
                            baseDate.year,
                            baseDate.month,
                            baseDate.day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("취소"),
              ),

              FilledButton(
                onPressed: () async {
                  final title = titleController.text.trim();

                  if (title.isEmpty) return;

                  if (task == null) {
                    await widget.service.addTask(
                      title,
                      widget.isRoutine ? DateTime(2000, 1, 1) : selectedDate,
                      startTime,
                      endTime,
                    );
                  } else {
                    await widget.service.updateTask(
                      task,
                      title,
                      selectedDate,
                      startTime,
                      endTime,
                    );
                  }

                  Navigator.pop(context);
                },

                child: Text(task == null ? "추가" : "저장"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return AnimatedBuilder(
      animation: service,
      builder: (context, child) {
        final tasks = widget.isRoutine
            ? service.tasks
            : service.tasksForSelectedDate;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: _showTaskDialog,

                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index]; // ⭐ 핵심: 반드시 개별 Task

                    return ListTile(
                      leading: Checkbox(
                        value: task.isCompleted, // ✅ List ❌ Task ✔
                        onChanged: (value) async {
                          await service.toggleTask(task);
                        },
                      ),

                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),

                          if (widget.isRoutine && task.streak >= 2) ...[
                            const SizedBox(width: 8),
                            Text(
                              task.streak >= 30
                                  ? "🏆"
                                  : task.streak >= 7
                                  ? "✨"
                                  : "🔥",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${task.streak}",
                              style: TextStyle(
                                color: task.streak >= 30
                                    ? Colors.amber
                                    : task.streak >= 7
                                    ? Colors.deepOrange
                                    : const Color(0xFFFF8A3D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),

                      subtitle: Text(
                        "${task.startTime != null ? "${task.startTime!.hour.toString().padLeft(1, '0')}:${task.startTime!.minute.toString().padLeft(2, '0')}" : "--:--"}"
                        " ~ "
                        "${task.endTime != null ? "${task.endTime!.hour.toString().padLeft(1, '0')}:${task.endTime!.minute.toString().padLeft(2, '0')}" : "--:--"}",
                        style: const TextStyle(color: Colors.grey),
                      ),

                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),

                        onSelected: (value) async {
                          if (value == "edit") {
                            _showTaskDialog(task: task);
                          }

                          if (value == "delete") {
                            await service.deleteTask(task);
                          }
                        },

                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: "edit",
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined),

                                SizedBox(width: 10),

                                Text("Edit"),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            value: "delete",
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline),

                                SizedBox(width: 10),

                                Text("Delete"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> showDateTimePicker() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isRoutine) {
      widget.service.resetDailyRoutineIfNeeded();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasktide/models/task_model.dart';
import 'package:tasktide/screens/tasks/update_task.dart';
import 'package:tasktide/widgets/styled_text.dart';

import '../../../helpers/pallete.dart';
import '../../../providers/task_provider.dart';

class TaskTile extends StatefulWidget {
  final TaskModel task;
  const TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool deleteLoading = false;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    bool completed = widget.task.isCompleted;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  completed = !completed;
                });
                await taskProvider.toggleTaskStatus(
                    widget.task.taskId, completed);
                await taskProvider.getTasks();
              },
              child: Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: completed ? Pallete.primary : Colors.white,
                  border: Border.all(
                    color: Pallete.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: completed
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => UpdateTaskDialog(task: widget.task),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StyledText(
                      text: widget.task.title,
                      fontSize: 17.0,
                      maxLines: 1,
                      fontWeight: FontWeight.w600,
                    ),
                    StyledText(
                        text: DateFormat('dd MMM, yyyy').format(
                          widget.task.taskDate.toDate(),
                        ),
                        fontSize: 11.0),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  deleteLoading = true;
                });
                await taskProvider.deleteTask(widget.task.taskId);
                await taskProvider.getTasks();
                setState(() {
                  deleteLoading = false;
                });
              },
              child: deleteLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent))
                  : const Icon(
                      Icons.delete_rounded,
                      color: Colors.redAccent,
                      size: 27.0,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

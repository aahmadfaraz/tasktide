import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/pallete.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../widgets/styled_text.dart';

class UpdateTaskDialog extends StatefulWidget {
  final TaskModel task;

  const UpdateTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  State<UpdateTaskDialog> createState() => _UpdateTaskDialogState();
}

class _UpdateTaskDialogState extends State<UpdateTaskDialog> {
  final TextEditingController taskController = TextEditingController();
  late DateTime selectedDate;
  bool updateLoading = false;

  @override
  void initState() {
    super.initState();
    taskController.text = widget.task.title;
    selectedDate = widget.task.taskDate.toDate();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return updateLoading == true
        ? const Center(child: CircularProgressIndicator(color: Pallete.primary))
        : AlertDialog(
            scrollable: true,
            title: const Center(
              child: StyledText(
                text: 'Update Task',
                fontSize: 17.0,
                fontWeight: FontWeight.w800,
                color: Pallete.primary,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Pallete.darkBlue,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    ),
                    decoration: InputDecoration(
                      hintText: "Update Task..",
                      hintStyle: const TextStyle(
                        fontSize: 15.0,
                        color: Pallete.darkBlue,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    controller: taskController,
                  ),
                  InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Pallete.darkBlue,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Inter",
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Select Date',
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Pallete.darkBlue,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter",
                          ),
                          suffixIcon:
                              Icon(Icons.date_range, color: Pallete.primary),
                        ),
                        controller: TextEditingController(
                          text: DateFormat('dd MMM, yyyy').format(selectedDate),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const StyledText(
                  text: 'Cancel',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (taskController.text.isNotEmpty) {
                    setState(() {
                      updateLoading = true;
                    });
                    await taskProvider.updateTask(
                      TaskModel(
                        taskId: widget.task.taskId,
                        title: taskController.text,
                        taskDate: Timestamp.fromDate(selectedDate),
                        isCompleted: widget.task.isCompleted,
                      ),
                    );
                    await taskProvider.getTasks();
                    setState(() {
                      updateLoading = false;
                    });
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: updateLoading == true
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Pallete.primary))
                    : const StyledText(
                        text: 'Update',
                        fontSize: 15.0,
                        color: Pallete.primary,
                        fontWeight: FontWeight.bold,
                      ),
              ),
            ],
          );
  }
}

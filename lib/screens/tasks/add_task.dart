import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/pallete.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../widgets/styled_text.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key}) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController taskController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const StyledText(text: 'Action Required'),
          content: const Text(
            'You have reached the maximum limit of tasks. Please choose an action:',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const StyledText(text: 'Buy Pro Version'),
            ),
            TextButton(
              onPressed: () async {
                final removedItem = taskProvider.localTasks[0];
                taskProvider.localTasks.removeAt(0);

                await taskProvider.deleteTask(removedItem.taskId);
                await taskProvider.getTasks();
                if (mounted) Navigator.of(context).pop();
              },
              child: const StyledText(text: 'Remove First Todo Item'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    bool addLoading = false;

    return taskProvider.addLoading
        ? const Center(child: CircularProgressIndicator(color: Pallete.primary))
        : AlertDialog(
            scrollable: true,
            title: const Center(
              child: StyledText(
                text: '+ Add New Task',
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
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Add Task..",
                      // contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
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
                          // contentPadding:  EdgeInsets.symmetric(horizontal: 8.0),
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
                          text: selectedDate != null
                              ? DateFormat('dd MMM, yyyy').format(selectedDate!)
                              : '',
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
                  setState(() {
                    addLoading = true;
                  });
                  if (taskController.text.isNotEmpty &&
                      selectedDate != null &&
                      taskProvider.localTasks.length < 10) {
                    String taskId = DateTime.now().toUtc().toIso8601String();
                    await taskProvider.addTask(
                      TaskModel(
                        taskId: taskId,
                        title: taskController.text,
                        taskDate: Timestamp.fromDate(selectedDate!),
                        isCompleted: false,
                      ),
                    );
                    await taskProvider.getTasks();
                    setState(() {
                      addLoading = false;
                    });
                    if (mounted) Navigator.pop(context);
                  } else if (taskProvider.localTasks.length == 10) {
                    setState(() {
                      addLoading = true;
                    });
                    await _showConfirmationDialog(context);
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: addLoading == true
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Pallete.primary))
                    : const StyledText(
                        text: 'Add',
                        fontSize: 15.0,
                        color: Pallete.primary,
                        fontWeight: FontWeight.bold,
                      ),
              ),
            ],
          );
  }
}

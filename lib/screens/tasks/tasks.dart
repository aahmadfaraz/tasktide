import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasktide/screens/tasks/widgets/task_tile.dart';

import '../../helpers/pallete.dart';
import '../../providers/task_provider.dart';
import '../../widgets/styled_text.dart';
import 'add_task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void didChangeDependencies() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.getTasks();
    super.didChangeDependencies();
  }

  String contentType = "all";
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, tasks, child) {
        final inProgressTasks = tasks.tasks
            .where((element) => element.isCompleted == false)
            .toList();
        final completedTasks = tasks.tasks
            .where((element) => element.isCompleted == true)
            .toList();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    contentType = "all";
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: contentType == "all"
                                        ? Pallete.primary.withOpacity(.3)
                                        : Pallete.timeContainerColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: StyledText(
                                      text: "Your Tasks",
                                      fontSize: 17,
                                      fontWeight: contentType == "all"
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: contentType == "all"
                                          ? Pallete.primary
                                          : Pallete.darkBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    contentType = "finished";
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: contentType == "finished"
                                        ? Pallete.primary.withOpacity(.3)
                                        : Pallete.disabled,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: StyledText(
                                      text: "Finished",
                                      fontSize: 17,
                                      fontWeight: contentType == "finished"
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: contentType == "finished"
                                          ? Pallete.primary
                                          : Pallete.darkBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    contentType == "all"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0.0),
                            child: inProgressTasks.isEmpty
                                ? tasks.getLoading ||
                                        tasks.updateLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Pallete.primary,
                                        ),
                                      )
                                    : Center(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  .4,
                                            ),
                                            const StyledText(
                                              text: "No Tasks..",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      )
                                : SizedBox(
                                    height: MediaQuery.sizeOf(context).height*.7,
                                    child: ListView.builder(
                                      itemCount: inProgressTasks.length,
                                      itemBuilder: (context, index) {
                                        return TaskTile(
                                            task: inProgressTasks[index]);
                                      },
                                    ),
                                  ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0.0),
                            child: completedTasks.isEmpty
                                ? tasks.getLoading ||
                                        tasks.updateLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Pallete.primary,
                                        ),
                                      )
                                    : Center(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  .4,
                                            ),
                                            const StyledText(
                                              text: "No Tasks..",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      )
                                : SizedBox(
                                    height: MediaQuery.sizeOf(context).height*.7,
                                    child: ListView.builder(
                                      itemCount: completedTasks.length,
                                      itemBuilder: (context, index) {
                                        return TaskTile(
                                          task: completedTasks[index],
                                        );
                                      },
                                    ),
                                  ),
                          )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: contentType == "all"
              ? Container(
                  margin: const EdgeInsets.only(right: 30.0, bottom: 30.0),
                  child: FloatingActionButton(
                    backgroundColor: Pallete.primary,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddTaskDialog(),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

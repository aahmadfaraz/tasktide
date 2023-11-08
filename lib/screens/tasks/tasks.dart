import 'package:flutter/material.dart';
import 'package:tasktide/screens/tasks/widgets/task_tile.dart';

import '../../helpers/pallete.dart';
import '../../widgets/styled_text.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Play Cricket",
      "created": "10 Nov, 2023",
      "status": "pending",
    },
    {
      "title": "Play Cricket",
      "created": "10 Nov, 2023",
      "status": "finished",
    }
  ];

  String contentType = "all";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      child: SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return TaskTile(task: tasks[index]);
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0.0),
                      child: SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return TaskTile(task: tasks[index]);
                          },
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

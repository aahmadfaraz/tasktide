import 'package:flutter/material.dart';
import 'package:tasktide/widgets/styled_text.dart';

import '../../../helpers/pallete.dart';

class TaskTile extends StatefulWidget {
  final Map<String, dynamic> task;
  const TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
        height: 65,
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
            Checkbox(
                activeColor: Pallete.primary,
                value: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                onChanged: (value) {}),
            const SizedBox(
              width: 8,
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledText(
                    text: "Play Cricket",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  StyledText(text: "10 July, 2023", fontSize: 12.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

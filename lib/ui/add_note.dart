import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:to_do_app_rw/model/to_do_model.dart';
import 'package:to_do_app_rw/utils/constants.dart';

import '../utils/my_theme.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String currentDate = DateFormat('dd/MMM/yyyy').format(DateTime.now());
  NotePriority selectedPriority = NotePriority.LOW;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        title: Text(GetStrings.appName,
            style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 18)),
        actions: [
          IconButton(
              onPressed: () => setState(() => currentTheme.switchTheme()),
              tooltip: "Change Theme Mode",
              icon: Icon(currentTheme.currentTheme() == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              color: MyTheme.isDark ? GetColors.white : GetColors.black)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Add To-Do",
                    style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 18),
                  )),
                  IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance.collection("Notes").add({
                          GetStrings.note_title: titleController.text,
                          GetStrings.note_date: currentDate,
                          GetStrings.note_description: descriptionController.text,
                          GetStrings.note_priority: getPriorityString()
                        }).then((value) {
                          debugPrint(value.id);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Note added"),
                            backgroundColor: GetColors.green,
                          ));
                          Navigator.pop(context);
                        }).catchError((error) =>
                            debugPrint("Failed to add new Note due to $error"));
                      },
                      tooltip: "Save",
                      icon: Icon(Icons.save, color: Theme.of(context).primaryColor),
                      color: Theme.of(context).primaryColor),
                  IconButton(
                      onPressed: () {},
                      tooltip: "Grid",
                      icon: Icon(Icons.grid_view_outlined,
                          color: Theme.of(context).primaryColor),
                      color: Theme.of(context).primaryColor),
                  IconButton(
                      onPressed: () {},
                      tooltip: "Clear",
                      icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
                      color: Theme.of(context).primaryColor)
                ],
              ),
              const SizedBox(height: 10),
              Text('Priority',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16)),
              const SizedBox(height: 5),
              getPriorityWidget(),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
                maxLength: 150,
                decoration: const InputDecoration(
                    isDense: true, border: OutlineInputBorder(), labelText: 'Title'),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: descriptionController,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
                maxLength: 255,
                decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text("Pick Date",
                      style:
                          Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    color: GetColors.blue, size: 18),
                                const SizedBox(width: 5),
                                Text(
                                  "Date",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 14, color: GetColors.blue),
                                )
                              ],
                            )),
                        Text(currentDate,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 16))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getPriorityWidget() {
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontSize: 14, color: GetColors.black);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => selectedPriority = NotePriority.LOW),
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: selectedPriority == NotePriority.LOW
                      ? GetColors.priorityLow
                      : GetColors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
                  border: Border.all(color: GetColors.grey)),
              child: Text("Low", style: textStyle)),
        ),
        GestureDetector(
          onTap: () => setState(() => selectedPriority = NotePriority.MEDIUM),
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: selectedPriority == NotePriority.MEDIUM
                      ? GetColors.priorityMedium
                      : GetColors.white,
                  border: Border.all(color: GetColors.grey)),
              child: Text("Medium", style: textStyle)),
        ),
        GestureDetector(
          onTap: () => setState(() => selectedPriority = NotePriority.HIGH),
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: selectedPriority == NotePriority.HIGH
                      ? GetColors.priorityHigh
                      : GetColors.white,
                  border: Border.all(color: GetColors.grey)),
              child: Text("High", style: textStyle)),
        ),
        GestureDetector(
          onTap: () => setState(() => selectedPriority = NotePriority.URGENT),
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: selectedPriority == NotePriority.URGENT
                      ? GetColors.priorityUrgent
                      : GetColors.white,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                  border: Border.all(color: GetColors.grey)),
              child: Text("Urgent", style: textStyle)),
        )
      ],
    );
  }

  getPriorityString() {
    switch (selectedPriority) {
      case NotePriority.LOW:
        return 'low';
      case NotePriority.MEDIUM:
        return 'medium';
      case NotePriority.HIGH:
        return 'high';
      case NotePriority.URGENT:
        return 'urgent';
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app_rw/ui/add_note.dart';
import 'package:to_do_app_rw/utils/constants.dart';
import 'package:to_do_app_rw/utils/my_theme.dart';

class ToDoListing extends StatefulWidget {
  const ToDoListing({Key? key}) : super(key: key);

  @override
  State<ToDoListing> createState() => _ToDoListingState();
}

class _ToDoListingState extends State<ToDoListing> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(GetStrings.appName,
            style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 18)),
        actions: [
          IconButton(
              onPressed: () => setState(() => isGridView = !isGridView),
              tooltip: "Change Listing View",
              icon: Icon(isGridView ? Icons.grid_view_rounded : Icons.view_list),
              color: Theme.of(context).primaryColor),
          IconButton(
              onPressed: () => setState(() => currentTheme.switchTheme()),
              tooltip: "Change Theme Mode",
              icon: Icon(currentTheme.currentTheme() == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              color: MyTheme.isDark ? GetColors.white : GetColors.black)
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {

            return isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    itemCount: snapshot.data?.docs.length ?? 0,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return getGridItem(snapshot.data?.docs[index]);
                    })
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      debugPrint("snapshot: ${snapshot.data?.docs[0]['priority']}");
                      return getListItem(snapshot.data?.docs[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 10));
          }
          return Text(
            "there's no Notes",
            // style: GoogleFonts.nunito(color: Colors.white),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const AddNote())),
        tooltip: 'Add Note',
        child: const Icon(Icons.add, color: GetColors.black),
      ),
    );
  }

  getGridItem(data) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration:
          BoxDecoration(color: getColorBasedOnPriority(data[GetStrings.note_priority].toString()), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(data[GetStrings.note_title],
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline2),
              ),
              Chip(
                  label: Text(data[GetStrings.note_priority].toString().toLowerCase(), style: Theme.of(context).textTheme.bodyText1),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0))
            ],
          ),
          Expanded(
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(data[GetStrings.note_description].toString().toLowerCase(),
                    style: Theme.of(context).textTheme.bodyText1)),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Text(data[GetStrings.note_date].toString().toLowerCase(), style: Theme.of(context).textTheme.bodyText1))
        ],
      ),
    );
  }

  getListItem(data) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: getColorBasedOnPriority(data[GetStrings.note_priority].toString()),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: GetColors.black, width: 1.5)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(data[GetStrings.note_title],
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline2),
              ),
              Chip(
                  label: Text(data[GetStrings.note_priority].toString().toLowerCase(), style: Theme.of(context).textTheme.bodyText1),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0))
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(data[GetStrings.note_description],
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child:
                        Text(data[GetStrings.note_date], style: Theme.of(context).textTheme.bodyText1))
              ],
            ),
          )
        ],
      ),
    );
  }

  getColorBasedOnPriority (String priority){
    switch(priority) {
      case 'low':
        return GetColors.priorityLow;
      case 'medium':
        return GetColors.priorityMedium;
      case 'high':
        return GetColors.priorityHigh;
      case 'urgent':
        return GetColors.priorityUrgent;
      default:
        return GetColors.priorityLow;
    }
  }
}

enum NotePriority { LOW, MEDIUM, HIGH, URGENT }

class ToDoModel {
  NotePriority? priority = NotePriority.LOW;
  String? priorityString = "LOW";
  String? title;
  String? description;
  String? date;

  ToDoModel({this.priority, this.title, this.description, this.date});


}

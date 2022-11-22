class TaskModel {
  String? name;
  String? desc;
  String? imageUrl;
  bool? strike;
  DateTime? date;

  TaskModel({
    this.name,
    this.strike,
    this.date,
    this.desc,
    this.imageUrl,
  });

  TaskModel.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    date = map["date"];
    strike = map["strike"];
    imageUrl = map["imageUrl"];
    desc = map["desc"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "desc": desc,
      "date": date,
      "strike": strike,
      "imageUrl": imageUrl,
    };
  }
}

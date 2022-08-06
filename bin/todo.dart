class Todo {
  String? id;
  String title;

  Todo({this.id, required this.title});

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  Todo copyWith({String? id, String? title}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }
}

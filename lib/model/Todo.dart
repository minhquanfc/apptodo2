class Todo {
  int id;
  String content;
  bool complete;

  Todo({required this.id, required this.content, required this.complete});

  static Todo fromMap(Map<String, dynamic> map) {
    bool status = false;
    if (map['complete'] == 0) {
      return Todo(id: map['id'], content: map['content'], complete: status);
    } else {
      status = true;
      return Todo(id: map['id'], content: map['content'], complete: status);
    }
  }

  @override
  String toString() {
    return 'Todo{id: $id, content: $content, complete: $complete}';
  }
}

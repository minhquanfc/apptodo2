import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/Todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem(
      {Key? key,
      required this.todo,
      this.handleChangeStatus,
      this.handleDelete})
      : super(key: key);
  final bool checkBox = false;
  final handleChangeStatus;
  final handleDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: Checkbox(
            value: todo.complete,
            onChanged: (value) => {handleChangeStatus(todo.id, value)}),
        title: todo.complete
            ? Text(
                todo.content,
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              )
            : Text(
                todo.content,
                style: const TextStyle(decoration: TextDecoration.none),
              ),
        // subtitle: const Text('johndoe@example.com'),
        trailing: SizedBox(
          width: 35,
          height: 35,
          child: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Bạn có muốn xóa không?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          handleDelete(todo.id);
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
      ),
    );
  }
}

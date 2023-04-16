import 'package:apptodo2/sql/mySql.dart';
import 'package:apptodo2/widget/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model/Todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
        ),
        fontFamily: 'MyFont'
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> mapList = [];
  List<Todo> todolist = [];
  // List<Todo> todolist = mapList.map((e) => Todo.fromMap(e)).toList();


  List<Todo> _filteredTodos = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final mySql MySql = mySql();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTodos();
  }
  Future<void> _loadTodos() async {
    List<Map<String, dynamic>> todos = await MySql.getTodos();
    setState(() {
      mapList = todos;
      todolist = mapList.map((e) => Todo.fromMap(e)).toList();
      _filteredTodos = todolist;
    });
  }

  void _handleSearch(String query) {
    if (searchController.text.isNotEmpty) {
      List<Todo> filteredList = todolist
          .where((todo) =>
              todo.content.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _filteredTodos = filteredList;
      });
    } else {
      _filteredTodos = todolist;
      setState(() {
      });
    }
  }

  void handleChangeStatus(id,value) {
    if (value == true) {
      var data = {
        'complete':value,
      };
      MySql.updateData(id, data);
    } else {
      var data = {
        'complete':value,
      };
      MySql.updateData(id, data);
    }
    setState(() {
      _loadTodos();
    });
  }

  void handleDelete(int id) {
    MySql.deleteData(id);
    showToast("Xóa thành công");
    setState(() {
      _loadTodos();
    });
  }

  void inSert() {
    if (titleController.text.isEmpty) {
      showToast("Vui lòng không để trống");
      return;
    } else {
      var data = {'content': titleController.text, 'complete': false};
      MySql.insertData(data);
      titleController.clear();
      Navigator.of(context).pop();
      showToast("Thêm thành công");
      setState(() {
        _loadTodos();
      });
    }
  }

  void showToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.menu, color: Colors.black, size: 30),
            SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/avtapp.jpg'),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 50),
          child: Column(
            children: [
              const txtAlltodos(),
              searchBox(),
              for (Todo todo in _filteredTodos)
                TodoItem(
                  todo: todo,
                  handleChangeStatus: handleChangeStatus,
                  handleDelete: handleDelete,
                )
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFECECEC),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return bottomSheet(context);
              });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }

  Padding bottomSheet(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(children: [
          SizedBox(
            height: 60,
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: "Thêm todo",
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  inSert();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: const Text(
                  "Thêm",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Container searchBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        autofocus: false,
        controller: searchController,
        onChanged: _handleSearch,
        decoration: const InputDecoration(
            hintText: 'Tìm kiếm',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25)),
      ),
    );
  }
}

class txtAlltodos extends StatelessWidget {
  const txtAlltodos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      alignment: Alignment.topLeft,
      child: const Text(
        "All ToDos",
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/dbhelper.dart';
import 'package:todos_app/screens/todo_detail.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DbHelper helper = DbHelper();
  List<Todo> todos = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo('', 3, '', ''));
        },
        tooltip: "Add new Todo",
        child: Icon(Icons.add),
      ),
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((value) {
      final todosFuture = helper.getTodos();
      todosFuture.then((value) {
        List<Todo> todoList = [];
        count = value.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(value[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
      });
    });
  }

  ListView todoListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: getColor(this.todos[position].priority),
                  child: Text(this.todos[position].priority.toString()),
                ),
                title: Text(this.todos[position].title),
                subtitle: Text(this.todos[position].date),
                onTap: () {
                  debugPrint("Tapped on ${this.todos[position].id.toString()}");
                  navigateToDetail(this.todos[position]);
                },
              ));
        });
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo)),
    );
    if (result == true) {
      getData();
    }
  }

  Color getColor(int priority) {
    Color result;
    switch (priority) {
      case 1:
        result = Colors.red;
        break;
      case 2:
        result = Colors.yellow;
        break;
      case 3:
        result = Colors.green;
        break;
      default:
        result = Colors.green;
    }
    return result;
  }
}

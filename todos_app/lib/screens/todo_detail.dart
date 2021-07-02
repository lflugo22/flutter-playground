import 'package:flutter/material.dart';
import 'package:todos_app/model/todo.dart';
import 'package:todos_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = DbHelper();

final List<String> choices = const [
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];

const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo';
const mnuBack = 'Back to List';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  _TodoDetailState createState() => _TodoDetailState(todo);
}

class _TodoDetailState extends State<TodoDetail> {
  Todo todo;
  _TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  // ignore: unused_field
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: [
          PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 35, left: 10, right: 10),
        child: ListView(
          children: [
            Column(
              children: [
                TextField(
                  controller: titleController,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => updateTitle(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (value) => updateDescription(),
                  ),
                ),
                ListTile(
                  title: DropdownButton<String>(
                    items: _priorities.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriority(todo.priority),
                    onChanged: (value) => updatePriority(value!),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (todo.id == null) {
          return;
        }
        result = await helper.deleteTodo(todo.id!);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text('Delete Todo'),
            content: Text('The Todo has been deleted'),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void save() {
    todo.date = DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  String getPriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }
}

import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/todo.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];
  final TextEditingController controller = TextEditingController();

  void _loadTodos() async {
    final list = await DatabaseHelper().getTodos();
    setState(() => todos = list);
  }

  void _addTodo() async {
    if (controller.text.isEmpty) return;
    await DatabaseHelper().insertTodo(Todo(title: controller.text));
    controller.clear();
    _loadTodos();
  }

  void _deleteTodo(int id) async {
    await DatabaseHelper().deleteTodo(id);
    _loadTodos();
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller)),
                IconButton(onPressed: _addTodo, icon: Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (_, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTodo(todo.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

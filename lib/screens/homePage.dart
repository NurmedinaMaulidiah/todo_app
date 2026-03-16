import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_models.dart';
import '../services/todo_services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoService _todoService = TodoService();
  final TextEditingController _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  DateTime? selectedDate;


  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("User belum login")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My To-Do List"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
body: Column(
  children: [

    Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [

          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Tambah To-Do baru...",
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),

              Text(
                selectedDate == null
                    ? "Pilih tanggal"
                    : DateFormat('dd MMM yyyy').format(selectedDate!),
              ),

              Spacer(),

              IconButton(
                icon: Icon(Icons.edit_calendar),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
            ],
          ),

          SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {

                  _todoService.addTodo(
                    user!.uid,
                    _controller.text,
                    selectedDate,
                  );

                  _controller.clear();

                  setState(() {
                    selectedDate = null;
                  });
                }
              },
              child: Text("Add Todo"),
            ),
          ),

        ],
      ),
    ),

    Expanded(
      child: StreamBuilder<List<Todo>>(
        stream: _todoService.getTodos(user!.uid),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data!;

          if (todos.isEmpty) {
            return Center(child: Text("Belum ada To-Do"));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {

              final todo = todos[index];

              bool isOverdue =
                  todo.dueDate != null &&
                  todo.dueDate!.isBefore(DateTime.now()) &&
                  !todo.isDone;

              return Dismissible(
                key: Key(todo.id),

                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.edit, color: Colors.white),
                ),

                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),

                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _todoService.deleteTodo(user!.uid, todo.id);
                  }
                },

                child: ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),

                  subtitle: todo.dueDate != null
                      ? Text(
                          DateFormat('dd MMM yyyy')
                              .format(todo.dueDate!),
                          style: TextStyle(
                            color:
                                isOverdue ? Colors.red : Colors.grey,
                          ),
                        )
                      : null,

                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) {
                      todo.isDone = value ?? false;
                      _todoService.updateTodo(user!.uid, todo);
                    },
                  ),

                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _todoService.deleteTodo(user!.uid, todo.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  ],
),
    );
  }
}
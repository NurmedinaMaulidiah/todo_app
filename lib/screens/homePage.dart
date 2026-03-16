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
  DateTime? selectedDate; //untuk sleect tgl
  TimeOfDay? selectedTime; //utk select jam


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

          Row(
            children: [
              Icon(Icons.access_time),
              SizedBox(width: 8,),
              
              Text(
                selectedTime == null
                  ? "Pilih Jam"
                  : selectedTime!.format(context)
              ),

              Spacer(),

              IconButton(onPressed: () async{
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now()
                );
                if (picked != null){
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
               icon: Icon(Icons.schedule))
            ],
          ),

          SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                      DateTime? finalDate;
                      if (selectedDate != null && selectedTime != null){
                        finalDate = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );
                      }
                      _todoService.addTodo(
                        user!.uid,
                        _controller.text,
                        finalDate
                        );
                  // _todoService.addTodo(
                  //   user!.uid,
                  //   _controller.text,
                  //   selectedDate,
                  // ); TANPA JAM

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
          //grouping by prioritas
          final now = DateTime.now();
          //OVERDUE
          final overdueTodos = todos.where((todo) =>
           todo.dueDate != null &&
           todo.dueDate!.isBefore(now) &&
           !todo.isDone
           ).toList();

           //Today
           final todayTodos = todos.where((todo) =>
            todo.dueDate != null &&
            DateUtils.isSameDay(todo.dueDate, now) &&
            !todo.isDone
          ).toList();
          //Besok
          final tomorrow = now.add(Duration(days: 1));
          
          final tomorrowTodos = todos.where((todo) => 
          todo.dueDate != null &&
          DateUtils.isSameDay(todo.dueDate, tomorrow) &&
          !todo.isDone
          ).toList();
          //Setelah Besok or Upcoming
          final upcomingTodos = todos.where((todo) =>
           todo.dueDate != null &&
           todo.dueDate!.isAfter(tomorrow) &&
           !todo.isDone
           ).toList();

           // COMPLETED
          final completedTodos = todos.where((todo) => todo.isDone).toList();


          if (todos.isEmpty) {
            return Center(child: Text("Belum ada To-Do"));
          }

         //GROUPING 
         return ListView(
          children: [

            if (overdueTodos.isNotEmpty) ...[
              _buildSectionTitle("OVERDUE"),
              ...overdueTodos.map((todo) => _buildTodoItem(todo)),
            ],

            if (todayTodos.isNotEmpty) ...[
              _buildSectionTitle("TODAY"),
              ...todayTodos.map((todo) => _buildTodoItem(todo)),
            ],

            if (tomorrowTodos.isNotEmpty) ...[
              _buildSectionTitle("TOMORROW"),
              ...tomorrowTodos.map((todo) => _buildTodoItem(todo)),
            ],

            if (upcomingTodos.isNotEmpty) ...[
              _buildSectionTitle("UPCOMING"),
              ...upcomingTodos.map((todo) => _buildTodoItem(todo)),
            ],

            if (completedTodos.isNotEmpty) ...[
              _buildSectionTitle("COMPLETED"),
              ...completedTodos.map((todo) => _buildTodoItem(todo)),
            ],

          ],
        );
        },
      ),
    ),
  ],
),
    );
  }
  //function list view build section
  Widget _buildSectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
  );
}

//function list view buil to do
Widget _buildTodoItem(Todo todo) {
  bool isOverdue =
      todo.dueDate != null &&
      todo.dueDate!.isBefore(DateTime.now()) &&
      !todo.isDone;

//Proses Swipe Kiri Kanan
  return Dismissible(
    key: UniqueKey(), //ganti jadi value key biar unik dari yg lain
  confirmDismiss: (direction) async {
    if (direction == DismissDirection.startToEnd) {
      _showEditDialog(todo);
    return false;
    }
    if (direction == DismissDirection.endToStart) {
      return true;
  }

    return false;
  },

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
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),

      subtitle: todo.dueDate != null
          ? Text(
              DateFormat('dd MMM yyyy HH:mm').format(todo.dueDate!),
              style: TextStyle(
                color: isOverdue ? Colors.red : Colors.grey,
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
        onPressed: () {
          _todoService.deleteTodo(user!.uid, todo.id);
        },
      ),
    ),
  );
}

//function _showEditDialog SWIPE KANAN KIRI
void _showEditDialog(Todo todo) {

  TextEditingController editController =
      TextEditingController(text: todo.title);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Edit Todo"),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            hintText: "Edit todo...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {

              if (editController.text.isNotEmpty) {

                todo.title = editController.text;

                _todoService.updateTodo(user!.uid, todo);

                Navigator.pop(context);
              }

            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}

}
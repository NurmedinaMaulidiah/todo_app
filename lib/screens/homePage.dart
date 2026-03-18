import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/profilePage.dart';
import '../models/todo_models.dart';
import '../services/todo_services.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/theme/app_theme.dart';

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
      // return Scaffold(
      //   body: Center(child: Text("User belum login")),
      // );
    }


    return Scaffold(
      backgroundColor: AppTheme.gradientGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My To-Do List"),
        actions: [
         IconButton(
  icon: Icon(Icons.person_2_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          )
        ],
      ),
body: 
Container(
decoration: BoxDecoration(
  gradient: LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    AppTheme.gradientGreen, // warna atas
     AppTheme.darkBg,        // warna bawah
    ],
  ),
),
  child: Column(
  children: [

    Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [

          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "What do you need to do?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          SizedBox(height: 15),

          Row(
            children: [
              Expanded(child: 
              ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pressedColor, // warna background tombol
                foregroundColor: Colors.white,           // warna teks & icon
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // sudut tumpul
                ),
              ),
              icon: Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? "Select Date"
                    : DateFormat('dd MMM yyyy').format(selectedDate!),
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            )
          ),
          SizedBox(width: 10,),
          Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.pressedColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(Icons.access_time),
        label: Text(
          selectedTime == null
              ? "Select Time"
              : selectedTime!.format(context),
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                      });
                    }
                  },
                ),
              ),
            ],
          ),

              SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {

        // VALIDASI TODO KOSONG
        if (_controller.text.trim().isEmpty) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Todo tidak boleh kosong"),
              backgroundColor: Colors.red,
            ),
          );

          return;
        }

        // VALIDASI TANGGAL MASA LALU
        if (selectedDate != null) {

          final now = DateTime.now();

          if (selectedDate!.isBefore(DateTime(now.year, now.month, now.day))) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Tanggal tidak boleh di masa lalu"),
                backgroundColor: Colors.orange,
              ),
            );

            return;
          }
        }

        try {

          DateTime? finalDate;

          if (selectedDate != null && selectedTime != null) {

            finalDate = DateTime(
              selectedDate!.year,
              selectedDate!.month,
              selectedDate!.day,
              selectedTime!.hour,
              selectedTime!.minute,
            );
            final now = DateTime.now();

              if (selectedDate != null && selectedTime != null) {

                final selectedDateTime = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                if (selectedDateTime.isBefore(now)) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Jam yang dipilih sudah lewat"),
                      backgroundColor: Colors.orange,
                    ),
                  );

                  return;
                }
              }
          }

          await _todoService.addTodo(
            user!.uid,
            _controller.text,
            finalDate,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Todo berhasil ditambahkan"),
              backgroundColor: Colors.green,
            ),
          );

          _controller.clear();

          setState(() {
            selectedDate = null;
            selectedTime = null;
          });

        } catch (e) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal menambahkan todo"),
              backgroundColor: Colors.red,
            ),
          );

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
)
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

  return Dismissible(
    key: UniqueKey(),
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

    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
      color: todo.isDone
          ? AppTheme.gradientGreen.withOpacity(0.3)   // completed → hijau tua lebih lembut
          : isOverdue
              ? AppTheme.pressedColor.withOpacity(0.3) // overdue → gelap tapi soft
              : AppTheme.primaryColor.withOpacity(0.2), // aktif → hijau pastel soft
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
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
            _showDeleteDialog(todo);
          },
        ),
      ),
    ),
  );
}

void _showDeleteDialog(Todo todo) {

  showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(
        title: Text("Hapus Todo"),
        content: Text("Apakah Anda yakin ingin menghapus todo ini?"),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Batal"),
          ),

          TextButton(
            onPressed: () {

              _todoService.deleteTodo(user!.uid, todo.id);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Todo berhasil dihapus"),
                ),
              );

            },
            child: Text("Hapus"),
          ),

        ],
      );

    },
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
          onPressed: () async {

            // VALIDASI TODO KOSONG
            if (editController.text.trim().isEmpty) {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Todo tidak boleh kosong"),
                  backgroundColor: Colors.red,
                ),
              );

              return;
            }

            try {

              todo.title = editController.text;

              await _todoService.updateTodo(user!.uid, todo);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Todo berhasil diperbarui"),
                  backgroundColor: Colors.green,
                ),
              );

            } catch (e) {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Gagal memperbarui todo"),
                  backgroundColor: Colors.red,
                ),
              );

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
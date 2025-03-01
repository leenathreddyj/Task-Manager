import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

class Task {
  String name;
  bool isCompleted;
  String priority;
  DateTime createdAt;

  Task({required this.name, this.isCompleted = false, required this.priority})
      : createdAt = DateTime.now();
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final List<Task> _tasks = [];
  String _selectedPriority = 'Medium';
  final List<String> _priorities = ['High', 'Medium', 'Low'];

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(name: _taskController.text, priority: _selectedPriority));
        _taskController.clear();
        _sortTasks();
      });
    }
  }

  void _toggleCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _sortTasks() {
    setState(() {
      _tasks.sort((a, b) {
        return _priorities.indexOf(a.priority).compareTo(_priorities.indexOf(b.priority));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () {
              setState(() {
                _tasks.clear();
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter task',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: _priorities.map((String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Checkbox(
                        value: _tasks[index].isCompleted,
                        onChanged: (value) => _toggleCompletion(index),
                      ),
                      title: Text(
                        _tasks[index].name,
                        style: TextStyle(
                          decoration: _tasks[index].isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Priority: ${_tasks[index].priority}\nAdded: ${_tasks[index].createdAt.toLocal()}'.split('.')[0],
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

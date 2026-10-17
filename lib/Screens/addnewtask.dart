
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app1/DB/dbhelper.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  DateTime selectedDate = DateTime.now();

  String priority = 'Medium';

  // Format selected date
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return months[month - 1];
  }

  // Open date picker
  Future<void> pickDate() async {
    final DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(today.year + 10, 12, 31),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Save task (UI demonstration only)
  Future<void> saveTask() async {
    String title=titleController.text;
    String description=descriptionController.text;
    String date=formatDate(selectedDate);
    int prio=1;
    if(priority=="Medium") prio=2;
    else if(priority=="High") prio=3;
    
    String query='''
   insert into TodoTask (title,description,date,priority,completionStatus)
   values('${title}','${description}','${date}',${prio},0)
  ''';
   Database db=await DBHelper.instansce.database;
   int rowID=await db.rawInsert(query);
   if(rowID>0){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data inserted successfully'))
    );
   }
   else{
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data insertion Failed...'))
    );

   }


    
  }

  // Reusable section heading
  Widget sectionTitle(String title, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        required ? '$title *' : title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  // Reusable priority option
  Widget priorityOption(String value) {
    return RadioListTile<String>(
      value: value,
      groupValue: priority,
      title: Text(value),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            priority = newValue;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              sectionTitle('Task Title', required: true),

              TextFormField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Enter task title',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),

              const SizedBox(height: 24),

              // Description
              sectionTitle('Description'),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration:  InputDecoration(
                  hintText: 'Enter task description...',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              // Date
              sectionTitle('Date', required: true),

              InkWell(
                onTap: pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month),
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                  ),
                  child: Text(formatDate(selectedDate)),
                ),
              ),

              const SizedBox(height: 24),

              // Priority
              sectionTitle('Priority', required: true),

              Card(
                child: Column(
                  children: [
                    priorityOption('Low'),
                    priorityOption('Medium'),
                    priorityOption('High'),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: saveTask,
                  icon: const Icon(Icons.check),
                  label: const Text('Save Task'),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

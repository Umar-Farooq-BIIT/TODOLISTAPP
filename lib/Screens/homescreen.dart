import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app1/DB/dbhelper.dart';
import 'package:todo_app1/Screens/addnewtask.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDaataLoaded=false;
List<Map<String,dynamic>> rows=[];
 Future<void> fetchData() async
 {
  String query="Select * from TodoTask";
   Database db=await DBHelper.instansce.database; 
    rows=await db.rawQuery(query);
    isDaataLoaded=true;
    setState(() {
      
    });
 }

  void initState()
  {
    fetchData();
  }
 



Widget buildRow(Map<String, dynamic> row) {
  final bool isCompleted = row['completionStatus'] == 1;
  final int priorityValue = row['priority'] ;

  final String priorityText = switch (priorityValue) {
    1 => 'Low',
    2 => 'Medium',
    3 => 'High',
    _ => 'Medium',
  };

  final Color priorityColor = switch (priorityValue) {
    1 => Colors.green,
    2 => Colors.orange,
    3 => Colors.red,
    _ => Colors.orange,
  };

  final Color primaryColor =
      Theme.of(context).colorScheme.primary;

  return Card(
    margin: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 4,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status
          Row(
            children: [
              Expanded(
                child: Text(
                  row['title'] ?? 'Untitled Task',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isCompleted
                    ? Icons.check_circle
                    : Icons.pending_outlined,
                size: 19,
                color: isCompleted
                    ? Colors.green
                    : primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                isCompleted ? 'Done' : 'Pending',
                style: TextStyle(
                  fontSize: 11,
                  color: isCompleted
                      ? Colors.green
                      : primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Description without spread operator
          if ((row['description'] ?? '').toString().isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  row['description'].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

          const SizedBox(height: 7),

          // Date and priority
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 15,
                color: primaryColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  row['date']?.toString() ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  priorityText,
                  style: TextStyle(
                    fontSize: 11,
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          const Divider(height: 12),

          // Compact action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
                tooltip: 'Edit',
                onPressed: () {},
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 19,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
                tooltip: 'Delete',
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_outline,
                  size: 19,
                  color: Colors.red,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
                tooltip: isCompleted
                    ? 'Mark as pending'
                    : 'Mark as complete',
                onPressed: () {},
                icon: Icon(
                  isCompleted
                      ? Icons.undo
                      : Icons.check_circle_outline,
                  size: 19,
                  color: isCompleted
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}



 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
       await Navigator.push(context, MaterialPageRoute(builder: (context){
          return AddTaskScreen();
        }));
        fetchData();
      

      },child: Text('+'),),

      body: isDaataLoaded==false?Center(child: CircularProgressIndicator(),):
           rows.isEmpty?Center(child: Text('No Data available'),):
           SafeArea(
             child: Expanded(
               child: Container(
                 child: ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context,index){
                    return buildRow(rows[index]);
                 
                  }),
               ),
             ),
           )



    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_dismissible_example_app/task_tile.dart';
import 'settings_page.dart'; // 설정 페이지 파일 import
import 'help_page.dart'; // 도움말 페이지 파일 import

class Task {
  String title;
  String details;
  bool isExpanded;
  bool isCompleted;

  Task({
    required this.title,
    this.details = '',
    this.isExpanded = false,
    this.isCompleted = false,
  });
}

class DismissibleTodo extends StatefulWidget {
  @override
  _DismissibleExampleState createState() => _DismissibleExampleState();
}

class _DismissibleExampleState extends State<DismissibleTodo> {
  List<Task> tasks = [];
  List<Task> completedTasks = [];

  int get completedTaskCount => completedTasks.length;

  double get progressPercentage =>
      tasks.isEmpty && completedTasks.isEmpty
          ? 0
          : completedTaskCount / (tasks.length + completedTasks.length);

  void addTask() async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String newTask = '';
        return AlertDialog(
          title: Text('새로운 할 일 추가'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newTask = value;
            },
            decoration: InputDecoration(hintText: '할 일을 입력하세요'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('추가'),
              onPressed: () {
                Navigator.of(context).pop(newTask);
              },
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        tasks.add(Task(title: result));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('밀어서 할 일 해결'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == '설정') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              } else if (result == 'Option 2') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: '설정',
                child: Text('설정'),
              ),
              const PopupMenuItem<String>(
                value: 'Option 2',
                child: Text('Option 2'),
              ),
            ],
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list, size: 64, color: Colors.grey),
            SizedBox(height: 24),
            Text(
              '할 일 목록이 비어있습니다.',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: addTask,
              child: Text('새로운 할 일 추가'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Dismissible(
              key: UniqueKey(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('확인'),
                        content: Text('이 태스크를 삭제하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('예'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('아니오'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return true;
                }
              },
              onDismissed: (direction) {
                setState(
                      () {
                    if (direction == DismissDirection.endToStart) {
                      Task removedTask = tasks.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${removedTask.title} 삭제됨'),
                          action: SnackBarAction(
                            label: '실행 취소',
                            onPressed: () {
                              setState(() {
                                tasks.insert(index, removedTask);
                              });
                            },
                          ),
                        ),
                      );
                    } else {
                      Task completedTask = tasks.removeAt(index);
                      completedTask.isCompleted = true;
                      completedTasks.add(completedTask);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${completedTask.title} 완료됨'),
                        ),
                      );
                    }
                  },
                );
              },
              background: Container(
                color: Colors.green,
                child: Icon(Icons.check, color: Colors.white),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
              ),
              child: TaskTile(
                task: tasks[index],
                onDetailsChanged: (newDetails) {
                  setState(() {
                    tasks[index].details = newDetails;
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        '해결된 Todo: ${completedTasks.length} / 총 Todo: ${tasks.length + completedTasks.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Stack(
                        children: [
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progressPercentage,
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.green],
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${(progressPercentage * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: addTask,
                  tooltip: '태스크 추가',
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // 하단 여백 추가
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

void main() => runApp(MaterialApp(
  home: DismissibleTodo(),
));

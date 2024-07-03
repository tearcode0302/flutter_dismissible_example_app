import 'package:flutter/material.dart';

import 'dismissible_example.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final Function(String) onDetailsChanged;

  TaskTile({required this.task, required this.onDetailsChanged});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  late TextEditingController _controller;
  String _tempDetails = '';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.details);
    _tempDetails = widget.task.details;
    _isEditing = widget.task.details.isEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetDetails() {
    setState(() {
      _tempDetails = widget.task.details;
      _controller.text = widget.task.details;
      _isEditing = widget.task.details.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        title: Text(widget.task.title),
        onExpansionChanged: (expanded) {
          if (!expanded) {
            _resetDetails();
          }
        },
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEditing)
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '세부 사항을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _tempDetails = value;
                    },
                  )
                else
                  Text(widget.task.details),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isEditing) ...[
                      if (widget.task.details.isNotEmpty)
                        ElevatedButton(
                          child: Text('취소'),
                          onPressed: () {
                            _resetDetails();
                          },
                        ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text('저장'),
                        onPressed: () {
                          widget.onDetailsChanged(_tempDetails);
                          setState(() {
                            _isEditing = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('세부 사항이 저장되었습니다.')),
                          );
                        },
                      ),
                    ] else if (widget.task.details.isNotEmpty)
                      ElevatedButton(
                        child: Text('수정'),
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
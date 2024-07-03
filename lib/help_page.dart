// help_page.dart
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도움말'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('도움말 페이지 내용 1'),
            subtitle: Text('도움말 페이지 설명을 추가하세요.'),
          ),
          ListTile(
            title: Text('도움말 페이지 내용 2'),
            subtitle: Text('도움말 페이지 설명을 추가하세요.'),
          ),
          // 추가적인 도움말 항목을 필요에 따라 추가하세요.
        ],
      ),
    );
  }
}

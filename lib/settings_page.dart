// settings_page.dart
import 'package:flutter/material.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _backgroundImage;

  Future<void> _pickImage() async {
    // TODO: Implement image picking logic (from gallery or camera)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('배경 사진 설정'),
            subtitle: _backgroundImage == null
                ? Text('사진을 선택하세요')
                : Image.file(_backgroundImage!),
            onTap: () async {
              await _pickImage(); // 이미지 선택 기능 호출
              setState(() {}); // 화면 갱신
            },
          ),
          ListTile(
            title: Text('계정'),
            subtitle: Text('계정 설정을 변경합니다.'),
            onTap: () {
              // 계정 설정 페이지로 이동하는 기능 추가
            },
          ),
          ListTile(
            title: Text('알림'),
            subtitle: Text('알림 설정을 변경합니다.'),
            onTap: () {
              // 알림 설정 페이지로 이동하는 기능 추가
            },
          ),
          ListTile(
            title: Text('보안'),
            subtitle: Text('보안 설정을 변경합니다.'),
            onTap: () {
              // 보안 설정 페이지로 이동하는 기능 추가
            },
          ),
          ListTile(
            title: Text('언어'),
            subtitle: Text('언어 설정을 변경합니다.'),
            onTap: () {
              // 언어 설정 페이지로 이동하는 기능 추가
            },
          ),
        ],
      ),
    );
  }
}

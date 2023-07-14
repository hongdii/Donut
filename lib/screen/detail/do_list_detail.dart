import 'package:flutter/material.dart';
import 'package:donut/screen/todo.dart';

class DetailScreen extends StatelessWidget {
  final Todo todo;

  // 생성자로 아이템을 수신하여 필드에 저장
  const DetailScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(todo.task)), // 아이템의 title로 title 구성
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(todo.task), // 아이템의 설명으로 body 구성
      ),
    );
  }
}
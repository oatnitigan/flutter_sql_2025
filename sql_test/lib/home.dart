import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQL2025"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [Text("SQL"), Text("CRUD")],
          ),
        ),
      ),
    );
  }
}

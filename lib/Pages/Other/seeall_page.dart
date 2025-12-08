import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/widget/seeAlleventWidget.dart';

class SeeallPage extends StatefulWidget {
  const SeeallPage({super.key});

  @override
  State<SeeallPage> createState() => _SeeallPageState();
}

class _SeeallPageState extends State<SeeallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('See all Event'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Seealleventwidget();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

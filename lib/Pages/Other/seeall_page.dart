import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/widget/seeAlleventWidget.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';

class SeeallPage extends StatefulWidget {
  final List<Eventdto> data;
  const SeeallPage({super.key, required this.data});

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
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Seealleventwidget(eventData: widget.data[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/widget/seeAlleventWidget.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';

class SeeallPage extends StatefulWidget {
  final List<Eventdto> data;
  const SeeallPage({super.key, required this.data});

  @override
  State<SeeallPage> createState() => _SeeallPageState();
}

class _SeeallPageState extends State<SeeallPage> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(t.all),
        centerTitle: true,
      ),
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

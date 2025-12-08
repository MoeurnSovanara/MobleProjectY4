import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class NewdevicePage extends StatefulWidget {
  const NewdevicePage({super.key});

  @override
  State<NewdevicePage> createState() => _NewdevicePageState();
}

class _NewdevicePageState extends State<NewdevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan new device',
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        actions: [Image.asset('assets/img/other/logo3.png')],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Center(child: Image.asset('assets/img/sample/qr.png'))],
        ),
      ),
    );
  }
}

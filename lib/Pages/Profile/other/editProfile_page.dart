import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class EditprofilePage extends StatefulWidget {
  const EditprofilePage({super.key});

  @override
  State<EditprofilePage> createState() => _EditprofilePageState();
}

class _EditprofilePageState extends State<EditprofilePage> {
  final _formkey = GlobalKey<FormState>();
  List<String> gender = ['Male', 'Female', 'Other'];
  String? _selectedGender;
  DateTime? _selectDate;

  void _pickDate({bool isStartDate = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/img/sample/korean.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AdvertiseColor.textColor.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('First Name*', style: AppComponent.labelTextStyle),
                    TextFormField(),
                    SizedBox(height: 5),
                    Text('Last Name*', style: AppComponent.labelTextStyle),
                    TextFormField(),
                    SizedBox(height: 5),
                    Text('Nationality*', style: AppComponent.labelTextStyle),
                    TextFormField(),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 95,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date of Brith',
                                  style: AppComponent.labelTextStyle,
                                ),
                                Container(
                                  height: 50,
                                  child: GestureDetector(
                                    onTap: () => _pickDate(isStartDate: true),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                          text: _selectDate == null
                                              ? ''
                                              : DateFormat(
                                                  'dd/MM/yyyy',
                                                ).format(_selectDate!),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select start date';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender',
                                  style: AppComponent.labelTextStyle,
                                ),
                                DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  hint: Text(
                                    'Select Gender',
                                    style: AppComponent.hintTextStyle,
                                  ),
                                  items: gender.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a category';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'City',
                                  style: AppComponent.labelTextStyle,
                                ),
                                TextFormField(),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sangkat',
                                  style: AppComponent.labelTextStyle,
                                ),
                                TextFormField(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Phone', style: AppComponent.labelTextStyle),
                    TextFormField(),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdvertiseColor.backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: AppComponent.elevatedButtonTextStyle
                                .copyWith(color: AdvertiseColor.textColor),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              Navigator.pop(context);
                            }
                          },
                          style: AppComponent.elevatedButtonStyle,
                          child: Text(
                            'SAVE',
                            style: AppComponent.elevatedButtonTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

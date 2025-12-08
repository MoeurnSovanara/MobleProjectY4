import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Navigator/changePage.dart';

class CreateprofilePage extends StatefulWidget {
  @override
  _CreateprofilePageState createState() => _CreateprofilePageState();
}

class _CreateprofilePageState extends State<CreateprofilePage> {
  final _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedGender;

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _genderButton(String label, IconData? icon) {
    final isSelected = _selectedGender == label;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedGender = label),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10),
          backgroundColor: isSelected
              ? AdvertiseColor.primaryColor
              : AdvertiseColor.backgroundColor,
          side: BorderSide(color: AdvertiseColor.primaryColor, width: 1.5),
          foregroundColor: isSelected
              ? AdvertiseColor.backgroundColor
              : AdvertiseColor.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon), SizedBox(width: 5), Text(label)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdvertiseColor.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Welcome! Let's get to know you",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      "This short form helps us understand you better. It only takes a minute!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Full Name Section
              Text("Full name", style: AppComponent.labelTextStyle),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: TextFormField(
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    filled: true,
                    fillColor: AdvertiseColor.inputFieldColor.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: "Enter your full name",
                    hintStyle: AppComponent.hintTextStyle,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Date of Birth Section
              Text("Date of birth", style: AppComponent.labelTextStyle),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: _selectedDate == null
                            ? ''
                            : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: AdvertiseColor.inputFieldColor.withOpacity(
                          0.5,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.calendar_month,
                            color: AdvertiseColor.textColor.withOpacity(0.5),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "DD/MM/YYYY",
                        hintStyle: AppComponent.hintTextStyle,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Gender Section
              Text("Select your gender", style: AppComponent.labelTextStyle),
              SizedBox(height: 8),
              Container(
                height: 50,
                child: Row(
                  children: [
                    _genderButton("Male", Icons.male),
                    SizedBox(width: 8),
                    _genderButton("Female", Icons.female),
                    SizedBox(width: 8),
                    _genderButton("Others", Icons.person_outline),
                  ],
                ),
              ),

              Spacer(),

              // Create Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdvertiseColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Create profile",
                    style: AppComponent.elevatedButtonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Changepage()),
      );
    }
  }
}

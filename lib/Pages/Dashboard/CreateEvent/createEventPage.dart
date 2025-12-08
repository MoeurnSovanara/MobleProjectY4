import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/TicketInforWidget.dart';

class Createeventpage extends StatefulWidget {
  const Createeventpage({super.key});

  @override
  State<Createeventpage> createState() => _CreateeventpageState();
}

class _CreateeventpageState extends State<Createeventpage> {
  File? _pickedImage;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  int _currentStep = 1;
  final _formKey = GlobalKey<FormState>();
  String? _selectedEventCategory;
  final List<String> _ticketTypes = ['Business', 'Sport', 'Art', 'Game'];
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Form controllers
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _locationLinkController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _ticketTypeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _paypalAccountIdController =
      TextEditingController();
  final TextEditingController _paypalEmailController = TextEditingController();
  final TextEditingController _paypalAccountTypeController =
      TextEditingController();
  final TextEditingController _bankAccountNameController =
      TextEditingController();
  final TextEditingController _bankAccountNumberController =
      TextEditingController();

  // Color selection
  String? _selectedColor;
  final List<String> _colors = ['Blue', 'Yellow', 'Red', 'Green'];

  // Zone list
  final List<Map<String, dynamic>> _zones = [];

  // Tickets list
  final List<Map<String, dynamic>> _tickets = [];

  // Payment method
  String _paymentMethod = 'paypal'; // Default payment method

  void _pickDate({bool isStartDate = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _pickTime({bool isStartTime = true}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _addZone() {
    if (_zoneController.text.isNotEmpty &&
        _selectedEventCategory != null &&
        _selectedColor != null) {
      setState(() {
        _zones.add({
          'name': _zoneController.text,
          'type': _selectedEventCategory!,
          'color': _selectedColor!,
        });
        _zoneController.clear();
        _selectedEventCategory = null;
        _selectedColor = null;
      });
    }
  }

  void _removeZone(int index) {
    setState(() {
      _zones.removeAt(index);
    });
  }

  void _addTicket() {
    if (_ticketTypeController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      setState(() {
        _tickets.add({
          'type': _ticketTypeController.text,
          'quantity': int.tryParse(_quantityController.text) ?? 0,
          'price': double.tryParse(_priceController.text) ?? 0.0,
        });
        _ticketTypeController.clear();
        _quantityController.clear();
        _priceController.clear();
      });
    }
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_currentStep < 5) {
          _currentStep++;
        }
      });
    }
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 1) {
        _currentStep--;
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect all form data
      final eventData = {
        'title': _eventTitleController.text,
        'category': _selectedEventCategory,
        'startDate': _startDate,
        'endDate': _endDate,
        'startTime': _startTime,
        'endTime': _endTime,
        'description': _descriptionController.text,
        'image': _pickedImage?.path,
        'tickets': _tickets,
        'locationName': _locationNameController.text,
        'locationLink': _locationLinkController.text,
        'zones': _zones,
        'paymentMethod': _paymentMethod,
        'paypalAccountId': _paypalAccountIdController.text,
        'paypalEmail': _paypalEmailController.text,
        'paypalAccountType': _paypalAccountTypeController.text,
        'bankAccountName': _bankAccountNameController.text,
        'bankAccountNumber': _bankAccountNumberController.text,
      };

      print('Event Data: $eventData');

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AdvertiseColor.primaryColor,
                  size: 60,
                ),
                SizedBox(height: 20),
                Text(
                  'Success',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'KantumruyPro',
                    color: AdvertiseColor.primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'You have created an event successfully',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdvertiseColor.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Navigate back
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      case 5:
        return _buildStep5();
      default:
        return _buildStep1();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Information',
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressSteps(),
                    SizedBox(height: 20),
                    _buildCurrentStep(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 1)
                    ElevatedButton(
                      onPressed: _previousStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: AdvertiseColor.backgroundColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Previous',
                            style: AppComponent.elevatedButtonTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _currentStep == 5 ? _submitForm : _nextStep,
                    style: AppComponent.elevatedButtonStyle,
                    child: Row(
                      children: [
                        Text(
                          _currentStep == 5 ? 'Submit' : 'Next',
                          style: AppComponent.elevatedButtonTextStyle,
                        ),
                        SizedBox(width: 5),
                        Icon(
                          _currentStep == 5 ? Icons.check : Icons.arrow_forward,
                          color: AdvertiseColor.backgroundColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _paymentMethod = 'paypal';
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: AdvertiseColor.primaryColor),
                    color: _paymentMethod == 'paypal'
                        ? AdvertiseColor.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: _paymentMethod == 'paypal'
                            ? AdvertiseColor.backgroundColor
                            : AdvertiseColor.textColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'PayPal',
                        style: AppComponent.elevatedButtonTextStyle.copyWith(
                          color: _paymentMethod == 'paypal'
                              ? AdvertiseColor.backgroundColor
                              : AdvertiseColor.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _paymentMethod = 'QR_Code';
                  });
                },
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AdvertiseColor.primaryColor),
                    color: _paymentMethod == 'QR_Code'
                        ? AdvertiseColor.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.qr_code,
                        color: _paymentMethod == 'QR_Code'
                            ? AdvertiseColor.backgroundColor
                            : AdvertiseColor.textColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Qr Code',
                        style: AppComponent.elevatedButtonTextStyle.copyWith(
                          color: _paymentMethod == 'QR_Code'
                              ? AdvertiseColor.backgroundColor
                              : AdvertiseColor.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(10),
          child: Divider(color: AdvertiseColor.textColor),
        ),
        if (_paymentMethod == 'paypal')
          _buildPaypalForm()
        else
          _buildCreditCardForm(),
      ],
    );
  }

  Widget _buildPaypalForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Paypal Account ID', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _paypalAccountIdController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter PayPal Account ID';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter Paypal Account ID',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Email', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _paypalEmailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email address';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter email address',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Account Type', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _paypalAccountTypeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account type';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter account type',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Image.asset(
              'assets/img/other/credit.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account Name', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _bankAccountNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account name';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter account name',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Account Number', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _bankAccountNumberController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account number';
              }
              if (value.length < 10) {
                return 'Account number must be at least 10 digits';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter account number',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Image.asset(
              'assets/img/other/credit.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location Name', style: AppComponent.labelTextStyle),
          SizedBox(height: 5),
          TextFormField(
            controller: _locationNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter location name';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter location name',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Location Link', style: AppComponent.labelTextStyle),
          SizedBox(height: 5),
          TextFormField(
            controller: _locationLinkController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Enter location link',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Zone', style: AppComponent.labelTextStyle),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _zoneController,
                        decoration: InputDecoration(
                          hintText: 'Enter zone name',
                          hintStyle: AppComponent.hintTextStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
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
                        'Choose Ticket type',
                        style: AppComponent.labelTextStyle,
                      ),
                      SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: _selectedEventCategory,
                        hint: Text(
                          'Pick Ticket Type',
                          style: AppComponent.hintTextStyle,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: AdvertiseColor.backgroundColor,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                        ),
                        items: _ticketTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedEventCategory = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choose Color', style: AppComponent.labelTextStyle),
                      SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: _selectedColor,
                        hint: Text(
                          'Pick Color',
                          style: AppComponent.hintTextStyle,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: AdvertiseColor.backgroundColor,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                        ),
                        items: _colors.map((String value) {
                          Color color;
                          switch (value) {
                            case 'Blue':
                              color = Colors.blue;
                              break;
                            case 'Yellow':
                              color = Colors.yellow;
                              break;
                            case 'Red':
                              color = Colors.red;
                              break;
                            case 'Green':
                              color = Colors.green;
                              break;
                            default:
                              color = Colors.blue;
                          }
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: color,
                                  margin: EdgeInsets.only(right: 10),
                                ),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedColor = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _addZone,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AdvertiseColor.primaryColor,
              ),
              width: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Add Zone', style: AppComponent.elevatedButtonTextStyle),
                  Icon(Icons.add, color: AdvertiseColor.backgroundColor),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Added Zones', style: AppComponent.labelTextStyle),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(6),
            color: Colors.blue,
            strokeWidth: 2,
            dashPattern: [6, 3],
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_zones.isEmpty)
                    Center(
                      child: Text(
                        'No zones added yet',
                        style: AppComponent.hintTextStyle,
                      ),
                    ),
                  ..._zones.asMap().entries.map((entry) {
                    final index = entry.key;
                    final zone = entry.value;
                    Color borderColor;
                    Color bgColor;
                    switch (zone['color']) {
                      case 'Blue':
                        borderColor = Colors.blue;
                        bgColor = Colors.blue.withOpacity(0.5);
                        break;
                      case 'Yellow':
                        borderColor = Colors.yellow;
                        bgColor = Colors.yellow.withOpacity(0.5);
                        break;
                      case 'Red':
                        borderColor = Colors.red;
                        bgColor = Colors.red.withOpacity(0.5);
                        break;
                      case 'Green':
                        borderColor = Colors.green;
                        bgColor = Colors.green.withOpacity(0.5);
                        break;
                      default:
                        borderColor = Colors.blue;
                        bgColor = Colors.blue.withOpacity(0.5);
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(8),
                        color: bgColor,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () => _removeZone(index),
                              icon: Icon(Icons.cancel_outlined),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  zone['name'],
                                  style: AppComponent.boldTextStyle,
                                ),
                              ),
                              Center(
                                child: Text(
                                  zone['type'],
                                  style: AppComponent.labelTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ticket Type', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _ticketTypeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ticket type';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter your ticket type',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Quantity', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter quantity';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter quantity',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Price', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid price';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter price',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _addTicket,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: 140,
              decoration: BoxDecoration(
                border: Border.all(color: AdvertiseColor.primaryColor),
                borderRadius: BorderRadius.circular(10),
                color: AdvertiseColor.primaryColor,
              ),
              child: Row(
                children: [
                  Text(
                    'Add Ticket',
                    style: TextStyle(
                      color: AdvertiseColor.backgroundColor,
                      fontFamily: 'KantumRuyPro',
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.add, color: AdvertiseColor.backgroundColor),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 3 * 90,
            child: ListView.builder(
              itemCount: _tickets.length,
              itemBuilder: (BuildContext context, int index) {
                return TicketInfo_widget(
                  image: 'assets/img/sample/event.png',
                  status: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Image', style: AppComponent.labelTextStyle),
          SizedBox(height: 20),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(6),
            color: Colors.blue,
            strokeWidth: 2,
            dashPattern: [6, 3],
            child: Container(
              width: double.infinity,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  if (_pickedImage != null)
                    Image.file(
                      _pickedImage!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    )
                  else
                    Icon(
                      Icons.folder_copy,
                      color: AdvertiseColor.blueColor,
                      size: 40,
                    ),
                  SizedBox(height: 5),
                  Text('upload your event image here'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: AdvertiseColor.primaryColor),
                    ),
                    child: Text(
                      'Browse Image',
                      style: AppComponent.elevatedButtonTextStyle.copyWith(
                        color: AdvertiseColor.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Description', style: AppComponent.labelTextStyle),
          TextFormField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter your description',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Event Title', style: AppComponent.labelTextStyle),
          SizedBox(height: 5),
          TextFormField(
            controller: _eventTitleController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter event title';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter event title',
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Category', style: AppComponent.labelTextStyle),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: _selectedEventCategory,
            hint: Text(
              'Select Event Category',
              style: AppComponent.hintTextStyle,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AdvertiseColor.backgroundColor,
            ),
            items: _ticketTypes.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedEventCategory = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start date', style: AppComponent.labelTextStyle),
                      Container(
                        height: 50,
                        child: GestureDetector(
                          onTap: () => _pickDate(isStartDate: true),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _startDate == null
                                    ? ''
                                    : DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_startDate!),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select start date';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                filled: true,
                                fillColor: AdvertiseColor.inputFieldColor
                                    .withOpacity(0.5),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: AdvertiseColor.textColor.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Pick start date",
                                hintStyle: AppComponent.hintTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End date', style: AppComponent.labelTextStyle),
                      Container(
                        height: 50,
                        child: GestureDetector(
                          onTap: () => _pickDate(isStartDate: false),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _endDate == null
                                    ? ''
                                    : DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_endDate!),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select end date';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                filled: true,
                                fillColor: AdvertiseColor.inputFieldColor
                                    .withOpacity(0.5),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: AdvertiseColor.textColor.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Pick end date",
                                hintStyle: AppComponent.hintTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start time', style: AppComponent.labelTextStyle),
                      Container(
                        height: 50,
                        child: GestureDetector(
                          onTap: () => _pickTime(isStartTime: true),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _startTime == null
                                    ? ''
                                    : _startTime!.format(context),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select start time';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                filled: true,
                                fillColor: AdvertiseColor.inputFieldColor
                                    .withOpacity(0.5),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.timer_outlined,
                                    color: AdvertiseColor.textColor.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Pick start time",
                                hintStyle: AppComponent.hintTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End time', style: AppComponent.labelTextStyle),
                      Container(
                        height: 50,
                        child: GestureDetector(
                          onTap: () => _pickTime(isStartTime: false),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _endTime == null
                                    ? ''
                                    : _endTime!.format(context),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select end time';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                filled: true,
                                fillColor: AdvertiseColor.inputFieldColor
                                    .withOpacity(0.5),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.timer_outlined,
                                    color: AdvertiseColor.textColor.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Pick end time",
                                hintStyle: AppComponent.hintTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(String number, bool isActive) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? AdvertiseColor.primaryColor : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSteps() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStepCircle('1', _currentStep >= 1),
          Expanded(
            child: Divider(
              thickness: 2,
              color: _currentStep >= 2
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle('2', _currentStep >= 2),
          Expanded(
            child: Divider(
              thickness: 2,
              color: _currentStep >= 3
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle('3', _currentStep >= 3),
          Expanded(
            child: Divider(
              thickness: 2,
              color: _currentStep >= 4
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle('4', _currentStep >= 4),
          Expanded(
            child: Divider(
              thickness: 2,
              color: _currentStep >= 5
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle('5', _currentStep >= 5),
        ],
      ),
    );
  }
}

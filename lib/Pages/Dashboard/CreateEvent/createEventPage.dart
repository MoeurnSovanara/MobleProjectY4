import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/TicketInforWidget.dart';
import 'package:mobile_assignment/Models/DTO/CategoryDto.dart';
import 'package:mobile_assignment/Models/DTO/CreateEventDto.dart';
import 'package:mobile_assignment/Models/DTO/PaymentDto.dart';
import 'package:mobile_assignment/Models/DTO/TicketTypeDto.dart';
import 'package:mobile_assignment/Models/DTO/VenuesNameDto.dart';
import 'package:mobile_assignment/services/API/CategoryApi.dart';
import 'package:mobile_assignment/services/API/EventApi.dart';
import 'package:mobile_assignment/services/API/PaymentApi.dart';
import 'package:mobile_assignment/services/API/TicketTypApi.dart';
import 'package:mobile_assignment/services/API/VenuesApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:uuid/uuid.dart';

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
  int? _selectedEventCategory;
  List<Categorydto> _ticketTypes = [];
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Categoryapi categoryapi = Categoryapi();

  // Form controllers
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _locationLinkController = TextEditingController();
  final TextEditingController _locationInfoController = TextEditingController();
  final TextEditingController _ticketTypeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _paypalAccountIdController =
      TextEditingController();
  final TextEditingController _paypalSecretKeyController =
      TextEditingController();
  final TextEditingController _paypalCurrencyCodeController =
      TextEditingController();
  final TextEditingController _bankAccountNameController =
      TextEditingController();
  final TextEditingController _bankAccountNumberController =
      TextEditingController();
  Paymentapi paymentapi = Paymentapi();
  Eventapi eventapi = Eventapi();
  Venuesapi venuesapi = Venuesapi();
  TickettypeApi tickettypeApi = TickettypeApi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  var uuid = Uuid();

  // Zone list
  final List<Map<String, dynamic>> _zones = [];

  // Tickets list
  final List<TicketTypeDto> _tickets = [];

  // Payment method
  String _paymentMethod = 'paypal'; // Default payment method

  Future<void> firstTask() async {
    var categoryData = await categoryapi.getAllCategoryName();
    if (categoryData != null) {
      setState(() {
        _ticketTypes = categoryData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    firstTask();
  }

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

  Duration? _timeOfDayToDuration(TimeOfDay? time) {
    if (time == null) return null;
    return Duration(hours: time.hour, minutes: time.minute);
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

  void _addTicket() {
    if (_ticketTypeController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      setState(() {
        _tickets.add(
          TicketTypeDto(
            id: 0,
            eventId: 0,
            typeName: _ticketTypeController.text,
            price: double.parse(_priceController.text),
            quantityAvailable: int.parse(_quantityController.text),
            totalTickets: int.parse(_quantityController.text),
          ),
        );
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

  Future<void> _submitForm() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      _showErrorDialog('Please fill in all required fields');
      return;
    }

    // Validate tickets
    if (_tickets.isEmpty) {
      _showErrorDialog('Please add at least one ticket type');
      return;
    }

    // Validate dates
    if (_startDate == null || _endDate == null) {
      _showErrorDialog('Please select event start and end dates');
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _showErrorDialog('End date must be after start date');
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Get user ID
      final uId = await usersharedpreferences.getUserId();
      if (uId == null) {
        Navigator.pop(context); // Close loading dialog
        _showErrorDialog('User not logged in');
        return;
      }

      // Create venue
      final venue = await venuesapi.CreateVenues(
        venue: Venuesnamedto(
          id: 0,
          venueInfo: _locationInfoController.text,
          venueLocation: _locationLinkController.text,
          venueName: _locationNameController.text,
        ),
      );

      if (venue == null) {
        Navigator.pop(context); // Close loading dialog
        _showErrorDialog('Failed to create venue');
        return;
      }

      // Upload image
      String? uniqueImagename;
      if (_pickedImage != null) {
        uniqueImagename = 'event_${uuid.v4()}.png';
        await eventapi.uploadEventImage(
          image: _pickedImage,
          imageName: uniqueImagename,
        );
      } else {
        Navigator.pop(context); // Close loading dialog
        _showErrorDialog('Please select an event image');
        return;
      }

      // Create event
      final event = await eventapi.CreateEvent(
        event: Createeventdto(
          id: 0,
          categoryId: _selectedEventCategory!,
          userId: uId,
          venuesId: venue.id,
          title: _eventTitleController.text,
          image: uniqueImagename,
          description: _descriptionController.text,
          capacityTicketd: _calculateTotalTickets(),
          eventStart: _combineDateTime(_startDate!, _startTime!),
          eventEnd: _combineDateTime(_endDate!, _endTime!),
          startTime: _timeOfDayToDuration(_startTime)!,
          endTime: _timeOfDayToDuration(_endTime)!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      if (event == null) {
        Navigator.pop(context); // Close loading dialog
        _showErrorDialog('Failed to create event');
        return;
      }

      // Create ticket types
      final ticketTypes = _tickets
          .map(
            (ticket) => TicketTypeDto(
              id: 0,
              eventId: event.id,
              typeName: ticket.typeName,
              price: ticket.price,
              quantityAvailable: ticket.quantityAvailable,
              totalTickets: ticket.totalTickets,
            ),
          )
          .toList();

      final createdTickets = await tickettypeApi.createTicketType(
        ticketTypes: ticketTypes,
      );

      if (createdTickets == null || createdTickets.isEmpty) {
        // Consider rolling back event creation or handling partial failure
        Navigator.pop(context); // Close loading dialog
        _showErrorDialog('Event created but failed to create ticket types');
        return;
      }

      // Create payment
      final paymentResponse = await paymentapi.CreatePayment(
        payment: Paymentdto(
          paymentId: 0,
          userId: uId,
          clientId: _paypalAccountIdController.text,
          secretKey: _paypalSecretKeyController.text,
          currencyCode: _paypalCurrencyCodeController.text,
        ),
      );

      Navigator.pop(context); // Close loading dialog

      if (paymentResponse.statusCode < 300) {
        _showSuccessDialog();
      } else {
        _showErrorDialog('Event created but payment setup failed');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('An error occurred: ${e.toString()}');
    }
  }

  // Helper methods
  int _calculateTotalTickets() {
    return _tickets.fold(0, (sum, ticket) => sum + ticket.totalTickets);
  }

  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: AdvertiseColor.primaryColor,
                size: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Success',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KantumruyPro',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You have created an event successfully',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdvertiseColor.primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Navigate back
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Remove the payment method toggle, just show PayPal directly
        Text(
          'Payment Information',
          style: AppComponent.labelTextStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        _buildPaypalForm(),
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
          Text('Secret Key', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _paypalSecretKeyController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter your Secret Key';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter Secret Key',
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
          Text('Currency Code', style: AppComponent.labelTextStyle),
          SizedBox(height: 10),
          TextFormField(
            controller: _paypalCurrencyCodeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter currency code';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter currency code',
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
          Text('Location', style: AppComponent.labelTextStyle),
          SizedBox(height: 5),
          TextFormField(
            controller: _locationInfoController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter location';
              }
              return null;
            },
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Enter location',
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter location link';
              }
              return null;
            },
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
              width: 150,
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
                  image: 'assets/img/other/ticket.png',
                  status: true,
                  ticketTypeDto: TicketTypeDto(
                    id: 0,
                    eventId: 0,
                    typeName: _tickets[index].typeName,
                    price: _tickets[index].price,
                    quantityAvailable: _tickets[index].quantityAvailable,
                    totalTickets: _tickets[index].totalTickets,
                  ),
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
          DropdownButtonFormField<int>(
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
            items: _ticketTypes.map((Categorydto value) {
              return DropdownMenuItem<int>(
                value: value.id, // Use the ID as the value
                child: Text(value.categoryName),
              );
            }).toList(),
            onChanged: (int? newValue) {
              // Change to int?
              setState(() {
                _selectedEventCategory = newValue; // Now stores the ID
              });
            },
            validator: (value) {
              if (value == null) {
                // Remove .isEmpty check
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

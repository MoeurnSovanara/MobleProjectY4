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
import 'package:mobile_assignment/Models/DTO/UserDto.dart';
import 'package:mobile_assignment/Models/DTO/VenuesNameDto.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/services/API/CategoryApi.dart';
import 'package:mobile_assignment/services/API/EventApi.dart';
import 'package:mobile_assignment/services/API/PaymentApi.dart';
import 'package:mobile_assignment/services/API/TicketTypApi.dart';
import 'package:mobile_assignment/services/API/UserApi.dart';
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
  Paymentapi paymentapi = Paymentapi();
  Eventapi eventapi = Eventapi();
  Venuesapi venuesapi = Venuesapi();
  TickettypeApi tickettypeApi = TickettypeApi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  Userapi userapi = Userapi();
  var uuid = Uuid();

  // Tickets list
  final List<TicketTypeDto> _tickets = [];

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
    final t = AppLocalizations.of(context)!;

    // Validate form first
    if (!_formKey.currentState!.validate()) {
      _showErrorDialog(t.errorFillAllFields);
      return;
    }

    // Validate tickets
    if (_tickets.isEmpty) {
      _showErrorDialog(t.errorAddTicket);
      return;
    }

    // Validate dates
    if (_startDate == null || _endDate == null) {
      _showErrorDialog(t.errorSelectDates);
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _showErrorDialog(t.errorEndDateAfterStart);
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
        _showErrorDialog(t.errorUserNotLoggedIn);
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
        _showErrorDialog(t.errorCreateVenue);
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
        _showErrorDialog(t.errorSelectImage);
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
        _showErrorDialog(t.errorCreateEvent);
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
        _showErrorDialog(t.errorCreateTickets);
        return;
      }

      // Create payment
      final paymentResponse = await paymentapi.createPayment(
        payment: Paymentdto(
          paymentId: 0,
          userId: uId,
          clientId: _paypalAccountIdController.text,
          secretKey: _paypalSecretKeyController.text,
          currencyCode: _paypalCurrencyCodeController.text,
        ),
      );

      var isOrgainizer = await usersharedpreferences.getUserOrganizer();
      if (isOrgainizer == false) {
        var userEmail = await usersharedpreferences.getUserEmail();

        var existUserData = await userapi.getUserByEmail(email: userEmail!);
        if (existUserData != null) {
          var newUserdata = new Userdto(
            id: existUserData.id,
            fullname: existUserData.fullname,
            email: existUserData.email,
            gender: existUserData.gender,
            password: existUserData.password,
            phoneNumber: existUserData.phoneNumber,
            dateOfBirth: existUserData.dateOfBirth,
            organizer: !existUserData.organizer,
            verified: existUserData.verified,
            createdAt: existUserData.createdAt,
            google: existUserData.google,
          );
          var updateUser = await userapi.updateUser(user: newUserdata);
          if (updateUser != null) {
            await usersharedpreferences.saveUserOrganizer(updateUser.organizer);
          }
        }
      }

      Navigator.pop(context); // Close loading dialog

      if (paymentResponse.statusCode < 300) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(t.errorPaymentSetup);
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('${t.errorOccurred} ${e.toString()}');
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
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            t.error,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.ok),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    final t = AppLocalizations.of(context)!;
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
              Text(
                t.success,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KantumruyPro',
                ),
              ),
              const SizedBox(height: 10),
              Text(t.eventCreatedSuccess, textAlign: TextAlign.center),
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
                child: Text(t.ok),
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
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.eventInformation,
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
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
                    const SizedBox(height: 20),
                    _buildCurrentStep(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                          const SizedBox(width: 5),
                          Text(
                            t.previous,
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
                          _currentStep == 5 ? t.submit : t.next,
                          style: AppComponent.elevatedButtonTextStyle,
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          _currentStep == 5 ? Icons.check : Icons.arrow_forward,
                          color: AdvertiseColor.backgroundColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep5() {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Remove the payment method toggle, just show PayPal directly
        Text(
          t.paymentInformation,
          style: AppComponent.labelTextStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildPaypalForm(),
      ],
    );
  }

  Widget _buildPaypalForm() {
    final t = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.paypalAccountId, style: AppComponent.labelTextStyle),
          const SizedBox(height: 10),
          TextFormField(
            controller: _paypalAccountIdController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.validatePaypalAccount;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: t.enterPaypalAccountHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(t.secretKey, style: AppComponent.labelTextStyle),
          const SizedBox(height: 10),
          TextFormField(
            controller: _paypalSecretKeyController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.validateSecretKey;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: t.enterSecretKeyHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(t.currencyCode, style: AppComponent.labelTextStyle),
          const SizedBox(height: 10),
          TextFormField(
            controller: _paypalCurrencyCodeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.validateCurrencyCode;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: t.enterCurrencyCodeHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
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
    final t = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.locationName, style: AppComponent.labelTextStyle),
          const SizedBox(height: 5),
          TextFormField(
            controller: _locationNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.validateLocationName;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: t.enterLocationNameHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(t.location, style: AppComponent.labelTextStyle),
          const SizedBox(height: 5),
          TextFormField(
            controller: _locationInfoController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.validateLocation;
              }
              return null;
            },
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: t.enterLocationHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(t.locationLink, style: AppComponent.labelTextStyle),
          const SizedBox(height: 5),
          TextFormField(
            controller: _locationLinkController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.validateLocationLink;
              }
              return null;
            },
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: t.enterLocationLinkHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
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
    final t = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.ticketType, style: AppComponent.labelTextStyle),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ticketTypeController,
            decoration: InputDecoration(
              hintText: t.enterTicketTypeHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(t.quantity, style: AppComponent.labelTextStyle),
          const SizedBox(height: 10),
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: t.enterQuantityHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(t.price, style: AppComponent.labelTextStyle),
          const SizedBox(height: 10),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: t.enterPriceHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _addTicket,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: AdvertiseColor.primaryColor),
                borderRadius: BorderRadius.circular(10),
                color: AdvertiseColor.primaryColor,
              ),
              child: Row(
                children: [
                  Text(
                    t.addTicket,
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
          const SizedBox(height: 10),
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
    final t = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.uploadImage, style: AppComponent.labelTextStyle),
          const SizedBox(height: 20),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            padding: const EdgeInsets.all(6),
            color: Colors.blue,
            strokeWidth: 2,
            dashPattern: const [6, 3],
            child: Container(
              width: double.infinity,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 5),
                  Text(t.uploadImageHint),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: AdvertiseColor.primaryColor),
                    ),
                    child: Text(
                      t.browseImage,
                      style: AppComponent.elevatedButtonTextStyle.copyWith(
                        color: AdvertiseColor.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(t.description, style: AppComponent.labelTextStyle),
          TextFormField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.validateDescription;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: t.enterDescriptionHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
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
    final t = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.eventTitle, style: AppComponent.labelTextStyle),
          const SizedBox(height: 5),
          TextFormField(
            controller: _eventTitleController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.validateEventTitle;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: t.enterEventTitleHint,
              hintStyle: AppComponent.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(t.category, style: AppComponent.labelTextStyle),
          const SizedBox(height: 5),
          DropdownButtonFormField<int>(
            value: _selectedEventCategory,
            hint: Text(t.selectCategoryHint, style: AppComponent.hintTextStyle),
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
                return t.validateCategory;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.startDate, style: AppComponent.labelTextStyle),
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
                                  return t.validateStartDate;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
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
                                hintText: t.pickStartDateHint,
                                hintStyle: AppComponent.hintTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.endDate, style: AppComponent.labelTextStyle),
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
                                  return t.validateEndDate;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
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
                                hintText: t.pickEndDateHint,
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
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.startTime, style: AppComponent.labelTextStyle),
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
                                  return t.validateStartTime;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
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
                                hintText: t.pickStartTimeHint,
                                hintStyle: AppComponent.hintTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.endTime, style: AppComponent.labelTextStyle),
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
                                  return t.validateEndTime;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
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
                                hintText: t.pickEndTimeHint,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

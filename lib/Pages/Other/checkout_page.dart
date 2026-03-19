import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/CreateTicketDto.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/services/API/PaymentApi.dart';
import 'package:mobile_assignment/services/API/TicketApi.dart';
import 'package:mobile_assignment/services/API/TicketTypApi.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/TimeHelperClass.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:uuid/uuid.dart';

class CheckoutPage extends StatefulWidget {
  final Eventdto eventdto;
  const CheckoutPage({super.key, required this.eventdto});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();

  String? _selectedTicketType;
  List<String> _ticketTypes = [];
  Ticketapi ticketapi = Ticketapi();
  TickettypeApi tickettypeApi = TickettypeApi();
  Paymentapi paymentapi = Paymentapi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();

  int _quantity = 1;
  int _currentStep = 1; // 1: Ticket Details, 2: Payment, 3: Success
  double _ticketPrice = 0.00;
  final timeHelper = Timehelperclass();
  Uuid uuid = Uuid();

  void fristJob() {
    setState(() {
      _ticketTypes = widget.eventdto.ticketTypes
          .map((e) => e.typeName)
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fristJob();
    _quantityController.text = _quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _expirationController.dispose();
    _securityCodeController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _quantityController.text = _quantity.toString();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = _quantity.toString();
      });
    }
  }

  void _payPalPayment() async {
    var payment = await paymentapi.getPayment(userId: widget.eventdto.userId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: payment!.clientId,
          secretKey: payment.secretKey,
          transactions: [
            {
              "amount": {
                "total": '${_quantity * _ticketPrice}',
                "currency": payment.currencyCode,
              },
              "description": "The payment transaction description.",
              "item_list": {
                "items": [
                  {
                    "name": widget.eventdto.title,
                    "quantity": _quantity,
                    "price": _ticketPrice,
                    "currency": payment.currencyCode,
                  },
                ],
              },
            },
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            // Process payment first
            _processPayment();

            // Then pop the PayPal view
            if (mounted) {
              Navigator.pop(context);
            }
          },
          onError: (error) {
            print("onError: $error");
            if (mounted) {
              Navigator.pop(context);
            }
          },
          onCancel: () {
            print('cancelled:');
            if (mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _processPayment() async {
    var userId = await usersharedpreferences.getUserId();
    String uniqueKey = "ticket_${uuid.v4()}";
    final t = AppLocalizations.of(context)!;
    if (userId == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: AppComponent.boldTextStyle.copyWith(
                color: AdvertiseColor.dangerColor,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            content: Text(
              "Failed to Process payment! User not logged in.",
              style: AppComponent.labelStyle,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Validate that a ticket type is selected
    if (_selectedTicketType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.select_ticket_type)));
      return;
    }

    final selectedTicket = widget.eventdto.ticketTypes.firstWhere(
      (e) => e.typeName == _selectedTicketType,
    );
    int ticketTypeId = selectedTicket.id;

    // Show loading dialog
    if (!mounted) return;

    BuildContext? dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AdvertiseColor.primaryColor),
                SizedBox(height: 20),
                Text(
                  'Processing Payment...',
                  style: AppComponent.labelTextStyle,
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      Createticketdto newTicket = Createticketdto(
        id: 0,
        eventId: widget.eventdto.id,
        userId: userId,
        ticketTypeId: ticketTypeId,
        uniqueTicketCode: uniqueKey,
        quantity: _quantity,
        price: _ticketPrice,
        status: 'active',
      );

      var response = await ticketapi.CreateAllTicket(createTicket: newTicket);
      var response2 = await tickettypeApi.updateTicketType(
        ticketTypeId: ticketTypeId,
        quantity: _quantity,
      );

      // Close loading dialog
      if (mounted && dialogContext != null) {
        Navigator.pop(dialogContext!);
      }

      if (response.statusCode >= 200 && response.statusCode <= 299 ||
          response2.statusCode >= 200 && response2.statusCode <= 299) {
        // Update the UI
        if (mounted) {
          setState(() {
            _currentStep = 3;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Payment successful! Your tickets have been booked.',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted && dialogContext != null) {
        Navigator.pop(dialogContext!);
      }

      if (mounted) {
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  // Helper method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Payment Failed',
            style: AppComponent.boldTextStyle.copyWith(
              color: AdvertiseColor.dangerColor,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          content: Text(message, style: AppComponent.labelStyle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      if (_currentStep == 1) {
        // Validate ticket selection
        if (_selectedTicketType == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a ticket type')),
          );
          return;
        }
        if (!_formKey.currentState!.validate()) {
          return;
        }

        // Move to step 2 only after validation passes
        setState(() {
          _currentStep++;
        });
      } else if (_currentStep == 2) {
        // Don't increment step here, let the payment callback handle it
        _payPalPayment();
      }
    } else {
      // Payment complete - navigate back or show success
      Navigator.pop(context);
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.checkout, style: AppComponent.labelStyle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Details
              Image.network(
                "${headUrl}lib/img/Event/${widget.eventdto.image}",
                fit: BoxFit.fitWidth,
                height: 180,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/img/other/errorImage.png',
                  fit: BoxFit.fitHeight,
                  height: 180,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.eventdto.title,
                style: AppComponent.labelStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildDateInfo(
                    Icons.calendar_month_outlined,
                    t.startDate,
                    Helperclass.formatFullDate(widget.eventdto.eventStart),
                  ),
                  Spacer(),
                  _buildDateInfo(
                    Icons.calendar_month_outlined,
                    t.endDate,
                    Helperclass.formatFullDate(widget.eventdto.eventEnd),
                  ),
                  Spacer(),
                  _buildDateInfo(
                    Icons.timer_outlined,
                    t.time,
                    '${timeHelper.formatTimeAMPM(widget.eventdto.startTime)} - ${timeHelper.formatTime(widget.eventdto.endTime)}',
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(thickness: 1, color: AdvertiseColor.textColor),
              SizedBox(height: 16),

              // Total Payment
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.total,
                        style: AppComponent.boldTextStyle.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        t.paymentText,
                        style: TextStyle(
                          color: AdvertiseColor.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '\$${(_quantity * _ticketPrice).toStringAsFixed(1)}',
                    style: AppComponent.primaryThemeTextStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Progress Steps
              _buildProgressSteps(),
              SizedBox(height: 24),

              // Content based on current step
              if (_currentStep == 1) _buildStep1(),
              if (_currentStep == 2) _buildStep2(),
              if (_currentStep == 3) _buildStep3(),

              SizedBox(height: 24),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 1)
                    TextButton(
                      onPressed: _previousStep,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_left,
                            color: AdvertiseColor.primaryColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            t.backLabel,
                            style: TextStyle(
                              color: AdvertiseColor.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: AppComponent.elevatedButtonStyle,
                    child: Row(
                      children: [
                        Text(
                          _currentStep == 3 ? t.finishLabel : t.nextLabel,
                          style: AppComponent.elevatedButtonTextStyle,
                        ),
                        if (_currentStep < 3)
                          Icon(
                            Icons.arrow_right_alt,
                            color: AdvertiseColor.backgroundColor,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(IconData icon, String title, String value) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 5),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppComponent.labelTextStyle.copyWith(
                fontSize: screenWidth <= 375 ? 10 : 12,
              ),
            ),
            Text(
              value,
              style: AppComponent.labelTextStyle.copyWith(
                fontSize: screenWidth <= 375 ? 10 : 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSteps() {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStepCircle('1', _currentStep >= 1, t.lTickets),
          Expanded(
            child: Divider(
              thickness: 2,
              color: _currentStep >= 2
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle('2', _currentStep >= 2, t.lPayment),
          Expanded(
            child: Divider(
              thickness: 2,
              color: _currentStep >= 3
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle('3', _currentStep >= 3, t.lSuccess),
        ],
      ),
    );
  }

  Widget _buildStepCircle(String number, bool isActive, String label) {
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
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? AdvertiseColor.primaryColor
                : Colors.grey.shade500,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    final t = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ticket Quantity
          Text(t.ticketQuantity, style: AppComponent.labelTextStyle),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: t.ticketQuantity,
                      hintStyle: AppComponent.hintTextStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && int.tryParse(value) != null) {
                        setState(() {
                          _quantity = int.parse(value);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return t.enter_ticket_quantity;
                      }
                      if (int.tryParse(value) == null) {
                        return t.enter_valid_number;
                      }
                      if (int.parse(value) < 1) {
                        return t.quantity_min_one;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: IconButton(
                    onPressed: _decrementQuantity,
                    icon: Icon(Icons.remove, color: AdvertiseColor.textColor),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: IconButton(
                    onPressed: _incrementQuantity,
                    icon: Icon(Icons.add, color: AdvertiseColor.textColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Ticket Type
          Text(t.ticketType, style: AppComponent.labelTextStyle),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedTicketType,
            hint: Text(
              t.select_ticket_type_label,
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
                _selectedTicketType = newValue;
                if (newValue != null) {
                  final selectedTicket = widget.eventdto.ticketTypes.firstWhere(
                    (e) => e.typeName.contains(newValue),
                  );
                  _ticketPrice = selectedTicket.price;
                } else {
                  _ticketPrice = 0.00;
                }
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.select_ticket_type;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Summary
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                t.orderSummary,
                style: AppComponent.boldTextStyle.copyWith(fontSize: 18),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.oEvent, style: TextStyle(color: Colors.grey.shade600)),
                  Flexible(
                    child: Text(
                      widget.eventdto.title,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.oTicketType,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Text(
                    _selectedTicketType ?? 'Not selected',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.oQuantity,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Text(
                    '$_quantity',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.oPricePerTicket,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Text(
                    '\$'
                    "${_ticketPrice.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Divider(thickness: 1, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.oTotal,
                    style: AppComponent.boldTextStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    '\$${(_quantity * _ticketPrice).toStringAsFixed(2)}',
                    style: AppComponent.primaryThemeTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final t = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        Icon(Icons.check_circle, color: Colors.green, size: 100),
        SizedBox(height: 24),
        Text(
          t.payment_successful,
          style: AppComponent.boldTextStyle.copyWith(fontSize: 24),
        ),
        SizedBox(height: 16),
        Text(
          t.stext1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AdvertiseColor.textColor.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8),
        Text(
          '${t.sBookId} #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 32),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AdvertiseColor.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(t.stext2, textAlign: TextAlign.center),
              SizedBox(height: 8),
              Text(
                t.stext3,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

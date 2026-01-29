import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

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
  final List<String> _ticketTypes = [
    'VIP Ticket',
    'Premium Ticket',
    'Standard Ticket',
    'General Ticket',
  ];

  int _selectedPaymentMethod = 0; // 0 for Card, 1 for QR
  int _quantity = 1;
  int _currentStep = 1; // 1: Ticket Details, 2: Payment, 3: Success

  @override
  void initState() {
    super.initState();
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
      }

      if (_currentStep == 2) {
        // Validate payment for card payment
        if (_selectedPaymentMethod == 0 && !_formKey.currentState!.validate()) {
          return;
        }
        // Show processing dialog
        _showProcessingDialog();
        return;
      }

      setState(() {
        _currentStep++;
      });
    } else {
      // Payment complete - navigate back or show success
      Navigator.pop(context);
    }
  }

  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AdvertiseColor.primaryColor),
              SizedBox(height: 20),
              Text('Processing Payment...', style: AppComponent.labelTextStyle),
            ],
          ),
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close processing dialog
      setState(() {
        _currentStep++;
      });
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: AppComponent.labelStyle),
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
              Image.asset(
                'assets/img/sample/event.png',
                fit: BoxFit.fitWidth,
                height: 180,
                width: double.infinity,
              ),
              SizedBox(height: 16),
              Text(
                'Traditional Dance Show The Abduction of Sota',
                style: AppComponent.labelStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildDateInfo(
                    Image.asset('assets/img/Icon/calendar.png', width: 24, height: 24),
                    'Start Date',
                    '16-Dec-2025',
                  ),
                  Spacer(),
                  _buildDateInfo(
                    Image.asset('assets/img/Icon/calendar.png', width: 24, height: 24),
                    'End Date',
                    '23-Mar-2025',
                  ),
                  Spacer(),
                  _buildDateInfo(
                    Image.asset('assets/img/Icon/clock.png', width: 24, height: 24),
                    'Time',
                    '11:00 AM - 2:50 PM',
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
                        'Total Payment',
                        style: AppComponent.boldTextStyle.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Please check the price before going!!',
                        style: TextStyle(
                          color: AdvertiseColor.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '\$${(_quantity * 284.2).toStringAsFixed(1)}',
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
                            'Back',
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
                          _currentStep == 3 ? 'Finish' : 'Next',
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

  Widget _buildDateInfo(Widget icon, String title, String value) {
    return Row(
      children: [
        icon,
        SizedBox(width: 5),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppComponent.labelTextStyle.copyWith(fontSize: 12),
            ),
            Text(
              value,
              style: AppComponent.labelTextStyle.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSteps() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStepCircle('1', _currentStep >= 1, 'Tickets'),
          Expanded(
            child: Divider(
              thickness: 2,
              color: _currentStep >= 2
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle('2', _currentStep >= 2, 'Payment'),
          Expanded(
            child: Divider(
              thickness: 2,
              color: _currentStep >= 3
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle('3', _currentStep >= 3, 'Success'),
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ticket Quantity
          Text('Ticket Quantity', style: AppComponent.labelTextStyle),
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
                      hintText: 'Ticket quantity',
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
                        return 'Please enter ticket quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      if (int.parse(value) < 1) {
                        return 'Quantity must be at least 1';
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
          Text('Ticket Type', style: AppComponent.labelTextStyle),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedTicketType,
            hint: Text('Select Ticket Type', style: AppComponent.hintTextStyle),
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
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a ticket type';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
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
                'Order Summary',
                style: AppComponent.boldTextStyle.copyWith(fontSize: 18),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Event:', style: TextStyle(color: Colors.grey.shade600)),
                  Flexible(
                    child: Text(
                      'Traditional Dance Show',
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
                    'Ticket Type:',
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
                    'Quantity:',
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
                    'Price per ticket:',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Text(
                    '\$284.2',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Divider(thickness: 1, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: AppComponent.boldTextStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    '\$${(_quantity * 284.2).toStringAsFixed(1)}',
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

        SizedBox(height: 24),

        // Payment Method Selection
        Text('Payment Method', style: AppComponent.labelTextStyle),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPaymentMethodWidget(
                0,
                Icon(Icons.credit_card),
                'Credit Card',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildPaymentMethodWidget(
                1,
                Icon(Icons.qr_code),
                'QR Code',
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Payment Details
        if (_selectedPaymentMethod == 0)
          PayWithCardWidget(
            formKey: _formKey,
            quantityController: _quantityController,
            expirationController: _expirationController,
            securityCodeController: _securityCodeController,
            cardNumberController: _cardNumberController,
            cardNameController: _cardNameController,
          ),
        if (_selectedPaymentMethod == 1) PayWithQrWidget(),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        Icon(Icons.check_circle, color: Colors.green, size: 100),
        SizedBox(height: 24),
        Text(
          'Payment Successful!',
          style: AppComponent.boldTextStyle.copyWith(fontSize: 24),
        ),
        SizedBox(height: 16),
        Text(
          'Your tickets have been booked successfully.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AdvertiseColor.textColor.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Booking ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
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
              Text(
                'Download your tickets from the "My Tickets" section.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'You will also receive an email confirmation.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodWidget(int index, Icon icon, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _selectedPaymentMethod == index
              ? Color.fromARGB(255, 246, 237, 251)
              : Colors.transparent,
          border: Border.all(
            color: _selectedPaymentMethod == index
                ? AdvertiseColor.primaryColor
                : Colors.grey.shade300,
            width: _selectedPaymentMethod == index ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon.icon,
              color: _selectedPaymentMethod == index
                  ? AdvertiseColor.primaryColor
                  : Colors.grey.shade500,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: _selectedPaymentMethod == index
                    ? AdvertiseColor.primaryColor
                    : Colors.grey.shade600,
                fontWeight: _selectedPaymentMethod == index
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayWithQrWidget extends StatelessWidget {
  const PayWithQrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Scan QR Code',
            style: AppComponent.boldTextStyle.copyWith(fontSize: 18),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Image.asset(
              'assets/img/sample/qr.png',
              width: 200,
              height: 200,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Scan this QR code with your banking app to complete the payment',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'QR payments are processed instantly and securely',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PayWithCardWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController quantityController;
  final TextEditingController expirationController;
  final TextEditingController securityCodeController;
  final TextEditingController cardNumberController;
  final TextEditingController cardNameController;

  const PayWithCardWidget({
    super.key,
    required this.formKey,
    required this.quantityController,
    required this.expirationController,
    required this.securityCodeController,
    required this.cardNumberController,
    required this.cardNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card, color: Colors.blueAccent, size: 28),
                SizedBox(width: 12),
                Text(
                  'Card Details',
                  style: AppComponent.boldTextStyle.copyWith(
                    fontSize: 20,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Card Number
            Text('Card Number', style: AppComponent.labelTextStyle),
            SizedBox(height: 8),
            TextFormField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '1234 5678 9012 3456',
                hintStyle: AppComponent.hintTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: Icon(
                  Icons.credit_card,
                  color: Colors.grey.shade500,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                if (value.replaceAll(' ', '').length != 16) {
                  return 'Enter valid 16-digit card number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Cardholder Name
            Text('Cardholder Name', style: AppComponent.labelTextStyle),
            SizedBox(height: 8),
            TextFormField(
              controller: cardNameController,
              decoration: InputDecoration(
                hintText: 'John Doe',
                hintStyle: AppComponent.hintTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter cardholder name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Expiration & Security Code
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expiration Date',
                        style: AppComponent.labelTextStyle,
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: expirationController,
                        decoration: InputDecoration(
                          hintText: 'MM/YY',
                          hintStyle: AppComponent.hintTextStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (!RegExp(
                            r'^(0[1-9]|1[0-2])\/([0-9]{2})$',
                          ).hasMatch(value)) {
                            return 'Invalid format (MM/YY)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Security Code', style: AppComponent.labelTextStyle),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: securityCodeController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'CVC',
                          hintStyle: AppComponent.hintTextStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (value.length < 3 || value.length > 4) {
                            return 'Invalid CVC';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Security Note
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.blue, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment is secured with SSL encryption',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

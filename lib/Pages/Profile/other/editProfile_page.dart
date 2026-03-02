import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/UserDto.dart';
import 'package:mobile_assignment/services/API/UserApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:uuid/uuid.dart';

class EditprofilePage extends StatefulWidget {
  const EditprofilePage({super.key});

  @override
  State<EditprofilePage> createState() => _EditprofilePageState();
}

class _EditprofilePageState extends State<EditprofilePage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  Userapi userapi = Userapi();
  Userdto? userData;
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  List<String> gender = ['Male', 'Female', 'Other'];
  bool isloading = false;
  String? _selectedGender;
  DateTime? _selectDate;
  Future<Userdto?>? _userFuture;
  File? _pickedImage;
  var uuid = Uuid();

  Future<Userdto?> _loadUserData() async {
    var userEmail = await usersharedpreferences.getUserEmail();
    if (userEmail != null) {
      var uData = await userapi.getUserByEmail(email: userEmail);
      if (uData != null) {
        // Populate fields after data is loaded
        userData = uData;
        _fullnameController.text = uData.fullname;
        _phoneNumberController.text = uData.phoneNumber;
        _selectedGender = uData.gender;
        _selectDate = uData.dateOfBirth;
        return uData;
      }
    }
    return null;
  }

  String? _getValidGenderValue(String? genderValue) {
    if (genderValue == null || genderValue.isEmpty) {
      return null;
    }

    // Check if the gender value exists in the list (case-insensitive)
    return gender.firstWhere(
      (g) => g.toLowerCase() == genderValue.toLowerCase(),
      orElse: () => '', // Return empty string if not found
    );
  }

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUserData();
  }

  void editUser() async {
    setState(() {
      isloading = true;
    });
    String uniqueFileName = 'image_${uuid.v4()}.png';
    if (_pickedImage != null) {
      await userapi.uploadUserImage(
        image: _pickedImage,
        imageName: uniqueFileName,
      );
    }
    if (userData != null) {
      var resposne = await userapi.updateUser(
        user: Userdto(
          id: userData!.id,
          fullname: _fullnameController.text,
          email: userData!.email,
          gender: _selectedGender!,
          password: userData!.password,
          phoneNumber: _phoneNumberController.text,
          dateOfBirth: _selectDate!,
          profilePicture: _pickedImage != null
              ? uniqueFileName
              : userData!.profilePicture,
          organizer: userData!.organizer,
          verified: userData!.verified,
          createdAt: userData!.createdAt,
          google: userData!.google,
        ),
      );
      if (resposne != null) {
        setState(() {
          isloading = false;
        });
        await usersharedpreferences.saveUserName(resposne.fullname);
        _showDialog(
          icon: Icons.verified,
          iconColor: Colors.green,
          message: 'Update Password Successfully!',
          isSuccess: true,
        );
      } else {
        setState(() {
          isloading = false;
        });
        _showDialog(
          icon: Icons.close_rounded,
          iconColor: AdvertiseColor.dangerColor,
          message: 'Failed to update!',
        );
      }
    } else {
      setState(() {
        isloading = false;
      });
      _showDialog(
        icon: Icons.close_rounded,
        iconColor: AdvertiseColor.dangerColor,
        message: 'Failed to update!',
      );
    }
  }

  void _showDialog({
    required IconData icon,
    required Color iconColor,
    required String message,
    bool isSuccess = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 50),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppComponent.boldTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          if (isSuccess)
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous page
              },
              child: const Text('OK'),
            )
          else
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading user data'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found'));
          }

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _pickedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(
                                  100,
                                ),
                                child: Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.fitWidth,
                                  height: 150,
                                  width: 150,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(
                                  100,
                                ),
                                child: Image.network(
                                  '${headUrl}lib/img/user/${userData?.profilePicture}',
                                  fit: BoxFit.fitWidth,
                                  width: 150,
                                  height: 150,
                                  errorBuilder: (context, error, stackTrace) =>
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(100),
                                        child: Image.asset(
                                          "assets/img/other/errorImage.png",
                                          fit: BoxFit.fitWidth,
                                          height: 150,
                                          width: 150,
                                        ),
                                      ),
                                ),
                              ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
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
                          Text('Fullname*', style: AppComponent.labelTextStyle),
                          TextFormField(
                            controller: _fullnameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input your fullname';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            height: 95,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date of Brith',
                                        style: AppComponent.labelTextStyle,
                                      ),
                                      Container(
                                        height: 50,
                                        child: GestureDetector(
                                          onTap: () =>
                                              _pickDate(isStartDate: true),
                                          child: AbsorbPointer(
                                            child: TextFormField(
                                              controller: TextEditingController(
                                                text: _selectDate == null
                                                    ? (userData?.dateOfBirth !=
                                                              null
                                                          ? DateFormat(
                                                              'dd/MM/yyyy',
                                                            ).format(
                                                              userData!
                                                                  .dateOfBirth,
                                                            )
                                                          : '')
                                                    : DateFormat(
                                                        'dd/MM/yyyy',
                                                      ).format(_selectDate!),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gender',
                                        style: AppComponent.labelTextStyle,
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: _getValidGenderValue(
                                          _selectedGender ?? userData?.gender,
                                        ),
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
                                            return 'Please select gender';
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
                          SizedBox(height: 10),
                          Text('Phone', style: AppComponent.labelTextStyle),
                          TextFormField(
                            controller: _phoneNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AdvertiseColor.backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth <= 360 ? 40 : 50,
                                    vertical: 15,
                                  ),
                                ),
                                child: Text(
                                  'CANCEL',
                                  style: AppComponent.elevatedButtonTextStyle
                                      .copyWith(
                                        color: AdvertiseColor.textColor,
                                      ),
                                ),
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: isloading
                                    ? null
                                    : () {
                                        if (_formkey.currentState!.validate()) {
                                          editUser();
                                        }
                                      },
                                style: AppComponent.elevatedButtonStyle,
                                child: isloading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'SAVE',
                                        style: AppComponent
                                            .elevatedButtonTextStyle,
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
        },
      ),
    );
  }
}

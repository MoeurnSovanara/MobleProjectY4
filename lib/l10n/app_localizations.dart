import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
  ];

  /// No description provided for @homeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// No description provided for @searchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchLabel;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcoming;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'See All>'**
  String get all;

  /// No description provided for @lAll.
  ///
  /// In en, this message translates to:
  /// **'See all Event'**
  String get lAll;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notification;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get newLabel;

  /// No description provided for @eventLabel.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventLabel;

  /// No description provided for @bookTicketButton.
  ///
  /// In en, this message translates to:
  /// **'Booking Ticket'**
  String get bookTicketButton;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get time;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location:'**
  String get location;

  /// No description provided for @ticketInfo.
  ///
  /// In en, this message translates to:
  /// **'Ticket Information'**
  String get ticketInfo;

  /// No description provided for @capacityTicket.
  ///
  /// In en, this message translates to:
  /// **'Capacity Tikets'**
  String get capacityTicket;

  /// No description provided for @remainingTicket.
  ///
  /// In en, this message translates to:
  /// **'Remaining Tickets'**
  String get remainingTicket;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'tickets'**
  String get tickets;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @paymentText.
  ///
  /// In en, this message translates to:
  /// **'Please check the price before going!!'**
  String get paymentText;

  /// No description provided for @ticketQuantity.
  ///
  /// In en, this message translates to:
  /// **'Ticket Quantity'**
  String get ticketQuantity;

  /// No description provided for @enter_ticket_quantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter ticket quantity'**
  String get enter_ticket_quantity;

  /// No description provided for @enter_valid_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get enter_valid_number;

  /// No description provided for @quantity_min_one.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be at least 1'**
  String get quantity_min_one;

  /// No description provided for @ticketType.
  ///
  /// In en, this message translates to:
  /// **'Ticket Type'**
  String get ticketType;

  /// No description provided for @select_ticket_type_label.
  ///
  /// In en, this message translates to:
  /// **'Seelct a ticket type'**
  String get select_ticket_type_label;

  /// No description provided for @select_ticket_type.
  ///
  /// In en, this message translates to:
  /// **'Please select a ticket type'**
  String get select_ticket_type;

  /// No description provided for @nextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextLabel;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @oEvent.
  ///
  /// In en, this message translates to:
  /// **'Event:'**
  String get oEvent;

  /// No description provided for @oTicketType.
  ///
  /// In en, this message translates to:
  /// **'Ticket Type:'**
  String get oTicketType;

  /// No description provided for @oQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity:'**
  String get oQuantity;

  /// No description provided for @oPricePerTicket.
  ///
  /// In en, this message translates to:
  /// **'Price per ticket:'**
  String get oPricePerTicket;

  /// No description provided for @oTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get oTotal;

  /// No description provided for @backLabel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backLabel;

  /// No description provided for @lTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get lTickets;

  /// No description provided for @lPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get lPayment;

  /// No description provided for @lSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get lSuccess;

  /// No description provided for @payment_successful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successfull!'**
  String get payment_successful;

  /// No description provided for @stext1.
  ///
  /// In en, this message translates to:
  /// **'Your tickets have been booked successfully.'**
  String get stext1;

  /// No description provided for @sBookId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID:'**
  String get sBookId;

  /// No description provided for @stext2.
  ///
  /// In en, this message translates to:
  /// **'Download your tickets from the \'My Tickets\' section.'**
  String get stext2;

  /// No description provided for @stext3.
  ///
  /// In en, this message translates to:
  /// **'You will also receive an email confirmation.'**
  String get stext3;

  /// No description provided for @finishLabel.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishLabel;

  /// No description provided for @dashBoardLabel.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashBoardLabel;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @dComplete.
  ///
  /// In en, this message translates to:
  /// **'Purhcase now to gain membership badge and chance 26/500 tickets to win many rewards.'**
  String get dComplete;

  /// No description provided for @historyBooking.
  ///
  /// In en, this message translates to:
  /// **'History booking'**
  String get historyBooking;

  /// No description provided for @historyPostBooking.
  ///
  /// In en, this message translates to:
  /// **'History Post booking'**
  String get historyPostBooking;

  /// No description provided for @ticketsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get ticketsLabel;

  /// No description provided for @noTicket.
  ///
  /// In en, this message translates to:
  /// **'No tickts found'**
  String get noTicket;

  /// No description provided for @tryAgainLabel.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainLabel;

  /// No description provided for @profileLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileLabel;

  /// No description provided for @profilePage.
  ///
  /// In en, this message translates to:
  /// **'Profile Page'**
  String get profilePage;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @newDevice.
  ///
  /// In en, this message translates to:
  /// **'ADD NEW DEVICES'**
  String get newDevice;

  /// No description provided for @pMyTicket.
  ///
  /// In en, this message translates to:
  /// **'My Ticket'**
  String get pMyTicket;

  /// No description provided for @pNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get pNotification;

  /// No description provided for @pLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get pLanguage;

  /// No description provided for @pPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get pPassword;

  /// No description provided for @pAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get pAppearance;

  /// No description provided for @pBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get pBookmark;

  /// No description provided for @languageDetail.
  ///
  /// In en, this message translates to:
  /// **'Please seelct a display language'**
  String get languageDetail;

  /// No description provided for @khmerLabel.
  ///
  /// In en, this message translates to:
  /// **'Khmer'**
  String get khmerLabel;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @selectLabel.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectLabel;

  /// No description provided for @passTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get passTitle;

  /// No description provided for @oldPass.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPass;

  /// No description provided for @newPass.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPass;

  /// No description provided for @confirmPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmPass;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @appearanceDetail.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme'**
  String get appearanceDetail;

  /// No description provided for @lightLable.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightLable;

  /// No description provided for @darkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkLabel;

  /// No description provided for @noBookMarkDetail.
  ///
  /// In en, this message translates to:
  /// **'No Bookmarks Found!'**
  String get noBookMarkDetail;

  /// No description provided for @usedTicket.
  ///
  /// In en, this message translates to:
  /// **'USed Ticket'**
  String get usedTicket;

  /// No description provided for @eventInformation.
  ///
  /// In en, this message translates to:
  /// **'Event Information'**
  String get eventInformation;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @addTicket.
  ///
  /// In en, this message translates to:
  /// **'Add Ticket'**
  String get addTicket;

  /// No description provided for @browseImage.
  ///
  /// In en, this message translates to:
  /// **'Browse Image'**
  String get browseImage;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Title'**
  String get eventTitle;

  /// No description provided for @enterEventTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter event title'**
  String get enterEventTitleHint;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select Event Category'**
  String get selectCategoryHint;

  /// No description provided for @pickStartDateHint.
  ///
  /// In en, this message translates to:
  /// **'Pick start date'**
  String get pickStartDateHint;

  /// No description provided for @pickEndDateHint.
  ///
  /// In en, this message translates to:
  /// **'Pick end date'**
  String get pickEndDateHint;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @pickStartTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Pick start time'**
  String get pickStartTimeHint;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// No description provided for @pickEndTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Pick end time'**
  String get pickEndTimeHint;

  /// No description provided for @validateEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter event title'**
  String get validateEventTitle;

  /// No description provided for @validateCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get validateCategory;

  /// No description provided for @validateStartDate.
  ///
  /// In en, this message translates to:
  /// **'Please select start date'**
  String get validateStartDate;

  /// No description provided for @validateEndDate.
  ///
  /// In en, this message translates to:
  /// **'Please select end date'**
  String get validateEndDate;

  /// No description provided for @validateStartTime.
  ///
  /// In en, this message translates to:
  /// **'Please select start time'**
  String get validateStartTime;

  /// No description provided for @validateEndTime.
  ///
  /// In en, this message translates to:
  /// **'Please select end time'**
  String get validateEndTime;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @uploadImageHint.
  ///
  /// In en, this message translates to:
  /// **'upload your event image here'**
  String get uploadImageHint;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your description'**
  String get enterDescriptionHint;

  /// No description provided for @validateDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get validateDescription;

  /// No description provided for @enterTicketTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your ticket type'**
  String get enterTicketTypeHint;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @enterQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get enterQuantityHint;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @enterPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPriceHint;

  /// No description provided for @locationName.
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get locationName;

  /// No description provided for @enterLocationNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter location name'**
  String get enterLocationNameHint;

  /// No description provided for @enterLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter location'**
  String get enterLocationHint;

  /// No description provided for @locationLink.
  ///
  /// In en, this message translates to:
  /// **'Location Link'**
  String get locationLink;

  /// No description provided for @enterLocationLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Enter location link'**
  String get enterLocationLinkHint;

  /// No description provided for @validateLocationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter location name'**
  String get validateLocationName;

  /// No description provided for @validateLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enter location'**
  String get validateLocation;

  /// No description provided for @validateLocationLink.
  ///
  /// In en, this message translates to:
  /// **'Please enter location link'**
  String get validateLocationLink;

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInformation;

  /// No description provided for @paypalAccountId.
  ///
  /// In en, this message translates to:
  /// **'Paypal Account ID'**
  String get paypalAccountId;

  /// No description provided for @enterPaypalAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Paypal Account ID'**
  String get enterPaypalAccountHint;

  /// No description provided for @secretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret Key'**
  String get secretKey;

  /// No description provided for @enterSecretKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Secret Key'**
  String get enterSecretKeyHint;

  /// No description provided for @currencyCode.
  ///
  /// In en, this message translates to:
  /// **'Currency Code'**
  String get currencyCode;

  /// No description provided for @enterCurrencyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter currency code'**
  String get enterCurrencyCodeHint;

  /// No description provided for @validatePaypalAccount.
  ///
  /// In en, this message translates to:
  /// **'Please enter PayPal Account ID'**
  String get validatePaypalAccount;

  /// No description provided for @validateSecretKey.
  ///
  /// In en, this message translates to:
  /// **'Please Enter your Secret Key'**
  String get validateSecretKey;

  /// No description provided for @validateCurrencyCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter currency code'**
  String get validateCurrencyCode;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @eventCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have created an event successfully'**
  String get eventCreatedSuccess;

  /// No description provided for @errorFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get errorFillAllFields;

  /// No description provided for @errorAddTicket.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one ticket type'**
  String get errorAddTicket;

  /// No description provided for @errorSelectDates.
  ///
  /// In en, this message translates to:
  /// **'Please select event start and end dates'**
  String get errorSelectDates;

  /// No description provided for @errorEndDateAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date'**
  String get errorEndDateAfterStart;

  /// No description provided for @errorUserNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get errorUserNotLoggedIn;

  /// No description provided for @errorCreateVenue.
  ///
  /// In en, this message translates to:
  /// **'Failed to create venue'**
  String get errorCreateVenue;

  /// No description provided for @errorSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Please select an event image'**
  String get errorSelectImage;

  /// No description provided for @errorCreateEvent.
  ///
  /// In en, this message translates to:
  /// **'Failed to create event'**
  String get errorCreateEvent;

  /// No description provided for @errorCreateTickets.
  ///
  /// In en, this message translates to:
  /// **'Event created but failed to create ticket types'**
  String get errorCreateTickets;

  /// No description provided for @errorPaymentSetup.
  ///
  /// In en, this message translates to:
  /// **'Event created but payment setup failed'**
  String get errorPaymentSetup;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: '**
  String get errorOccurred;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @scanQrAtEntrance.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code at the entrance'**
  String get scanQrAtEntrance;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'logout'**
  String get logout;

  /// No description provided for @fullnameLabel.
  ///
  /// In en, this message translates to:
  /// **'Fullname*'**
  String get fullnameLabel;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @selectGenderHint.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGenderHint;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @validateFullname.
  ///
  /// In en, this message translates to:
  /// **'Please input your fullname'**
  String get validateFullname;

  /// No description provided for @validateDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get validateDateOfBirth;

  /// No description provided for @validateGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get validateGender;

  /// No description provided for @validatePhone.
  ///
  /// In en, this message translates to:
  /// **'Please input your phone number'**
  String get validatePhone;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// No description provided for @updatePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update Password Successfully!'**
  String get updatePasswordSuccess;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update!'**
  String get updateFailed;

  /// No description provided for @errorLoadingUserData.
  ///
  /// In en, this message translates to:
  /// **'Error loading user data'**
  String get errorLoadingUserData;

  /// No description provided for @noUserDataFound.
  ///
  /// In en, this message translates to:
  /// **'No user data found'**
  String get noUserDataFound;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @validateOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Please input your old password'**
  String get validateOldPassword;

  /// No description provided for @validateNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please input your new password'**
  String get validateNewPassword;

  /// No description provided for @validateConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get validateConfirmPassword;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthError;

  /// No description provided for @passwordMatchError.
  ///
  /// In en, this message translates to:
  /// **'New password and confirm password do not match!'**
  String get passwordMatchError;

  /// No description provided for @userEmailNotFound.
  ///
  /// In en, this message translates to:
  /// **'User email not found!'**
  String get userEmailNotFound;

  /// No description provided for @incorrectOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Old Password!'**
  String get incorrectOldPassword;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @useExistingImage.
  ///
  /// In en, this message translates to:
  /// **'Use existing image'**
  String get useExistingImage;

  /// No description provided for @newImageSelected.
  ///
  /// In en, this message translates to:
  /// **'New image selected'**
  String get newImageSelected;

  /// No description provided for @currentImage.
  ///
  /// In en, this message translates to:
  /// **'Current image'**
  String get currentImage;

  /// No description provided for @noTicketsAdded.
  ///
  /// In en, this message translates to:
  /// **'No tickets added yet'**
  String get noTicketsAdded;

  /// No description provided for @errorUpdateVenue.
  ///
  /// In en, this message translates to:
  /// **'Failed to update venue'**
  String get errorUpdateVenue;

  /// No description provided for @errorUpdateEvent.
  ///
  /// In en, this message translates to:
  /// **'Failed to update event'**
  String get errorUpdateEvent;

  /// No description provided for @errorLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get errorLoadData;

  /// No description provided for @imageRequired.
  ///
  /// In en, this message translates to:
  /// **'Image is required'**
  String get imageRequired;

  /// No description provided for @eventUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event updated successfully'**
  String get eventUpdatedSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

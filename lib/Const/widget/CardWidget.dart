import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/TicketDto.dart';
import 'package:intl/intl.dart';
import 'package:mobile_assignment/services/Helper/PreloadImageHelper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CardWidget extends StatefulWidget {
  final Ticketdto tickets;
  final int? userId;
  final VoidCallback onTicketUpdated;

  const CardWidget({
    super.key,
    required this.tickets,
    this.userId,
    required this.onTicketUpdated,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  late PreloadImageHelper _imageHelper;
  final String baseUrl =
      "YOUR_BASE_URL_HERE"; // Replace with your actual base URL

  @override
  void initState() {
    super.initState();
    _imageHelper = PreloadImageHelper(
      imageName: widget.tickets.ticketType.events.image,
      onUpdate: _onImageUpdate,
      mounted: mounted,
    );

    // Start preloading image
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _imageHelper.preloadImage(baseUrl);
      }
    });
  }

  void _onImageUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newImageName = widget.tickets.ticketType.events.image;
    if (_imageHelper.imageName != newImageName) {
      _imageHelper = PreloadImageHelper(
        imageName: newImageName,
        onUpdate: _onImageUpdate,
        mounted: mounted,
      );
      _imageHelper.preloadImage(baseUrl);
    }
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Date not set';
    try {
      return DateFormat('EEE, MMM d, yyyy').format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    try {
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String _formatPrice(double? price) {
    if (price == null) return 'Price not available';
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final event = widget.tickets.ticketType.events;
    final venue = event.venues;

    final eventTitle = event.title;
    final DateTime eventDate = event.eventStart;
    final String eventLocation = venue.venueLocation;
    final double ticketPrice = widget.tickets.ticketType.price;
    final String ticketTypeName = widget.tickets.ticketType.typeName;

    final String formattedDate = _formatDate(eventDate);
    final String formattedTime = _formatTime(eventDate);

    return Container(
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            // Event image with preload helper
            Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AdvertiseColor.primaryColor.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildEventImage(),
              ),
            ),
            const SizedBox(width: 10),

            // Event details
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event title
                  Text(
                    eventTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppComponent.labelStyle.copyWith(
                      fontSize: screenWidth <= 393 ? 14 : 16,
                    ),
                  ),

                  // Ticket type badge
                  Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getTicketTypeColor(
                        ticketTypeName,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ticketTypeName,
                      style: AppComponent.detailTextStyle.copyWith(
                        fontSize: 10,
                        color: _getTicketTypeColor(ticketTypeName),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Date and time
                  if (formattedDate.isNotEmpty &&
                      formattedDate != 'Date not set')
                    Text(
                      formattedTime.isNotEmpty
                          ? '$formattedDate at $formattedTime'
                          : formattedDate,
                      style: AppComponent.detailTextStyle.copyWith(
                        fontSize: screenWidth <= 393 ? 12 : 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // Location
                  Text(
                    eventLocation,
                    style: AppComponent.detailTextStyle.copyWith(
                      fontSize: screenWidth <= 393 ? 12 : 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 5),

                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AdvertiseColor.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _formatPrice(ticketPrice),
                      style: AppComponent.elevatedButtonTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth <= 393 ? 12 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // QR Code button - only for ticket owner
            if (widget.userId != null && widget.tickets.userId == widget.userId)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _showQRCodeDialog(context),
                    icon: Icon(
                      Icons.qr_code_scanner,
                      color: AdvertiseColor.primaryColor,
                      size: 30,
                    ),
                    tooltip: 'Show QR Code',
                  ),
                  Text(
                    'Scan QR',
                    style: AppComponent.detailTextStyle.copyWith(fontSize: 10),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage() {
    if (_imageHelper.hasValidImage) {
      return Image.network(
        "$baseUrl/img/${_imageHelper.imageName}",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Icon(Icons.event, size: 40, color: AdvertiseColor.primaryColor),
    );
  }

  Color _getTicketTypeColor(String typeName) {
    switch (typeName.toLowerCase()) {
      case 'vip':
        return Colors.amber;
      case 'regular':
        return Colors.blue;
      case 'simple':
        return Colors.grey;
      default:
        return AdvertiseColor.primaryColor;
    }
  }

  String _getQRData() {
    // Use the actual QR field from your ticket
    // You can customize this JSON structure based on what you need
    final qrData = {
      'ticketId': widget.tickets.id,
      'eventId': widget.tickets.ticketType.events.id,
      'userId': widget.userId,
      'ticketType': widget.tickets.ticketType.typeName,
      'qrCode': widget.tickets.uniqueTicketCode, // Using the actual QR field
      'timestamp': DateTime.now().toIso8601String(),
    };

    // If you have a specific QR string, use it directly
    if (widget.tickets.uniqueTicketCode != "") {
      return widget.tickets.uniqueTicketCode;
    }

    // Otherwise create a JSON string
    return qrData.toString();
  }

  void _showQRCodeDialog(BuildContext context) {
    final event = widget.tickets.ticketType.events;
    final qrData = _getQRData();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Generated QR Code
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AdvertiseColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AdvertiseColor.primaryColor,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AdvertiseColor.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ticket info
              Text(
                event.title,
                style: AppComponent.boldTextStyle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),

              ...[
                const SizedBox(height: 5),
                Text(
                  '${_formatDate(event.eventStart)} ${_formatTime(event.eventStart).isNotEmpty ? 'at ${_formatTime(event.eventStart)}' : ''}',
                  style: AppComponent.detailTextStyle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  event.venues.venueLocation,
                  style: AppComponent.detailTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getTicketTypeColor(
                    widget.tickets.ticketType.typeName,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.tickets.ticketType.typeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Ticket #${widget.tickets.id}',
                  style: AppComponent.detailTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Scan this QR code at the entrance',
                style: AppComponent.detailTextStyle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Close button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdvertiseColor.primaryColor,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Close',
                  style: AppComponent.elevatedButtonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

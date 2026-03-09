import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/TicketDto.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/TimeHelperClass.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Usedcardwidget extends StatefulWidget {
  final Ticketdto usedTicket;
  const Usedcardwidget({super.key, required this.usedTicket});

  @override
  State<Usedcardwidget> createState() => _UsedcardwidgetState();
}

class _UsedcardwidgetState extends State<Usedcardwidget> {
  String _getQRData() {
    // Use the actual QR field from your ticket
    if (widget.usedTicket.uniqueTicketCode.isNotEmpty) {
      return widget.usedTicket.uniqueTicketCode;
    }

    // Otherwise create a JSON string
    final qrData = {
      'ticketId': widget.usedTicket.id,
      'eventId': widget.usedTicket.ticketType.events.id,
      'userId': widget.usedTicket.userId,
      'ticketType': widget.usedTicket.ticketType.typeName,
      'qrCode': widget.usedTicket.uniqueTicketCode,
      'timestamp': DateTime.now().toIso8601String(),
    };

    return qrData.toString();
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

  void _showQRCodeDialog(BuildContext context) {
    final event = widget.usedTicket.ticketType.events;
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

              const SizedBox(height: 10),

              // Ticket type badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getTicketTypeColor(
                    widget.usedTicket.ticketType.typeName,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.usedTicket.ticketType.typeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Ticket ID badge
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
                  'Ticket #${widget.usedTicket.id}',
                  style: AppComponent.detailTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Instruction text
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

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Ticket',
          style: AppComponent.boldTextStyle.copyWith(
            color: AdvertiseColor.dangerColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this ticket? This action cannot be undone.',
          style: AppComponent.labelStyle,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _deleteTicket();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdvertiseColor.dangerColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteTicket() {
    // Add your delete ticket logic here
    // For example, call an API to delete the ticket
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket #${widget.usedTicket.id} deleted'),
        backgroundColor: Colors.green,
      ),
    );

    // You might want to refresh the parent widget or pop the screen
    // Navigator.pop(context); // If this is in a list that needs refreshing
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final helperclass = Helperclass();
    final timerhelper = Timehelperclass();

    final event = widget.usedTicket.ticketType.events;

    return Container(
      height: screenWidth <= 402 ? 140 : 160,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${headUrl}lib/img/event/${event.image}',
                height: 90,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 90,
                  width: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Event Details
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppComponent.labelStyle.copyWith(
                      fontSize: screenWidth <= 402 ? 12 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${helperclass.formatDate(event.eventStart)} at ${timerhelper.formatTimeAMPM(event.startTime)}',
                    style: AppComponent.detailTextStyle.copyWith(
                      fontSize: screenWidth <= 402 ? 10 : 12,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: screenWidth <= 402 ? 14 : 16,
                        color: AdvertiseColor.textColor.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.venues.venueInfo,
                          style: AppComponent.detailTextStyle.copyWith(
                            fontSize: screenWidth <= 402 ? 10 : 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QR Code Button
                GestureDetector(
                  onTap: () => _showQRCodeDialog(context),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AdvertiseColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.qr_code,
                      color: AdvertiseColor.primaryColor,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Delete Button
                GestureDetector(
                  onTap: _confirmDelete,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AdvertiseColor.dangerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: AdvertiseColor.dangerColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

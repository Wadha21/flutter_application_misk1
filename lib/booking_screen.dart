import 'package:flutter/material.dart';
import 'package:flutter_application_1/BookingConfirmation.dart';
import 'package:flutter_application_1/models/BookingData.dart';

class FirstBookingScreen extends StatefulWidget {
  final BookingData booking;
  const FirstBookingScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<FirstBookingScreen> createState() => _FirstBookingScreenState();
}

class _FirstBookingScreenState extends State<FirstBookingScreen> {
  late BookingData data;
  int selectedCount = 1;
  String selectedTime = 'الآن';
  final Color brown = const Color(0xFFB68A56);

  @override
  void initState() {
    super.initState();
    data = widget.booking;
    selectedCount = data.passengerCount ?? 1;
    selectedTime = data.pickupTime;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header with back arrow
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: brown,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(22),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Text(
                          'حجز ' + data.vehicle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // small location card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: brown.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${data.fromLocation} → ${data.toLocation}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // passenger count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedCount > 1) selectedCount--;
                            });
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          '$selectedCount شخص',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedCount > 1) selectedCount--;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        const Spacer(),
                        const Text(
                          'عدد المستخدمين',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // pickup time selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.end,
                    runSpacing: 8,
                    children: [
                      'الآن',
                      'بعد 5 دقائق',
                      'بعد 10 دقائق',
                      'بعد 30 دقيقة',
                    ].map((t) => _timeChip(t)).toList(),
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        final updatedBooking = data.copyWith(
                          pickupTime: selectedTime,
                          passengerCount: selectedCount,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BookingConfirmation(booking: updatedBooking),
                          ),
                        );
                      },

                      child: const Text(
                        'تأكيد الحجز',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeChip(String text) {
    final bool active = text == selectedTime;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? brown : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? brown : Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(color: active ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}

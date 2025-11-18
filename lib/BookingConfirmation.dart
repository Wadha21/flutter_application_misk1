import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/BookingData.dart';
import 'success_booking.dart';

class BookingConfirmation extends StatelessWidget {
  final BookingData booking;
  const BookingConfirmation({Key? key, required this.booking}) : super(key: key);

  final Color brown = const Color(0xFFB68A56);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header with back arrow
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: brown,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    
                      Center(child: const Text('تأكيد الحجز', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                  
                      const SizedBox(width:50),IconButton(
                        icon: const Icon(Icons.arrow_forward,color: Colors.white),onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Spacer(),
                            Text('ملخص الحجز', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                             SizedBox(width: 8),   Icon(Icons.pedal_bike, color: Colors.brown),
                          ],
                        ),
                         SizedBox(height: 14),
                        _summaryRow('وسيلة النقل', booking.vehicle),
                        _summaryRow('وقت الاستلام', booking.pickupTime),
                        _summaryRow('من', booking.fromLocation),
                        _summaryRow('إلى', booking.toLocation),
                        _summaryRow('عدد المستخدمين', booking.passengerCount?.toString() ?? '1'),
                      ],
                    ),
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
                        backgroundColor: brown,foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) =>  SuccessScreen(readyTime: '3 دقائق', booking: booking,))
                        );
                      },
                      child: const Text('تأكيد الحجز', style: TextStyle(fontSize: 16))
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

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 15)),
          const Spacer(),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

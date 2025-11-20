import 'package:flutter/material.dart';
import 'package:flutter_application_1/booking_screen.dart';
import 'package:flutter_application_1/models/BookingData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlanTrip extends StatefulWidget {
  final BookingData booking;
  const PlanTrip({Key? key, required this.booking}) : super(key: key);

  @override
  State<PlanTrip> createState() => _PlanTripState();
}

class _PlanTripState extends State<PlanTrip> {
  late BookingData data;
  final Color brown = const Color(0xFFB68A56);
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  @override
  void initState() {
    super.initState();
    data = widget.booking;
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Center(
                        child: const Text(
                          textAlign: TextAlign.center,
                          'خطط رحلتك',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _smallField('من', data.fromLocation),
                      const SizedBox(height: 8),
                      _smallField('إلى', data.toLocation),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Map placeholder
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F0E8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(24.6955796, 46.583077), //
                            zoom: 15,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          markers: _markers,
                          polylines: _polylines,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Transport selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _transportItem('الدراجة', Icons.pedal_bike),
                      const SizedBox(width: 10),
                      _transportItem('العربة الكهربائية', Icons.ev_station),
                      const SizedBox(width: 10),
                      _transportItem('مشي', Icons.directions_walk),
                    ],
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FirstBookingScreen(booking: data),
                          ),
                        );
                      },
                      child: const Text(
                        'متابعة الحجز',
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

  Widget _smallField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 10, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _transportItem(String title, IconData icon) {
    final bool active = title == data.vehicle;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            data = data.copyWith(vehicle: title);
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active ? brown : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? brown : Colors.grey.shade300),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: active ? Colors.white : Colors.black),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(color: active ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

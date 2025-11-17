import 'package:flutter/material.dart';
import 'package:flutter_application_1/ar_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final LatLng initial = const LatLng(24.795, 46.595);

  // هذه الدالة تُنفذ عند النقر على أي نقطة على الخريطة
  void _onMapTap(LatLng pos) {
    // الانتقال إلى شاشة الواقع المعزز مع تمرير إحداثيات النقطة المختارة
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ARScreen(latitude: pos.latitude, longitude: pos.longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A4D3E),
        title: const Text("الخريطة", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: GoogleMap(
        // تحديد موقع وزوم الكاميرا المبدئي
        initialCameraPosition: CameraPosition(target: initial, zoom: 16.5),
        onMapCreated: (c) => _mapController = c,
        onTap: _onMapTap, // ربط دالة النقر
        myLocationEnabled: true, // تفعيل عرض موقع المستخدم
        // العلامات (Markers) تم إيقافها مؤقتاً في الكود المرسل، لذا بقيت محذوفة
      ),
    );
  }
}

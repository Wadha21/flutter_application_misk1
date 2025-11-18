import 'package:flutter/material.dart';
import 'package:flutter_application_1/ar_screen.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final LatLng initial = const LatLng(24.6955796, 46.583077);
  final String googleApiKey = "key";

  LatLng? _origin; // انطلاق
  LatLng? _destination; // وصول

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  String _selectedMode = 'walking';
  List<String> _modes = ['walking', 'driving', 'bicycling'];

  @override
  void initState() {
    super.initState();
    _determineOrigin(); // تحديد موقع المستخدم الحالي كنقطة انطلاق
  }

  Future<void> _determineOrigin() async {
    // كود طلب صلاحيات الموقع
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _origin = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: _origin!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'نقطة الانطلاق (أنت)'),
        ),
      );
    });
  }

  // دالة جلب ورسم المسار (Polyline) على الخريطة
  void _getAndDrawRoute() async {
    if (_origin == null || _destination == null) {
      setState(() => _polylines.clear()); // مسح المسار إذا لم تكتمل النقاط
      //  print message

      print('DEBUG: Origin or Destination is null. Cannot draw route.');
      return;
    }
    //  print message
    print('DEBUG: Origin: ${_origin!.latitude}, ${_origin!.longitude}');
    print(
      'DEBUG: Destination: ${_destination!.latitude}, ${_destination!.longitude}',
    );

    PolylinePoints polylinePoints = PolylinePoints(apiKey: googleApiKey);

    TravelMode mode = TravelMode.walking;
    if (_selectedMode == 'driving') {
      mode = TravelMode.driving;
    } else if (_selectedMode == 'bicycling') {
      mode = TravelMode.bicycling;
    }

    // ignore: deprecated_member_use
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_origin!.latitude, _origin!.longitude),
        destination: PointLatLng(
          _destination!.latitude,
          _destination!.longitude,
        ),
        mode: mode,
      ),
    );
    //  print message
    if (result.errorMessage != null) {
      print('DEBUG: Directions API Error: ${result.errorMessage}');
    } else {
      print('DEBUG: API call succeeded.');
    }

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: const Color(0xFF1A4D3E),
            points: polylineCoordinates,
            width: 5,
          ),
        );
      });
      //print message

      print(
        'DEBUG: Route drawn successfully with ${result.points.length} points.',
      );
    } else {
      //print message
      print('DEBUG: API returned 0 points. Check mode or key.');
    }
  }

  // دالة تُنفذ عند النقر على أي نقطة على الخريطة (لتحديد الوجهة)
  void _onMapTap(LatLng pos) {
    setState(() {
      _destination = pos;
      _markers.removeWhere((m) => m.markerId.value == 'destination');
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'وجهتك'),
        ),
      );
    });
    _getAndDrawRoute();
  }

  void _startARNavigation() {
    // يتم الانتقال فقط إذا كان الوضع 'walking'
    if (_destination != null && _selectedMode == 'walking') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ARScreen(
            latitude: _destination!.latitude,
            longitude: _destination!.longitude,
            travelMode: _selectedMode,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showARButton = _destination != null && _selectedMode == 'walking';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07856),
        title: const Text("الخريطة", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: _selectedMode,
              dropdownColor: const Color(0xFF1A4D3E),
              items: _modes.map((String mode) {
                return DropdownMenuItem<String>(
                  value: mode,
                  child: Text(
                    mode.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedMode = newValue);
                  _getAndDrawRoute();
                }
              },
            ),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: initial, zoom: 16.5),
        onMapCreated: (c) => _mapController = c,
        onTap: _onMapTap,
        myLocationEnabled: true,
        markers: _markers,
        polylines: _polylines,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // زر بدء الواقع المعزز (يظهر للمشي فقط)
          if (showARButton)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, left: 255),
              child: FloatingActionButton.extended(
                heroTag: "ar_btn",
                extendedPadding: const EdgeInsets.all(25),
                onPressed: _startARNavigation,
                label: const Text('بدء AR', style: TextStyle(fontSize: 16)),
                icon: const Icon(Icons.screen_rotation),
                backgroundColor: const Color(0xFF1A4D3E),
                foregroundColor: Colors.white,
              ),
            ),

          // زر الانطلاق (يظهر لجميع الحالات بعد تحديد الوجهة)
          if (_destination != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 75.0, left: 175),
              child: FloatingActionButton.extended(
                heroTag: "route_btn",
                extendedPadding: const EdgeInsets.all(25),
                onPressed: _getAndDrawRoute,
                label: Text('انطلاق بالـ (${_selectedMode.toUpperCase()})'),
                icon: const Icon(Icons.navigation),
                backgroundColor: const Color(0xFF1A4D3E),
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

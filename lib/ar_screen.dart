// AR Screen code (shortened due to message size)
import 'dart:async';
import 'dart:math' as math;
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ARScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  const ARScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;

  Position? _userPos;
  double? _deviceHeading;
  StreamSubscription? _headingSub;

  ARNode? _node;
  List<ARNode> pathNodes = [];
  List<PointLatLng> _routePoints = [];
  final String googleApiKey = "AIzaSyAmbeZlKzZHft_Ss9ctPpaOksLT__VwlAs";
  //  enable Directions API key from google;

  @override
  void initState() {
    super.initState();
    Permission.camera.request();
    Permission.location.request();
    _initSensors();
  }

  Future<void> _initSensors() async {
    _userPos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    await fetchRoutePoints();

    _headingSub = FlutterCompass.events?.listen((e) {
      if (e.heading != null) {
        _deviceHeading = e.heading;
        _place();
      }
    });
  }

  Future<void> fetchRoutePoints() async {
    if (_userPos == null) return;

    PolylinePoints polylinePoints = PolylinePoints(
      apiKey: "AIzaSyAmbeZlKzZHft_Ss9ctPpaOksLT__VwlAs",
    );
    // ignore: deprecated_member_use
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_userPos!.latitude, _userPos!.longitude),
        destination: PointLatLng(widget.latitude, widget.longitude),
        mode: TravelMode.walking,
        // walking, bicycle, car ...
      ),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        _routePoints = result.points;
      });
      // Now that you have the path, trigger placement
      _place();
    }
  }

  double _deg(double r) => r * math.pi / 180;
  double _dist(lat1, lon1, lat2, lon2) {
    const R = 6371000;
    final dPhi = _deg(lat2 - lat1);
    final dLam = _deg(lon2 - lon1);
    final a =
        math.sin(dPhi / 2) * math.sin(dPhi / 2) +
        math.cos(_deg(lat1)) *
            math.cos(_deg(lat2)) *
            math.sin(dLam / 2) *
            math.sin(dLam / 2);
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _bearing(lat1, lon1, lat2, lon2) {
    final y = math.sin(_deg(lon2 - lon1)) * math.cos(_deg(lat2));
    final x =
        math.cos(_deg(lat1)) * math.sin(_deg(lat2)) -
        math.sin(_deg(lat1)) *
            math.cos(_deg(lat2)) *
            math.cos(_deg(lon2 - lon1));
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  Vector3 _toVec(double dist, double ang) {
    final a = _deg(ang);
    return Vector3(dist * math.sin(a), 0, -dist * math.cos(a)) / 20;
  }

  void _place() async {
    for (ARNode node in pathNodes) {
      await arObjectManager?.removeNode(node);
    }
    pathNodes.clear();

    if (_userPos == null || _deviceHeading == null || _routePoints.isEmpty)
      return;

    for (int i = 0; i < _routePoints.length; i += 5) {
      final routePoints = _routePoints[i];
      final targetLat = routePoints.latitude;
      final targetLon = routePoints.longitude;

      final d = _dist(
        _userPos!.latitude,
        _userPos!.longitude,
        targetLat,
        targetLon,
      );
      final b = _bearing(
        _userPos!.latitude,
        _userPos!.longitude,
        targetLat,
        targetLon,
      );
      var rel = (b - _deviceHeading! + 360) % 360;
      final scaleDistance = d / 20.0;
      final pos = _toVec(scaleDistance, rel);
      String uri;
      Vector3 scale;

      if (i >= _routePoints.length - 5) {
        uri = "assets/models/Alfao.glb";
        scale = Vector3(1.0, 1.0, 1.0);
      } else {
        uri = "assets/models/dots_path.glb";
        scale = Vector3(0.05, 0.05, 0.05);
      }

      final n = ARNode(
        type: NodeType.localGLTF2,
        uri: uri,
        scale: scale,
        position: pos,
      );
      final added = await arObjectManager?.addNode(n);
      if (added == true) {
        pathNodes.add(n);
      }
    }
  }

  @override
  void dispose() {
    _headingSub?.cancel();
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR View")),
      body: ARView(
        planeDetectionConfig: PlaneDetectionConfig.horizontal,
        onARViewCreated: (s, o, a, l) {
          arSessionManager = s;
          arObjectManager = o;
          s.onInitialize(
            showPlanes: true,
            showFeaturePoints: false,
            handlePans: true,
          );
          o.onInitialize();
        },
      ),
    );
  }
}

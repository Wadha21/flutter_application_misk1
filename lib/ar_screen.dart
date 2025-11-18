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
import 'package:audioplayers/audioplayers.dart';

class ARScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String travelMode;
  const ARScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.travelMode,
  });

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
  final String googleApiKey = "AIzaSyAioesOdHxu2Y4izUuCr3RbBnE9iWsfmXc";
  //  enable Directions API key from google;

  final player = AudioPlayer();
  final Map<String, Map<String, String>> objectData = {
    "Alfao.glb": {
      "title": "تمثال الفاو العظيم",
      "info": "قطعة فنية تحاكي تراث مدينة الفاو الأثرية...",
      "audio": "audio/alfao_info.mp3",
    },
    "dots_path.glb": {
      "title": "نقطة توجيه",
      "info": "هذه النقطة تشير إلى المسار الصحيح للمشي.",
      "audio": "",
    },
  };
  @override
  void initState() {
    super.initState();
    Permission.camera.request();
    Permission.location.request();
    _initSensors();
  }

  Future<void> _initSensors() async {
    if (widget.travelMode != 'walking') {
      return;
    }

    _userPos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // await fetchRoutePoints();

    _headingSub = FlutterCompass.events?.listen((e) {
      if (e.heading != null) {
        _deviceHeading = e.heading;
        _place();
      }
    });
  }

  Future<void> fetchRoutePoints() async {
    if (_userPos == null) return;

    TravelMode mode = TravelMode.walking;

    PolylinePoints polylinePoints = PolylinePoints(apiKey: googleApiKey);

    // ignore: deprecated_member_use
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_userPos!.latitude, _userPos!.longitude),
        destination: PointLatLng(widget.latitude, widget.longitude),
        mode: mode,
        // walking, bicycle, car ...
      ),
    );
    // if (widget.travelMode == 'driving') {
    //   mode = TravelMode.driving;
    // } else if (widget.travelMode == 'bicycling') {
    //   mode = TravelMode.bicycling;
    // }

    if (result.points.isNotEmpty) {
      setState(() {
        _routePoints = result.points;
      });

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

    if (_userPos == null || _deviceHeading == null || _routePoints.isEmpty) {
      return;
    }

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
    player.dispose();
    _headingSub?.cancel();
    arSessionManager?.dispose();
    super.dispose();
  }

  void _onNodeTapped(List<dynamic> nodes) {
    final tappedNodes = nodes.whereType<ARNode>().toList();
    // ... (الكود لعرض النافذة وتشغيل الصوت)
    if (tappedNodes.isEmpty) return;

    final tappedNode = tappedNodes.first;

    final uri = tappedNode.uri.split('/').last;
    final data = objectData[uri];

    if (data == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data['title']!),
          content: Text(data['info']!),
          actions: [
            TextButton(
              onPressed: () {
                player.stop();
                Navigator.of(context).pop();
              },
              child: const Text('إغلاق'),
            ),
            if (data['audio']!.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.volume_up),
                label: const Text('استماع'),
                onPressed: () {
                  player.play(AssetSource(data['audio']!));
                },
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07856),
        title: const Text(
          "AR View (Walking)",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
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
          o.onNodeTap = _onNodeTapped;
          fetchRoutePoints();
        },
      ),
    );
  }
}

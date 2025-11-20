import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../models/position_data.dart';
import '../models/podcast_tracks.dart';

class AudioPlayerScreen extends StatefulWidget {
  final int initialTrackIndex;

  const AudioPlayerScreen({super.key, required this.initialTrackIndex});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration?, Duration?, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, buffered, duration) => PositionData(
          position ?? Duration.zero,
          buffered ?? Duration.zero,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    try {
      // إنشاء قائمة AudioSource
      final sources = podcastTracks
          .map((track) => AudioSource.asset(track['path']!))
          .toList();

      // تعيين المصادر مباشرة
      await _audioPlayer.setAudioSources(
        sources,
        initialIndex: widget.initialTrackIndex,
      );

      await _audioPlayer.play(); // تشغيل بعد التأكد من التحميل
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final mins = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final currentTrack = podcastTracks[widget.initialTrackIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE), // خلفية ناعمة
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // =======================
              //        IMAGE
              // =======================
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  currentTrack['image']!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // =======================
              //        TITLE
              // =======================
              Text(
                currentTrack['title']!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D3C2E),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFAF4),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ===== TIME ROW =====
                    StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final data =
                            snapshot.data ??
                            PositionData(
                              Duration.zero,
                              Duration.zero,
                              Duration.zero,
                            );

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _fmt(data.position),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _fmt(data.duration),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Progress bar
                            LinearProgressIndicator(
                              value: data.duration.inMilliseconds == 0
                                  ? 0
                                  : data.position.inMilliseconds /
                                        data.duration.inMilliseconds,
                              minHeight: 4,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFFCC9A50),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    //  PLAY BUTTON
                    StreamBuilder<bool>(
                      stream: _audioPlayer.playingStream,
                      builder: (context, snapshot) {
                        final isPlaying = snapshot.data ?? false;

                        return GestureDetector(
                          onTap: () {
                            isPlaying
                                ? _audioPlayer.pause()
                                : _audioPlayer.play();
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE2B04A),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

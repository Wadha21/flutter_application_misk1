import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

// Import the data models
import '../models/position_data.dart';
import '../models/podcast_tracks.dart'; // <-- Imports the separate track list

class AudioPlayerScreen extends StatefulWidget {
  // CRITICAL CHANGE 1: Accept the starting track index
  final int initialTrackIndex;

  const AudioPlayerScreen({Key? key, required this.initialTrackIndex})
    : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;

  /// Combines the three necessary streams for the slider (position, buffer, duration)
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration?, Duration?, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position ?? Duration.zero,
          bufferedPosition ?? Duration.zero,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  /// Initializes the audio player with the local asset playlist, starting at the selected index.
  Future<void> _initAudioPlayer() async {
    // 1. Map the imported constant list to a list of AudioSource objects
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: false,
      children: podcastTracks
          .map((track) => AudioSource.asset(track['path']!))
          .toList(),
    );

    try {
      // CRITICAL CHANGE 2: Set initialIndex using the value passed from the selection screen
      await _audioPlayer.setAudioSource(
        playlist,
        initialIndex: widget.initialTrackIndex,
      );
      // Start playing immediately on load
      _audioPlayer.play();
    } catch (e) {
      print("Error loading playlist: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Utility function to format Duration into MM:SS string
  String _formatDuration(Duration? duration) {
    if (duration == null) return '00:00';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  /// Builds the Skip Back, Play/Pause, and Skip Forward buttons
  Widget _buildControlButtons() {
    return StreamBuilder<PlayerState>(
      stream: _audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing ?? false;

        Widget playPauseButton;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          playPauseButton = const SizedBox(
            width: 72.0,
            height: 72.0,
            child: CircularProgressIndicator(
              color: Color(0xFF1E88E5),
              strokeWidth: 4,
            ),
          );
        } else if (playing) {
          playPauseButton = IconButton(
            icon: const Icon(Icons.pause_circle_filled_rounded),
            iconSize: 72.0,
            color: const Color(0xFF1E88E5),
            onPressed: _audioPlayer.pause,
          );
        } else if (processingState != ProcessingState.completed) {
          playPauseButton = IconButton(
            icon: const Icon(Icons.play_circle_fill_rounded),
            iconSize: 72.0,
            color: const Color(0xFF1E88E5),
            onPressed: _audioPlayer.play,
          );
        } else {
          // Replay the first track when the playlist finishes
          playPauseButton = IconButton(
            icon: const Icon(Icons.replay_circle_filled_rounded),
            iconSize: 72.0,
            color: const Color(0xFF1E88E5),
            onPressed: () => _audioPlayer.seek(Duration.zero, index: 0),
          );
        }

        // Combine all control buttons
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous Button
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              iconSize: 48.0,
              color: Colors.blueGrey,
              onPressed: _audioPlayer.hasPrevious
                  ? _audioPlayer.seekToPrevious
                  : null,
            ),

            const SizedBox(width: 20),
            playPauseButton,
            const SizedBox(width: 20),

            // Next Button
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              iconSize: 48.0,
              color: Colors.blueGrey,
              onPressed: _audioPlayer.hasNext ? _audioPlayer.seekToNext : null,
            ),
          ],
        );
      },
    );
  }

  /// Builds the current track title display using a StreamBuilder
  Widget _buildCurrentTrackInfo() {
    return StreamBuilder<int?>(
      stream: _audioPlayer.currentIndexStream,
      builder: (context, snapshot) {
        // Use the actual current index if available, otherwise default to the index passed in
        final index = snapshot.data ?? widget.initialTrackIndex;

        // Ensure index is within bounds before accessing the list
        if (index < 0 || index >= podcastTracks.length) {
          return const Text('Loading Track...');
        }

        final track = podcastTracks[index];

        return Column(
          children: [
            const Text(
              'Current Episode:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              track['title']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Podcast Player',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album Art Placeholder
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.podcasts_rounded,
                size: 100,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 32),

            // Current Track Info
            _buildCurrentTrackInfo(),
            const SizedBox(height: 40),

            // Progress Slider and Timestamps (The Progress Line)
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final duration = positionData?.duration ?? Duration.zero;
                final position = positionData?.position ?? Duration.zero;

                return Column(
                  children: [
                    // Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8.0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 15.0,
                        ),
                        activeTrackColor: const Color(0xFF1E88E5),
                        inactiveTrackColor: Colors.blueGrey.shade100,
                        thumbColor: const Color(0xFF1E88E5),
                        overlayColor: const Color(0xFF1E88E5).withOpacity(0.3),
                      ),
                      child: Slider(
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                        value: position.inMilliseconds.toDouble().clamp(
                          0.0,
                          duration.inMilliseconds.toDouble(),
                        ),
                        onChanged: (double value) {
                          _audioPlayer.seek(
                            Duration(milliseconds: value.toInt()),
                          );
                        },
                      ),
                    ),
                    // Position and Duration Display
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),

            // Playback Controls (Previous, Play/Pause, Next)
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }
}

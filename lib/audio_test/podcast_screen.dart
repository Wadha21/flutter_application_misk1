import 'package:flutter/material.dart';

// Import data models
import '../models/podcast_tracks.dart';
import 'audio_player_screen.dart'; // Import the player screen to navigate to it

class TrackSelectionScreen extends StatelessWidget {
  const TrackSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Episode',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E88E5),
      ),
      body: ListView.builder(
        itemCount: podcastTracks.length,
        itemBuilder: (context, index) {
          final track = podcastTracks[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1E88E5).withOpacity(0.8),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  track['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Source: ${track['path']!}',
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                trailing: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF1E88E5),
                ),
                onTap: () {
                  // CRITICAL: Navigate to the player screen and pass the selected index
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AudioPlayerScreen(initialTrackIndex: index),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

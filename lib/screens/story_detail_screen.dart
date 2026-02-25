import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/ story.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });
  }

  Future<void> _play() async {
    await _audioPlayer.play(
      AssetSource(widget.story.audio.replaceFirst('assets/', '')),
    );
    setState(() => isPlaying = true);
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    setState(() => isPlaying = false);
  }

  Future<void> _seekForward() async {
    final newPosition = position + const Duration(seconds: 10);
    await _audioPlayer.seek(newPosition < duration ? newPosition : duration);
  }

  Future<void> _seekBackward() async {
    final newPosition = position - const Duration(seconds: 10);
    await _audioPlayer.seek(
      newPosition > Duration.zero ? newPosition : Duration.zero,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: widget.story.image,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.story.image,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.story.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble().clamp(
                0,
                duration.inSeconds.toDouble(),
              ),
              onChanged: (value) async {
                await _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  iconSize: 40,
                  onPressed: _seekBackward,
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 70,
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    isPlaying ? _pause() : _play();
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  iconSize: 40,
                  onPressed: _seekForward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

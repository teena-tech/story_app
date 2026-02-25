import 'package:flutter/material.dart';

import '../ widgets/story_card.dart';
import '../models/ story.dart';
import '../services/story_service.dart';

import 'story_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final StoryService _storyService = StoryService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stories"),
        backgroundColor: Colors.greenAccent,
      ),
      body: FutureBuilder<List<Story>>(
        future: _storyService.loadStories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No stories found"));
          }

          final stories = snapshot.data!;

          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return StoryCard(
                story: stories[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryDetailScreen(story: stories[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

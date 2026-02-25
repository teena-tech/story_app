import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/ story.dart';

class StoryService {
  Future<List<Story>> loadStories() async {
    final String jsonString = await rootBundle.loadString(
      'assets/stories.json',
    );

    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.map((e) => Story.fromJson(e)).toList();
  }
}

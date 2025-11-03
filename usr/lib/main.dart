import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watch Together App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WatchTogetherScreen(),
    );
  }
}

class WatchTogetherScreen extends StatefulWidget {
  const WatchTogetherScreen({super.key});

  @override
  State<WatchTogetherScreen> createState() => _WatchTogetherScreenState();
}

class _WatchTogetherScreenState extends State<WatchTogetherScreen> {
  late YoutubePlayerController _controller;
  final List<String> _participants = ['Alice', 'Bob', 'You']; // Mock participants
  final List<String> _chatMessages = [
    'Alice: Loving this video!',
    'Bob: Me too, great choice!',
    'You: Agreed!',
  ]; // Mock chat

  @override
  void initState() {
    super.initState();
    // Sample YouTube video ID (replace with dynamic input later)
    _controller = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ', // Example: Never Gonna Give You Up
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addChatMessage(String message) {
    setState(() {
      _chatMessages.add('You: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Together'),
        actions: [
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () async {
              // Placeholder for switching to Vimeo/Netflix (opens in browser)
              const url = 'https://vimeo.com/'; // Example
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
            tooltip: 'Switch to Vimeo/Netflix',
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blue,
          ),
          const Divider(),
          // Participants
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Watching with: ', style: TextStyle(fontWeight: FontWeight.bold)),
                ..._participants.map((name) => Chip(label: Text(name))).toList(),
              ],
            ),
          ),
          const Divider(),
          // Chat Section
          Expanded(
            child: Column(
              children: [
                const Text('Group Chat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: _chatMessages.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(_chatMessages[index]));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(hintText: 'Type a message...'),
                          onSubmitted: _addChatMessage,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          // TODO: Send message to Supabase for real-time sync
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
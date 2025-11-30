import 'package:dia_assist/pages/home/home_page.dart';
import 'package:dia_assist/pages/prediction_page/prediction_screen_display.dart';
import 'package:dia_assist/themes/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DiabetesChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Chatbot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DiabetesChatScreen(),
    );
  }
}

class DiabetesChatScreen extends StatefulWidget {
  @override
  _DiabetesChatScreenState createState() => _DiabetesChatScreenState();
}

class _DiabetesChatScreenState extends State<DiabetesChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  // Replace with your SerpAPI key
  final String _apiKey = '4abeab28090e5192ac804d8e51e6162d7f0348579954e5a832f6aae0b57d0910';

  bool _isLoading = false;

  // Send message to the bot and fetch response
  void _sendMessage(String userMessage) {
    if (userMessage.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'message': userMessage});
      _isLoading = true;
    });

    _controller.clear();
    _fetchDiabetesRelatedResults(userMessage);
  }

  // Fetch diabetes-related search results from SerpAPI
  Future<void> _fetchDiabetesRelatedResults(String query) async {
    final String apiUrl = 'https://serpapi.com/search';

    final queryParameters = {
      'q': 'diabetes $query', // Prefix query with "diabetes" to filter results
      'hl': 'en', // Language (English)
      'gl': 'us', // Country (United States)
      'api_key': _apiKey,
      'num': '5', // Number of results to fetch
      'engine': 'google', // Search engine
      'start': '0', // Pagination (offset)
    };

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final searchResults = responseBody['organic_results'] as List;

        if (searchResults.isNotEmpty) {
          final combinedResponse = _generateBotResponse(searchResults);
          setState(() {
            messages.add({'role': 'bot', 'message': combinedResponse});
          });
        } else {
          _showError('Sorry, I couldn\'t find relevant information about diabetes.');
        }
      } else {
        _showError('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Generate a more human-like response by combining search result snippets in point-wise format
  String _generateBotResponse(List searchResults) {
    List<String> snippets = [];
    for (var result in searchResults) {
      final snippet = result['snippet'] ?? '';
      if (snippet.isNotEmpty) {
        snippets.add(snippet);
      }
    }

    if (snippets.isEmpty) {
      return "Sorry, I couldn't find relevant information. Please try asking in a different way.";
    }

    // Combine snippets into a point-wise response
    String response = "Here's what I found about diabetes:\n";
    for (int i = 0; i < snippets.length; i++) {
      response += "${i + 1}. ${snippets[i]}\n";
    }
    return response;
  }

  // Show error message if something goes wrong
  void _showError(String message) {
    setState(() {
      messages.add({'role': 'bot', 'message': message});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 10, 63, 94),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.to(HomePage());
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          title: Text(
            'Diabetes Chatbot',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: AppColors.background),
          ),
        ),
        body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message['role'] == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!isUser) // Bot icon
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: const Icon(Icons.smart_toy, color: Color.fromARGB(255, 10, 63, 94),),
                              ),
                            ),
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUser ? Colors.blue : Colors.white24,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message['message']!,
                                style: TextStyle(
                                    color: isUser ? Colors.white : Colors.white),
                              ),
                            ),
                          ),
                          if (isUser) // User icon
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: const Icon(Icons.person, color:Color.fromARGB(255, 10, 63, 94),),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Fetching diabetes-related information...',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: 'Ask me anything about diabetes...',
                            hintStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white24),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        _sendMessage(_controller.text.trim());
                      },
                    ),
                  ],
                ),
              ),
            ],
            ),
        );
    }
}

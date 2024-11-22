// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  String _definition = '';
  String _phonetic = '';
  String _partOfSpeech = '';

  Future<void> _fetchDefiniton(String word) async {
    try {
      final response = await http.get(
          Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/${word}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            _definition =
                data[0]['meanings'][0]['definitions'][0]['definition'];
            _phonetic = data[0]['phonetic'] ?? 'No phonetic Available';

            _partOfSpeech = data[0]['meanings'][0]['partOfSpeech'] ?? 'N/A';
          });
        } else {
          setState(() {
            _definition = 'definition not found';
            _phonetic = '';
            _partOfSpeech = '';
          });
        }
      }
    } catch (e) {
      setState(() {
        _definition = 'error: ${e}';
        _phonetic = '';
        _partOfSpeech = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child:
                Text('Dictionary app', style: TextStyle(color: Colors.white))),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Search Word!',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: screenWidth * 0.05),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _fetchDefiniton(_controller.text);
                      },
                      icon: Icon(Icons.search, size: 40, color: Colors.white))
                ],
              ),
            ),
          ),
          SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.only(left:18.0),
            child: Text(_controller.text,
              style: TextStyle(fontSize: screenWidth * 0.1),
            ),
          ),
          SizedBox(height: 10),
           Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              _phonetic,
              style: TextStyle(fontSize: 19),
            ),
          ),
          SizedBox(height: 10),
           Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              _partOfSpeech,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:18.0, top: 10),
            child: Text(_definition),
                )
        ],
      ),
    );
  }
}

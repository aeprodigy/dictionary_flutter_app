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
  bool _isLoading = false;

  //the method to fetch the definition
  Future<void> _fetchDefinition(String word) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
          Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            _definition =
                data[0]['meanings'][0]['definitions'][0]['definition'];
          });
        } else {
          setState(() {
            _definition = 'The meaning is not found';
          });
        }
      }
    } catch (e) {
      setState(() {
        _definition = 'Error something went wrong';
      });
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'D E F I N E',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            //the textfield
            // Row for the TextField and Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Expanded allows the TextField to take up available space
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Please enter word',

                        hintStyle: TextStyle(
                            color: Colors.grey[400]), // Custom hint text color
                        filled: true,
                        fillColor: Colors
                            .grey[100], // Background color for the TextField
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10), // Padding inside the TextField
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              5), // Border radius for the TextField
                          borderSide: BorderSide(
                            color: Colors
                                .grey.shade300, // Border color when not focused
                            width: 1, // Border width
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              5), // Border radius for focused state
                          borderSide: BorderSide(
                            color: Colors
                                .green.shade400, // Border color when focused
                            width: 2, // Border width when focused
                          ),
                        ),
                      ),
                      style: TextStyle(color: Colors.green[400]),
                    ),
                  ),
                  const SizedBox(
                      width:
                          10), // Add some space between the TextField and Button
                  ElevatedButton(
                    onPressed: () {
                      _fetchDefinition(_controller.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.grey[400],
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.zero, // Removes border radius
                      ),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.green[300]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //the results
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _definition != null && _definition.isNotEmpty
                    ? Container(
                        height: 100,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                offset: Offset(5, 5),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _definition,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[500]),
                            ),
                          ),
                        ),
                      )
                    : Text(''),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

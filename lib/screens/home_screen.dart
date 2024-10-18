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
  String _secondDef = '';
  bool _isLoading = false;

  //the method to fetch the definition
  Future<void> _fetchDefinition(String word) async {
    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        setState(() {
          _definition = data[0]['meanings'][0]['definitions'][0]['definition'];
          _secondDef =  data[0]['meanings'][1]['definitions'][1]['definition'];
        });
      } else {
        setState(() {
          _definition = 'The meaning is not found';
        });
      }
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
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Please enter word',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //the btn
            ElevatedButton(
              onPressed: () {
                _fetchDefinition(_controller.text);
              },
              child: Text('Search'),
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
                        color: Colors.grey[100],
                        child: Center(
                          child: Text(
                            _definition,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[500]),
                          ),
                        ),
                      )
                    : Text(''),
                SizedBox(
                  height: 20,
                ),
                _secondDef != null && _secondDef.isNotEmpty ?
               Container(
                height: 100,
                width: 300,
                color: Colors.grey[100],
                 child: Center(
                   child: Text(
                      _secondDef,
                      style:  TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[500]),
                    ),
                 ),
               ) : Text('') 
                ,
              ],
            )
          ],
        ),
      ),
    );
  }
}

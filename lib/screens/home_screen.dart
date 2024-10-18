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
    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        setState(() {
          _definition = data[0]['meanings'][0]['definitions'][0]['definition'];
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
        title: const Center(child: Text('D E F I N E', style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            //the textfield
            TextField(
              controller: _controller,
              decoration:const InputDecoration(
                hintText: 'Please enter word',
              ),
            ),
           const SizedBox(height: 20,),
            //the btn
            ElevatedButton(
                onPressed: () {
                  _fetchDefinition(_controller.text);
                },
                child: Text('Search'),),
               const SizedBox(
              height: 20,
            ),
            //the results
            Text(_definition, style:const TextStyle(fontStyle:FontStyle.italic),),
          ],
        ),
      ),
    );
  }
}

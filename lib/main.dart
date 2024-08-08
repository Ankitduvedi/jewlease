import 'package:flutter/material.dart';
import 'package:jewlease/apiservice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              apiService.fetchData();
            },
            child: Text('Fetch Data'),
          ),
        ),
      ),
    );
  }
}

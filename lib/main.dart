// Importing important packages require to connect
// Flutter and Dart
import 'package:flutter/material.dart';

// Main Function
void main() {
    
  // Giving command to runApp() to run the app.
  runApp(const MyApp());
}

// Widget is used to create UI in flutter framework.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        
      // title of the application
      title: 'Hello World Demo Application',
      
      // theme of the widget
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      
      // Inner UI of the application
      home: const MyHomePage(title: 'Home page'),
    );
  }
}

// This class is similar to MyApp instead it
// returns Scaffold Widget
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      
      // Sets the content to the
      // center of the application page
      body: const Center(
          
          // Sets the content of the Application
          child: Text(
        'Welcome to Android Studio!',
      )),
    );
  }
}

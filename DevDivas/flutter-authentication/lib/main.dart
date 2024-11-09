import 'package:flutter/material.dart';
import 'carasol.dart';
import 'login.dart'; // Import the MyAppPage file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIY App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CarouselWithIndicatorPage(), // Home screen as main page
        '/login': (context) => const LoginPage(), // Route to login page (MyAppPage)
      },
    );
  }
}

/// -----------------------------------
///             HomeScreen
/// -----------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Navigate to login page
          },
          child: const Text('Go to Login Page'),
        ),
      ),
    );
  }
}

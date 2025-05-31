import 'package:flutter/material.dart';
import 'package:responsi_prak_mobile/views/create_page.dart';
import 'package:responsi_prak_mobile/views/edit_page.dart';
import 'package:responsi_prak_mobile/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/create' : (context) => CreatePage(),
        '/edit' : (context) => EditPage(),
      },
    );
  }
}

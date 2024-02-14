import 'package:flutter/material.dart';
import 'package:pass_gen_mobile/views/home_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PassGen Mobile',
      home: HomePage(),
    );
  }
}

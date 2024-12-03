import 'package:flutter/material.dart';
import 'package:ap2/widgets/character_list.dart'; // Import do novo widget

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personagens Marvel'),
      ),
      body: CharacterList(),
    );
  }
}

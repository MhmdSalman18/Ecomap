import 'package:flutter/material.dart';

class SelectAnimal extends StatefulWidget {
  const SelectAnimal({super.key, required this.title});

  final String title;

  @override
  State<SelectAnimal> createState() => _SelectAnimalState();
}

class _SelectAnimalState extends State<SelectAnimal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Select an animal'),
      ),
    );
  }
}

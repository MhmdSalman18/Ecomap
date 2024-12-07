import 'package:flutter/material.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(),
      body: Center(
        child: Column(
          children: [Text("heat map page")],
        ),
      ),
      
    );
  }
}
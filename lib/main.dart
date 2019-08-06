import 'package:flutter/material.dart';
import './Routes/MainRoute.dart';

// Main Method
void main() {
  runApp(
    MaterialApp(
      title: 'Movies Book',
      debugShowCheckedModeBanner: false,
      home: MainRouteUI(),
    ),
  );
}

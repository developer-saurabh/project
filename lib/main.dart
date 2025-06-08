import 'package:flutter/material.dart';
import 'package:project/dashboard_screen.dart';
import 'review_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: AcademicDashboard(),
    ),
  );
}

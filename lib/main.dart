import 'package:app/bluetooth.dart';
import 'package:flutter/material.dart';

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
    home: BluetoothScreen(),
    );
  }
}

// package 
//  permission_handler: ^11.0.0
//   flutter_reactive_ble: ^5.4.0

//Permission in manifest
    //  <uses-permission android:name="android.permission.BLUETOOTH"/>
    // <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
    // <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    // <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
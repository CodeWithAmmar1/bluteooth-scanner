import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

final flutterReactiveBle = FlutterReactiveBle();

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<DiscoveredDevice> devicesList = [];
  StreamSubscription? _scanSubscription;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      log(" Location permission granted");
    } else {
      log(" Location permission denied");
    }
  }

  void scanDevices() {
    if (isScanning) return; // Prevent multiple scans at once
    log("Scanning for devices...");
    devicesList.clear();
    isScanning = true;
    setState(() {});

    _scanSubscription = flutterReactiveBle
        .scanForDevices(withServices: [])
        .listen(
          (device) {
            if (!devicesList.any((d) => d.id == device.id)) {
              setState(() {
                devicesList.add(device);
              });
            }
          },
          onError: (error) {
            log(" Error scanning: $error");
          },
        );

    // Stop scanning after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      _scanSubscription?.cancel();
      isScanning = false;
      setState(() {});
      log(" Scan complete. Found ${devicesList.length} devices.");
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bluetooth Scanner",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
   body: Column(
  children: [
    Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        "Devices Found: ${devicesList.length}",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Expanded(
      child: devicesList.isEmpty
          ? Center(
              child: Text(
                isScanning
                    ? "Scanning for devices..."
                    : "No devices found.\nTap the button to scan.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                final device = devicesList[index];
                return Card(
                  color: Colors.blueGrey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.bluetooth, color: Colors.lightBlue),
                    title: Text(
                      device.name.isNotEmpty ? device.name : "Unknown Device",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      device.id,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    ),
  ],
),

      floatingActionButton: FloatingActionButton(
        onPressed: scanDevices,
        backgroundColor: isScanning ? Colors.grey : Colors.blueAccent,
        child:
            isScanning
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.bluetooth, color: Colors.white),
      ),
    );
  }
}

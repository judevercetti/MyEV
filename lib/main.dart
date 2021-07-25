import 'package:flutter/material.dart';
import 'package:myev/pages/battery_health_page.dart';
import 'package:myev/pages/charging_status_page.dart';
import 'package:myev/pages/login_page.dart';
import 'package:myev/pages/temperature_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
  // FirebaseFirestore.instance.enableNetwork();
  runApp(const MyEV());
}

class MyEV extends StatelessWidget {
  const MyEV({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentPageIndex = 1;
  final _allPages = [
    const TemperaturePage(title: "Temperature"),
    const ChargingStatusPage(title: "Charging Status"),
    const BatteryHealthPage(title: "Battery Health")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        selectedItemColor: Colors.green,
        onTap: (value) {
          setState(() {
            _currentPageIndex = value;
          });
        },
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: "Temperature",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.battery_charging_full_rounded),
            label: "Charging Status",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Battery Health",
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _allPages,
      ),
    );
  }
}

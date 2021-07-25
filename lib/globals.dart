import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myev/pages/login_page.dart';

var currentVehicle = "EV001";

void setCurrentVehicle(id) {
  currentVehicle = id;
}

popupMenuButton(context) => PopupMenuButton(
      itemBuilder: (BuildContext bc) => const [
        PopupMenuItem(child: Text("Account"), value: "account"),
        PopupMenuItem(child: Text("Settings"), value: "settings"),
        PopupMenuItem(child: Text("Logout"), value: "logout"),
      ],
      onSelected: (route) {
        // Note You must create respective pages for navigation
        if (route == 'logout') pushPage(context, const LoginPage());
      },
    );

Stream<DocumentSnapshot<Map<String, dynamic>>> vehicleSnapshots =
    FirebaseFirestore.instance.collection('vehicles').doc("EV001").snapshots();

Stream<QuerySnapshot<Map<String, dynamic>>> historySnapshots = FirebaseFirestore
    .instance
    .collection('vehicles')
    .doc("EV001")
    .collection('history')
    .snapshots();

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false);
}

void addPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
}

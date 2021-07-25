import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myev/globals.dart';

class BatteryHealthPage extends StatefulWidget {
  const BatteryHealthPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BatteryHealthPage> createState() => _BatteryHealthPageState();
}

class _BatteryHealthPageState extends State<BatteryHealthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey.shade300,
        leading: const Icon(Icons.home),
        title: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(widget.title),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(30.0))),
          ),
        ),
        actions: [popupMenuButton(context)],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: vehicleSnapshots,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var _currentData = snapshot.data!;
            var _batteryHealth,
                _batteryHealthRange,
                _internalResistance,
                _resistancePercentage = 0;

            // try {
            _batteryHealth =
                _currentData.get('current_charge')['battery_health'];
            _batteryHealthRange =
                _currentData.get('current_charge')['battery_health_range'];
            _internalResistance = _currentData.get('internal_resistance');
            _resistancePercentage = _currentData.get('resistance_percentage');
            // } on StateError catch (_, e) {
            //   return Center(
            //     child: Column(children: const [
            //       Spacer(),
            //       Icon(
            //         Icons.cloud_download_outlined,
            //         size: 50.0,
            //       ),
            //       Text("You appear to be offline"),
            //       Spacer(),
            //     ]),
            //   );
            // }

            return Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.battery_saver_rounded,
                              color: Colors.greenAccent,
                              size: 100,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                "$_batteryHealth",
                                textScaleFactor: 1.8,
                              ),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                            ),
                            Text(
                              "Battery is $_batteryHealthRange",
                              textScaleFactor: 1.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    child: Center(
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            "Health Details",
                            style: TextStyle(
                              height: 3.0,
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.all(20.0),
                                  child: const Text(
                                      "Current Internal Resistance:"),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "$_internalResistance Ω",
                                    style: const TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.all(20.0),
                                  child: const Text("Resistance percentage:"),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "$_resistancePercentage%",
                                    style: const TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(20.0),
                                  child: LinearProgressIndicator(
                                    color: Colors.green,
                                    value: _resistancePercentage / 100,
                                    minHeight: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

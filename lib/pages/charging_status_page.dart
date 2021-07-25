import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myev/globals.dart';
import 'package:myev/pages/charging_history_page.dart';
import 'package:myev/pages/login_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChargingStatusPage extends StatefulWidget {
  const ChargingStatusPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChargingStatusPage> createState() => _ChargingStatusPageState();
}

class _ChargingStatusPageState extends State<ChargingStatusPage> {
  var _isCharging = false;
  late DocumentSnapshot<Object?> _currentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey.shade300,
        leading: TextButton(onPressed: () {}, child: const Text("MyEV")),
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
            return const Text("Loading");
          }

          _currentData = snapshot.data!;
          var _chargeDuration = null;

          try {
            if (_currentData.get('command') == 'charge_started') {
              _isCharging = true;
            } else if (_currentData.get('command') == 'charge_stopped') {
              _isCharging = false;

              _chargeDuration = _currentData
                  .get('current_charge')['stop']
                  .toDate()
                  .difference(
                      _currentData.get('current_charge')['start'].toDate());
              _chargeDuration = _chargeDuration.inSeconds < 60
                  ? "${_chargeDuration.inSeconds} seconds"
                  : _chargeDuration.inMinutes < 60
                      ? "${_chargeDuration.inMinutes} minutes"
                      : "${_chargeDuration.inHours} hours and ${_chargeDuration.inMinutes.remainder(60)} minutes";
            }
          } on StateError catch (_, e) {
            return Center(
              child: Column(
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.cloud_download_outlined,
                    size: 50.0,
                  ),
                  const Text("You appear to be offline"),
                  const Spacer(),
                  Container(
                    color: Colors.white,
                    child: Row(children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => addPage(
                              context,
                              const ChargingHistoryPage(
                                  title: "Charging History")),
                          child: const Text("Charging History"),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.grey.shade700),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 30.0,
                        width: 1.0,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text("Retry"),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            );
          }

          return Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isCharging
                                ? Icons.battery_charging_full
                                : Icons.battery_full,
                            color: Colors.greenAccent,
                            size: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              " ${_currentData.get('battery_percentage')}% full",
                              textScaleFactor: 1.8,
                            ),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                          ),
                          Text(
                            _isCharging
                                ? "${_currentData.get('current_charge')['time_left']}"
                                : "Charging stopped",
                            textScaleFactor: 1.5,
                            style: TextStyle(
                                color: _isCharging ? Colors.black : Colors.red),
                          ),
                          if (_isCharging)
                            const Text("until fully charged.")
                          else
                            Text("after $_chargeDuration"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    child: SingleChildScrollView(
                        child: _isCharging
                            ? chargingDetailsTrue()
                            : chargingDetailsFalse()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget chargingDetailsTrue() {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const Text(
          "Charging Details",
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
              child: Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text("Battery Voltage:"),
                    Text(
                      "${_currentData.get('battery_voltage')}V",
                      textScaleFactor: 3,
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text("Charging Current:"),
                    Text(
                      "${_currentData.get('current_charge')['battery_current']}A",
                      textScaleFactor: 3,
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    )
                  ],
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
                child: TextButton(
                  onPressed: () => addPage(context,
                      const ChargingHistoryPage(title: "Charging History")),
                  child: const Text("Charging History"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade700),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        title: const Text("Stop Charging"),
                        content: const Text(
                            "Are you sure you want to stop charging"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('vehicles')
                                  .doc('EV001')
                                  .update({
                                'command': 'stop_charge',
                                'current_charge.stop':
                                    FieldValue.serverTimestamp(),
                                'current_charge.final_percentage':
                                    _currentData.get('battery_percentage'),
                              }).then((value) => Navigator.pop(context));
                              // setState(() {
                              //   _isCharging = false;
                              // });
                            },
                            child: const Text("Stop"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Stop Charging"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget chargingDetailsFalse() {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const Text(
          "Charging Details",
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
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: const Text("Date:"),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  DateFormat("d MMMM, y").format(
                      _currentData.get('current_charge')['start'].toDate()),
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: const Text("Charged from:"),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  "${DateFormat("h:mm a").format(_currentData.get('current_charge')['start'].toDate())} - ${DateFormat("h:mm a").format(_currentData.get('current_charge')['stop'].toDate())}",
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: const Text("Initial percentage:"),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  "${_currentData.get('current_charge')['initial_percentage']}%",
                  style: const TextStyle(
                    color: Colors.red,
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: const Text("Final percentage:"),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  "${_currentData.get('current_charge')['final_percentage']}%",
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: const Text("Avg. system temp:"),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  "${_currentData.get('current_charge')['avg_system_temp']}",
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: const Text("Battery health:"),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  "${_currentData.get('current_charge')['battery_health']}",
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
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: TextButton(
                  onPressed: () => addPage(context,
                      const ChargingHistoryPage(title: "Charging History")),
                  child: const Text("Charging History"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade700),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('vehicles')
                        .doc('EV001')
                        .update({
                      'command': 'start_charge',
                    });
                    // setState(() {
                    //   _isCharging = true;
                    // });
                  },
                  child: const Text("Resume Charging"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ChargingStatusPage extends StatefulWidget {
  const ChargingStatusPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChargingStatusPage> createState() => _ChargingStatusPageState();
}

class _ChargingStatusPageState extends State<ChargingStatusPage> {
  var _isCharging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey.shade300,
        leading: TextButton(onPressed: () {}, child: const Text("EV")),
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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
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
                        child: const Text(
                          "75% full",
                          textScaleFactor: 1.8,
                        ),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                      ),
                      Text(
                        _isCharging
                            ? "1 hour and 30 minutes"
                            : "Charging has been stopped",
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: _isCharging ? Colors.black : Colors.red),
                      ),
                      if (_isCharging)
                        const Text("until fully charged.")
                      else
                        const Text("after 1 hour and 30 minutes"),
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
                    const Text(
                      "198V",
                      textScaleFactor: 3,
                      style: TextStyle(
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
                    const Text(
                      "12A",
                      textScaleFactor: 3,
                      style: TextStyle(
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
                  onPressed: () {},
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
                              setState(() {
                                _isCharging = false;
                                Navigator.pop(context);
                              });
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
                child: const Text(
                  "1st May, 2021",
                  style: TextStyle(
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
                child: const Text(
                  "12:00pm - 01:50pm",
                  style: TextStyle(
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
                child: const Text(
                  "30%",
                  style: TextStyle(
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
                child: const Text(
                  "75%",
                  style: TextStyle(
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
                child: const Text(
                  "22 ºC (Normal)",
                  style: TextStyle(
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
                child: const Text(
                  "98% (Good)",
                  style: TextStyle(
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
                  onPressed: () {},
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
                    setState(() {
                      _isCharging = true;
                    });
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

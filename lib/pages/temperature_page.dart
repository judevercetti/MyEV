import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../globals.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
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
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              var _currentData = snapshot.data!;
              var _battery_temperature = 0.0;
              var _battery_temperature_range = null;

              try {
                _battery_temperature =
                    _currentData.get('current_charge')['avg_system_temp'];
                _battery_temperature_range = _currentData
                    .get('current_charge')['battery_temperature_range'];
              } on StateError catch (_, e) {
                return Center(
                  child: Column(children: const [
                    Spacer(),
                    Icon(
                      Icons.cloud_download_outlined,
                      size: 50.0,
                    ),
                    Text("You appear to be offline"),
                    Spacer(),
                  ]),
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
                              const Spacer(),
                              Expanded(
                                flex: 4,
                                child: SfRadialGauge(axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: -20,
                                      maximum: 100,
                                      ranges: <GaugeRange>[
                                        GaugeRange(
                                            startValue: -20,
                                            endValue: 0,
                                            color: Colors.blue),
                                        GaugeRange(
                                            startValue: 0,
                                            endValue: 50,
                                            color: Colors.green),
                                        GaugeRange(
                                            startValue: 50,
                                            endValue: 80,
                                            color: Colors.orange),
                                        GaugeRange(
                                            startValue: 80,
                                            endValue: 100,
                                            color: Colors.red)
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(
                                            value: _battery_temperature)
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            widget: Text(
                                                '$_battery_temperature ºC',
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            angle: 90,
                                            positionFactor: 0.5)
                                      ])
                                ]),
                              ),
                              const Text(
                                "EV Battery Temp",
                                textScaleFactor: 1.5,
                              ),
                              Text("$_battery_temperature_range"),
                              const Spacer(),
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
                          children: [
                            const Text(
                              "Temperature Details",
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
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(20.0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text("Temperature range:"),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(20.0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "$_battery_temperature_range",
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         margin: const EdgeInsets.all(20.0),
                            //         child: const LinearProgressIndicator(
                            //           color: Colors.green,
                            //           value: 0.4,
                            //           minHeight: 20.0,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}

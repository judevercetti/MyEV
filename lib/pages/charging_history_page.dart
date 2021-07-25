import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myev/globals.dart';

class ChargingHistoryPage extends StatefulWidget {
  const ChargingHistoryPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChargingHistoryPage> createState() => _ChargingHistoryPageState();
}

class _ChargingHistoryPageState extends State<ChargingHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
      body: StreamBuilder<QuerySnapshot>(
          stream: historySnapshots,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot history) {
              return ListTile(
                title: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(DateFormat("d MMMM, y")
                                .format(history.get('start').toDate())),
                          ),
                          const Icon(Icons.thermostat, color: Colors.green),
                          Text("${history.get('avg_system_temp')} ºC"),
                        ],
                      ),
                      const Divider(color: Colors.black),
                      Row(
                        children: [
                          const SizedBox(width: 40),
                          const Expanded(
                            child: Text("Starting percentage:"),
                          ),
                          Text("${history.get('initial_percentage')}%"),
                        ],
                      ),
                      const Divider(color: Colors.black),
                      Row(
                        children: [
                          const SizedBox(width: 40),
                          const Expanded(
                            child: Text("Final percentage:"),
                          ),
                          Text("${history.get('final_percentage')}%"),
                        ],
                      ),
                      const Divider(color: Colors.black),
                      Row(
                        children: [
                          const Icon(Icons.watch_outlined),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                                "${DateFormat("h:mm a").format(history.get('start').toDate())} - ${DateFormat("h:mm a").format(history.get('stop').toDate())}"),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("More Details"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList());
          }),
    );
  }
}

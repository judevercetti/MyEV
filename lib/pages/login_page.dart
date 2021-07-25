import 'package:flutter/material.dart';
import 'package:myev/globals.dart';
import 'package:myev/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  var _incorrectCreditials = false;

  @override
  void initState() {
    super.initState();
    _controllerID.addListener(() {
      setState(() {
        _incorrectCreditials = false;
      });
      final String text = _controllerID.text.trim().toUpperCase();
    });
    _controllerPass.addListener(() {
      setState(() {
        _incorrectCreditials = false;
      });
      final String text = _controllerID.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            const Expanded(
              child: Text(
                "MyEV",
                textScaleFactor: 3,
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Image.asset("assets/images/logo.jpg", fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(30.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                children: [
                  TextField(
                    controller: _controllerID,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      labelText: 'Vehicle ID',
                      hintText: 'Enter  Vehicle ID',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _controllerPass,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  if (_incorrectCreditials)
                    const Text(
                      "Incorect credentials",
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("CANCEL"),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextButton(
                      onPressed: () => loginUser(),
                      child: const Text("LOGIN"),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.shade700),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  loginUser() {
    setState(() {
      _incorrectCreditials = false;
    });

    if (_controllerID.text.isEmpty && _controllerPass.text.isEmpty) {
      setState(() {
        _incorrectCreditials = true;
      });
      return;
    }

    FirebaseFirestore.instance
        .collection('vehicles')
        .doc(_controllerID.text.toUpperCase())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data()! as Map<String, dynamic>;
        if (data['password'] == _controllerPass.text) {
          setCurrentVehicle(_controllerID.text);

          pushPage(context, const MyHomePage());
        } else {
          setState(() {
            _incorrectCreditials = true;
          });
        }
      } else {
        setState(() {
          _incorrectCreditials = true;
        });
      }
    });
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    //   CollectionReference<Map<String, dynamic>> _vehicles =
    //       FirebaseFirestore.instance.collection('vehicles');

    //   return FutureBuilder<DocumentSnapshot>(
    //     future: _vehicles.doc("EV001").get(),
    //     builder:
    //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.hasError) {
    //         return const Text("Something went wrong");
    //       }

    //       if (snapshot.hasData && !snapshot.data!.exists) {
    //         return const Text("Document does not exist");
    //       }

    //       if (snapshot.connectionState == ConnectionState.done) {
    //         Map<String, dynamic> data =
    //             snapshot.data!.data() as Map<String, dynamic>;
    //         return Text("Full Name: ${data['full_name']} ${data['last_name']}");
    //       }

    //       return const Text("loading");
    //     },
    //   );
  }
}

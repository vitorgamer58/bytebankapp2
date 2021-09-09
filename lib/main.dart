import 'package:bytebank2/http/webclient.dart';
import 'package:bytebank2/screens/dashboard.dart';
import 'package:flutter/material.dart';

import 'models/contact.dart';
import 'models/transaction.dart';


void main() {
  runApp(BytebankApp());
  //save(Transaction(200.0, Contact(0, 'Joao', 2000))).then((transaction) => print(transaction));
  //findAll().then((transactions) => print('new transactions $transactions'));
}

class BytebankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
        accentColor: Colors.blueAccent[700],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Dashboard(),
    );
  }
}




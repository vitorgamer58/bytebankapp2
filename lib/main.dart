import 'package:bytebank2/components/transaction_auth_dialog.dart';
import 'package:bytebank2/http/webclient.dart';
import 'package:bytebank2/models/saldo.dart';
import 'package:bytebank2/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'components/saldo.dart';
import 'models/contact.dart';
import 'models/transaction.dart';


void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Saldo(0),
    child: BytebankApp(),
  ));
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




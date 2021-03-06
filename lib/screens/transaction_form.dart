import 'dart:async';

import 'package:bytebank2/components/response_dialog.dart';
import 'package:bytebank2/components/transaction_auth_dialog.dart';
import 'package:bytebank2/http/webclient.dart';
import 'package:bytebank2/http/webclients/transaction_webclient.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/models/transaction.dart';
import 'package:bytebank2/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = Uuid().v4();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(
                    message: 'Sending...',
                  ),
                ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      if (value == null) {
                        // Protege a API de uma entrada inv??lida, como um valor null.
                        // Existe o null check no flutter >2.0.0
                        // Portanto, sem esse IF o erro seria de nullcheck, n??o chegaria a bater na API
                        // Mas ficaria sem resposta para o usu??rio.
                        showDialog(
                            context: context,
                            builder: (contextDialog) {
                              return AlertDialog(
                                title: Text('Valor incorreto'),
                                content: Text(
                                    'O valor da transa????o n??o pode ser vazio!'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Entendido'))
                                ],
                              );
                            });
                      }
                      final transactionCreated =
                          Transaction(transactionId, value!, widget.contact);
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                _save(transactionCreated, password, context);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password,
      BuildContext context) async {
    setState(() {
      _sending = true;
    });
    await _send(
      transactionCreated,
      password,
      context,
    );
    // setState(() {
    //   _sending = false;
    // });
  }

  Future<void> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    await Future.delayed((Duration(seconds: 1)));
    _webClient.save(transactionCreated, password).then((transactionReceived) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('sucessful transaction');
          }).then((value) => Navigator.pop(context));
    }).catchError((e) {
      _showFailureMessage(context,
          message:
              'Timeout, o sistema est?? fora do ar ou voc?? est?? sem conex??o com a internet');
    }, test: (e) => e is TimeoutException).catchError((err) {
      print('Ocorreu um erro $err');
      _showFailureMessage(context, message: err.message);
    }, test: (err) => err is HttpException).catchError((err) {
      // Se n??o for um TimeoutException ou HttpException -> ent??o cai no erro desconhecido!
      // O erro desconecido ?? algo inesperado!
      _showFailureMessage(context, message: 'Unknown Error');
    }).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknown Error'}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}

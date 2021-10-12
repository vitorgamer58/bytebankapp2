import 'package:bytebank2/models/saldo.dart';
import 'package:bytebank2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:bytebank2/components/response_dialog.dart';
import 'package:bytebank2/components/transaction_auth_dialog.dart';
import 'package:bytebank2/http/webclient.dart';
import 'package:bytebank2/http/webclients/transaction_webclient.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/models/transaction.dart';
import 'package:bytebank2/widgets/progress.dart';
import 'package:provider/provider.dart';

const _tituloAppBar = 'Depósito';
const _dicaCampoValor = '0.00';

class FormularioDeposito extends StatefulWidget {
  @override
  _FormularioDepositoState createState() => _FormularioDepositoState();
}

class _FormularioDepositoState extends State<FormularioDeposito> {
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "NúmeroConta?",
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
                    child: Text('Depositar'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      if (value == null) {
                        showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return AlertDialog(
                              title: Text('Valor incorreto'),
                              content: Text(
                                  'O valor da transação não pode ser vazio!'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Entendido'),
                                )
                              ],
                            );
                          },
                        );
                      }
                      _criaDeposito(context, value);
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
}

void _criaDeposito(BuildContext context, value) {
  Provider.of<Saldo>(context, listen: false).adiciona(value);

  Navigator.pop(context);
}

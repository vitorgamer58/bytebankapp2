import 'package:bytebank2/models/transaction.dart';
import 'package:flutter/material.dart';

const _tituloAppBar = 'Depósito';
const _dicaCampoValor = '0.00';

class FormularioDeposito extends StatelessWidget {
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
                        // Protege a API de uma entrada inválida, como um valor null.
                        // Existe o null check no flutter >2.0.0
                        // Portanto, sem esse IF o erro seria de nullcheck, não chegaria a bater na API
                        // Mas ficaria sem resposta para o usuário.
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
                                    child: Text('Entendido'))
                              ],
                            );
                          },
                        );
                      }
                      // final transactionCreated =
                      //     Transaction(transactionId, value!, widget.contact);
                      // showDialog(
                      //   context: context,
                      //   builder: (contextDialog) {
                      //     return TransactionAuthDialog(
                      //       onConfirm: (String password) {
                      //         _save(transactionCreated, password, context);
                      //       },
                      //     );
                      //   },
                      // );
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

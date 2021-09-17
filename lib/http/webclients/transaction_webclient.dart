import 'dart:convert';

import 'package:bytebank2/http/webclient.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/models/transaction.dart';
import 'package:http/http.dart';
import 'package:bytebank2/http/webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
    await client.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 5));
    List<Transaction> transactions = _toTransactions(response);
    return transactions;
    //print('decodedJson $decodedJson');
  }

  Future<Transaction> save(Transaction transaction, String password) async {

    Map<String, dynamic> transactionMap = _toMap(transaction);
    final String transactionJson = jsonEncode(transactionMap);

    final Response response = await client.post(Uri.parse('http://192.168.0.115:8080/transactions'), headers: {
      'Content-type': 'application/json',
      'password': password,
    }, body: transactionJson);

    if(response.statusCode == 200) {
      return _toTransaction(response);
    }

    _throwHttpError(response.statusCode);

    throw Exception('unknown'); // The body might complete normally, causing 'null' to be returned, but the return type is a potentially non-nullable type.

  }

  void _throwHttpError(int statusCode) => throw Exception(_statusCodeResponses[statusCode]);

  static final Map<int, String> _statusCodeResponses = {
    400 : 'Ocorreu um erro 400',
    401 : 'authentication failed'
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];
    for (Map<String, dynamic> transactionJson in decodedJson) {
      final Map<String, dynamic> contactJson = transactionJson['contact'];
      final Transaction transaction = Transaction(
        transactionJson['value'],
        Contact(
          0,
          contactJson['name'],
          contactJson['accountNumber'],
        ),
      );
      transactions.add(transaction);
    }
    return transactions;
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    final Map<String, dynamic> contactJson = responseJson['contact'];
    return Transaction(
      responseJson['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
  }

  Map<String, dynamic> _toMap(Transaction transaction) {
    final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'name': transaction.contact.name,
        'accountNumber': transaction.contact.accountNumber
      }
    };
    return transactionMap;
  }
}
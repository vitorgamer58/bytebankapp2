import 'dart:convert';

import 'package:bytebank2/http/interceptors/logging_interceptors.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

final Client client =
    InterceptedClient.build(interceptors: [LoggingInterceptor()]);

const String baseUrl = 'http://192.168.0.115:8080/transactions';


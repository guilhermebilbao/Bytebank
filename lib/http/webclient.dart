import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: Duration(seconds: 5),
);



Uri baseUrl = Uri.http('10.121.34.153:8080','transactions');

/*
Modelo:
  Uri baseUrl = Uri.http('your_ip:8080','transactions');


Para descobrir basta rodar o seguinte comando no terminal: `ipconfig`

No meu caso é o valor atribuído ao Endereço IPv4:

Adaptador de Rede sem Fio Wi-Fi:
   Endereço IPv4. . . . . . . .  . . . . . . . : 192.168.3.4

*/
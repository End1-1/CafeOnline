import 'dart:io';
import 'package:http/io_client.dart';
import 'package:http/http.dart';

class Web {

  String link;
  String? body;
  Map<String, String> params = Map();
  int httpCode = 200;

  Web({required this.link}) ;

  Web addParam(String key, String value) {
    params[key] = value;
    return this;
  }

  Future<bool> GET() async {
    try {
      if (params.isNotEmpty) {
        link += "?";
        bool f = true;
        params.forEach((key, value) {
          if (f) {
            f = false;
          } else {
            link += "&";
          }
          link += key + "=" + value;
        });
      }
      print(link);
      HttpClient client = HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(client);
      Response response = await ioClient.get(Uri.parse(link)).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        body = response.body;
        print(body);
      } else {
        httpCode = response.statusCode;
        throw Exception(response.body);
      }
    } catch (e) {
      httpCode = 999;
      body = e.toString();
      print(e);
      return false;
    }
    return true;
  }
}
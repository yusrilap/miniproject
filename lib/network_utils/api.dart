import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  final String _url = 'http://192.168.1.2:8000/api';
  // final String _url = 'http://localhost:8000/api';

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;

    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  deleteData(apiUrl) async {
    var fullUrl = _url + apiUrl;

    return await http.delete(Uri.parse(fullUrl), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}

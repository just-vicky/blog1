import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'data.dart';

class ApiService {
  static const String _baseUrl = 'https://66443e296c6a656587099b9d.mockapi.io/person/data1';

  static Future<void> fetchDataAndStoreInHive() async {
    final response = await http.get(Uri.parse('$_baseUrl'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      final box = await Hive.openBox('myData');
      await box.clear();
      responseData.forEach((data) {
        box.add(Data(id: data['id'], name: data['name']));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
}

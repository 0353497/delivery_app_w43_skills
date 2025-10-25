import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future<List<Map<String, dynamic>>> readVehicles() async {
    final String dataString = await rootBundle.loadString(
      "assets/data/drivers.json",
    );
    final List<Map<String, dynamic>> data = jsonDecode(dataString);
    return data;
  }
}

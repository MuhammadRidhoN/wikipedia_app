// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'search_result.dart';

class ApiService {
  final String baseUrl = 'https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=Craig%20Noone&format=json';

  Future<List<SearchResult>> fetchSearchResults() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<dynamic> searchResults = jsonData['query']['search'];

      return searchResults.map((result) => SearchResult.fromJson(result)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}

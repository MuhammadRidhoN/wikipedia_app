// lib/search_result.dart

class SearchResult {
  final String title;
  final String snippet;

  SearchResult({required this.title, required this.snippet});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'],
      snippet: json['snippet'],
    );
  }
}

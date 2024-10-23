// lib/main.dart

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'search_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wikipedia Search',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.blueAccent),
          titleTextStyle: TextStyle(color: Colors.blueAccent, fontSize: 20),
          elevation: 0,
        ),
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<SearchResult>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = ApiService().fetchSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/Wikipedia-logo.png/1024px-Wikipedia-logo.png',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Text('Wikipedia Search: Craig Noone'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<SearchResult>>(
          future: _searchResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No results found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  SearchResult result = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          result.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            result.snippet.replaceAll(RegExp(r'<[^>]*>'), ''),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'book.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];

  void _searchBooks(String query) {
    setState(() {
      _searchResults = books.where((book) {
        return book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase()) ||
            book.subject.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by title, author, or subject',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchBooks,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(
                child: Text('No results found', style: TextStyle(fontSize: 18)),
              )
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final book = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Author: ${book.author}\nSubject: ${book.subject}'),
                      trailing: Text(
                        book.isAvailable ? 'Available' : 'Unavailable',
                        style: TextStyle(color: book.isAvailable ? Colors.green : Colors.red),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // backgroundColor: Colors.brown,
    );
  }
}

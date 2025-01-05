import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Base URL for REST API
const String _baseURL = 'halloum.mypressonline.com';
const String _endpoint = 'getbooks.php';

class Book {
  final String id;
  final String title;
  final String author;
  final String subject;
  final bool isAvailable;

  Book(this.id, this.title, this.author, this.subject, this.isAvailable);

  // Convert JSON object to a Book instance
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      json['book_id'] ?? '',
      json['title'] ?? '',
      json['author_name'] ?? '',
      json['subject_name'] ?? '',
      json['availability'] == '1',
    );
  }

  @override
  String toString() {
    return 'Title: $title\nAuthor: $author\nSubject: $subject\nAvailable: ${isAvailable ? "Yes" : "No"}';
  }
}

List<Book> books = [];

Future<void> fetchBooks(Function(bool) update) async {
  try {
    // API call to fetch books
    final url = Uri.http(_baseURL, _endpoint);
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      books = jsonData.map((json) => Book.fromJson(json)).toList();
      update(true);
    } else {
      update(false);
    }
  } catch (e) {
    update(false);
  }
}

class BookList extends StatelessWidget {
  const BookList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          margin: const EdgeInsets.all(8),
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
    );
  }
}

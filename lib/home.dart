import 'package:flutter/material.dart';
import 'book.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    updateBooks();
  }

  void updateBooks() {
    fetchBooks((success) {
      setState(() {
        _isLoading = !success;
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load books')),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.black,
            onPressed: _isLoading ? null : () {
              setState(() {
                _isLoading = true;
                updateBooks();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const BookList(),
      backgroundColor: Colors.brown,
    );
  }
}

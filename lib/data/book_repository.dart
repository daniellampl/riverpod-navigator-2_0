import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/book.dart';

/// Provider for the [BookRepository].
final bookRepositoryProvider = Provider<BookRepository>((ref) => BookRepository());

class BookRepository {
  final List<Book> _books = [
    Book(1, 'Clean Artchitecture', 'Robert C. Martin', 432),
    Book(2, 'Deep Work', 'Cal Newport', 432),
    Book(3, 'Clean Code', 'Robert C. Martin', 464),
  ];

  Future<List<Book>> fetchBooks() async {
    await Future.delayed(Duration(milliseconds: 1500));
    return _books;
  }

  Future<Book> fetchBookById(int id) async {
    await Future.delayed(Duration(milliseconds: 1300));
    return _books.firstWhere((element) => element.id == id);
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/book.dart';
import '../data/book_repository.dart';

part '../book_state.freezed.dart';

@freezed
class BookState with _$BookState {
  const BookState._();
  const factory BookState({
    /// The id of the selected book.
    ///
    /// Needed for loading the book via FutureProvider when routing directly to the book detail page.
    int? selectedBookId,

    /// The currently selected book.
    Book? selectedBook,

    /// All available books.
    List<Book>? books,
  }) = _BookState;

  /// Whether a book is selected by its value or its id.
  bool get isBookSelected => selectedBook != null || selectedBookId != null;
}

/// Provider for loading books asynchronoulsy.
final booksProvider = FutureProvider<List<Book>>((ref) async {
  List<Book>? books = ref.read(bookStateControllerProvider).books;
  if (books != null) {
    return books;
  } else {
    return await ref.read(bookStateControllerProvider.notifier).getBooks();
  }
});

/// Provider for loading the selected book if it is not already set in the [BookState].
final selectedBookProvider = FutureProvider.autoDispose<Book>((ref) async {
  Book? selectedBook = ref.read(bookStateControllerProvider).selectedBook;
  if (selectedBook != null) {
    return selectedBook;
  } else {
    return await ref.read(bookStateControllerProvider.notifier).getSelectedBook();
  }
});

/// Provider for the [BookStateController] instance.
final bookStateControllerProvider = StateNotifierProvider<BookStateController, BookState>((ref) => BookStateController(ref.read(bookRepositoryProvider)));

/// Controller for the [BookState].
class BookStateController extends StateNotifier<BookState> {
  final BookRepository _bookRepository;

  BookStateController(this._bookRepository) : super(BookState());

  /// Sets the given bok [id] in the [BookState].
  ///
  /// This gets called when the user routes directly to the book detail page
  /// and the router has to pick the id of the selected book from the url.
  void setSelectedBookId(int id) {
    state = state.copyWith(selectedBookId: id);
  }

  /// Sets the given [book] in the [BookState].
  void selectBook(Book? book) {
    state = state.copyWith(
      selectedBook: book,
      selectedBookId: book != null ? book.id : null,
    );
  }

  /// Fetch the book for the given [id] and set it in the [BookState].
  Future<Book> getSelectedBook() async {
    Book selectedBook = await _bookRepository.fetchBookById(state.selectedBookId!);
    state = state.copyWith(selectedBook: selectedBook);
    return selectedBook;
  }

  /// Fetches all books and sets them in the [BookState].
  Future<List<Book>> getBooks() async {
    List<Book> books = await _bookRepository.fetchBooks();
    state = state.copyWith(books: books);
    return books;
  }
}

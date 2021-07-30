abstract class AppRoutePath {}

/// Route object for `/`
class HomeRoute extends AppRoutePath {}

/// Route object for `/book/:id`
class BookDetailRoute extends AppRoutePath {
  final int? bookId;

  BookDetailRoute(this.bookId);
}

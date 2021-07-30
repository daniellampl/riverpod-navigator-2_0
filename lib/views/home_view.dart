import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/book.dart';
import '../state/book_state.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home View'),
      ),
      body: Consumer(
        builder: (_, WidgetRef ref, __) => ref.watch(booksProvider).when(
              data: (List<Book> books) => books.isNotEmpty
                  ? BooksList(
                      books: books,
                      verticalPadding: 20.0,
                      onTapBook: (Book book) {
                        ref.read(bookStateControllerProvider.notifier).selectBook(book);
                      },
                    )
                  : Center(
                      child: Text('No books available'),
                    ),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => Text('Error while loading books occurred.'),
            ),
      ),
    );
  }
}

class BooksList extends StatelessWidget {
  final List<Book> books;
  final double verticalPadding;
  final double horizontalPadding;
  final Function(Book)? onTapBook;

  const BooksList({
    required this.books,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 25.0,
    this.onTapBook,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) => Container(
        height: constraints.maxHeight,
        width: double.infinity,
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (_, int index) => _BookListItem(
            book: books[index],
            isFirst: index == 0,
            isLast: index == books.length - 1,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding,
            onTap: () {
              if (onTapBook != null) {
                onTapBook!(books[index]);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _BookListItem extends StatelessWidget {
  final Book book;
  final Function() onTap;
  final bool isFirst;
  final bool isLast;
  final double verticalPadding;
  final double horizontalPadding;

  const _BookListItem({
    required this.book,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget item = ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      title: Text(book.name),
    );

    if (isLast || isFirst) {
      return Padding(
        padding: EdgeInsets.only(
          top: isFirst ? verticalPadding : 0.0,
          bottom: isLast ? verticalPadding : 0.0,
        ),
        child: item,
      );
    }

    return item;
  }
}

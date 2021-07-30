import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/book.dart';
import '../state/book_state.dart';

class BookDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Detail View'),
      ),
      body: Consumer(
        builder: (_, WidgetRef ref, __) => ref.watch(selectedBookProvider).when(
              data: (Book selectedBook) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(selectedBook.name, style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 15.0),
                    Text('Author: ${selectedBook.author}'),
                    Text('Pages: ${selectedBook.pages}'),
                  ],
                ),
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

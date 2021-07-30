import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_route.dart';
import '../state/book_state.dart';
import '../views/home_view.dart';
import '../views/book_detail_view.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath> with PopNavigatorRouterDelegateMixin<AppRoutePath>, ChangeNotifier {
  final WidgetRef ref;

  AppRouterDelegate(this.ref) {
    ref.listen(bookStateControllerProvider, (_) => notifyListeners());
  }

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(AppRoutePath route) async {
    final BookStateController bookStateController = ref.read(bookStateControllerProvider.notifier);

    if (route is BookDetailRoute) {
      // we set the id from the url in the state to later fetch it via a FutureProvider when the view is visible.
      bookStateController.setSelectedBookId(route.bookId!);
    } else {
      bookStateController.selectBook(null);
    }
  }

  @override
  AppRoutePath? get currentConfiguration {
    final BookState bookState = ref.read(bookStateControllerProvider);

    if (bookState.isBookSelected) {
      return BookDetailRoute(bookState.selectedBook!.id);
    } else {
      return HomeRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        _AppPage(
          key: ValueKey('home'), // important to remember the view when Navigator gets rebuilt.
          builder: (_) => HomeView(),
        ),
        if (ref.read(bookStateControllerProvider).isBookSelected)
          _AppPage(
            key: ValueKey('book-detail'),
            builder: (_) => BookDetailView(),
          )
      ],
      onPopPage: (Route<dynamic> route, dynamic result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (currentConfiguration is BookDetailRoute) {
          ref.read(bookStateControllerProvider.notifier).selectBook(null);
        }

        return true;
      },
    );
  }
}

class _AppPage<T> extends Page<T> {
  final WidgetBuilder builder;

  const _AppPage({
    required this.builder,
    LocalKey? key,
    Object? arguments,
  }) : super(key: key, arguments: arguments);

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => builder(context),
    );
  }
}

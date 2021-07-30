import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_route.dart';
import '../state/book_state.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  final WidgetRef ref;

  AppRouteInformationParser(this.ref);

  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    Uri uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'book') {
      int? bookId = int.tryParse(uri.pathSegments[1]);
      return BookDetailRoute(bookId);
    }
    return HomeRoute();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath path) {
    if (path is BookDetailRoute) {
      BookState bookState = ref.read(bookStateControllerProvider);
      return RouteInformation(location: '/book/' + bookState.selectedBook!.id.toString());
    }
    return RouteInformation(location: '/');
  }
}

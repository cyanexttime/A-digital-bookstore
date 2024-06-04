import 'package:flutter/cupertino.dart';
import '/common/widgets/network_image_view.dart';
import 'package:oms/core/screens/error_screen.dart';
import 'package:oms/screen/homePage.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      final index = settings.arguments as int?;
      return _cupertinoRoute(
        view: HomeScreen(
          index: index,
        ),
      );

    case NetworkImageView.routeName:
      final imageUrl = settings.arguments as String;
      return _cupertinoRoute(
        view: NetworkImageView(
          url: imageUrl,
        ),
      );
    default:
      return _cupertinoRoute(
        view: const ErrorScreen(
          error: 'The route you entered doesn\'t exist',
        ),
      );
  }
}

CupertinoPageRoute _cupertinoRoute({
  required Widget view,
}) {
  return CupertinoPageRoute(
    builder: (_) => view,
  );
}

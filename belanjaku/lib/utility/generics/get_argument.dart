import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final arg = modalRoute.settings.arguments;
      if (arg != null && arg is T) {
        return arg as T;
      }
    }
    return null;
  }
}

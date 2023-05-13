import 'package:flutter/material.dart';

typedef CloseLoadingScren = bool Function();
typedef UpdateLoadingScreen = bool Function(String txt);

@immutable
class LoadingScreenController {
  final CloseLoadingScren close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({required this.close, required this.update});
}

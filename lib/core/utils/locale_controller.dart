import 'package:flutter/material.dart';

typedef LocaleSetter = Future<void> Function(Locale locale);

class LocaleController extends InheritedWidget {
  final Locale locale;
  final LocaleSetter setLocale;

  const LocaleController({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  static LocaleController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocaleController>()!;

  @override
  bool updateShouldNotify(covariant LocaleController oldWidget) {
    return oldWidget.locale != locale;
  }
}

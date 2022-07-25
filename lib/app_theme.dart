import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme(bool isDark) {
    final theme = isDark
    ? ThemeData(
      brightness: Brightness.dark,
    )
      :ThemeData(
    brightness: Brightness.light,
    );
    return theme.copyWith(
      iconTheme: theme.iconTheme.copyWith(size: 32),
    );
  }
}
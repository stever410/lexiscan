// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemeStore on ThemeStoreBase, Store {
  Computed<bool>? _$isDarkModeComputed;

  @override
  bool get isDarkMode =>
      (_$isDarkModeComputed ??= Computed<bool>(
            () => super.isDarkMode,
            name: 'ThemeStoreBase.isDarkMode',
          ))
          .value;

  late final _$themeModeAtom = Atom(
    name: 'ThemeStoreBase.themeMode',
    context: context,
  );

  @override
  ThemeMode get themeMode {
    _$themeModeAtom.reportRead();
    return super.themeMode;
  }

  @override
  set themeMode(ThemeMode value) {
    _$themeModeAtom.reportWrite(value, super.themeMode, () {
      super.themeMode = value;
    });
  }

  late final _$ThemeStoreBaseActionController = ActionController(
    name: 'ThemeStoreBase',
    context: context,
  );

  @override
  void toggleTheme() {
    final _$actionInfo = _$ThemeStoreBaseActionController.startAction(
      name: 'ThemeStoreBase.toggleTheme',
    );
    try {
      return super.toggleTheme();
    } finally {
      _$ThemeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTheme(ThemeMode mode) {
    final _$actionInfo = _$ThemeStoreBaseActionController.startAction(
      name: 'ThemeStoreBase.setTheme',
    );
    try {
      return super.setTheme(mode);
    } finally {
      _$ThemeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
themeMode: ${themeMode},
isDarkMode: ${isDarkMode}
    ''';
  }
}

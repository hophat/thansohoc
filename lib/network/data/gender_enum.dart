import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

enum Gender {
  man('man'), feMan('feMan'), other('other');
  final String v;
  const Gender(this.v);

  static Gender fromString(String? value) {
    if(value == null) return Gender.other;
    switch (value.toLowerCase()) {
      case 'man':
        return Gender.man;
      case 'feman':
        return Gender.feMan;
      default:
        return Gender.other;
    }
  }
}

extension GenderExtension on Gender{
  String get value => v;
  String display(BuildContext context) {
    switch (this) {
      case Gender.man:
        return S.of(context).horo_male;
      case Gender.feMan:
        return S.of(context).horo_female;
      default:
        return S.of(context).horo_secret;
    }
  }
}
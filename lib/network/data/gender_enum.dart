enum Gender {
  man('Man'), feMan('FeMan'), other('Other');
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
  String get display {
    switch (this) {
      case Gender.man:
        return 'Nam';
      case Gender.feMan:
        return 'Nữ';
      default:
        return 'Bí mật';
    }
  }
}
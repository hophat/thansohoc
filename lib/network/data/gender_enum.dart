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
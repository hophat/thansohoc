class TSHPath {
  TSHPath._();
  static TSHPath? _instance;
  static TSHPath get I => _instance ??= TSHPath._();

  String defaultToken = '/auth/default-token';
  String fetchUser = '/users/';
  String registerUser = '/users/';
  String updateUser = '/users/';

}

extension TSHPathExtension on String {
  String get v1 => 'v1/$this'.replaceAll('//', '/');
  String get v2 => 'v2/$this'.replaceAll('//', '/');
}
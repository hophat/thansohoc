class DefaultToken {
  final String token;

  DefaultToken({required this.token});

  factory DefaultToken.fromJson(Map<String, dynamic> json) {
    return DefaultToken(
      token: json['data'],
    );
  }

  @override
  String toString() {
    return 'DefaultToken{token: $token}';
  }
}

class Language {
  final String code;
  final String name;
  final String nativeName;
  final String direction;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    this.direction = 'ltr',
  });

  factory Language.fromJson(
    String code,
    Map<String, dynamic> json,
  ) {
    return Language(
      code: code,
      name: json['name'] ?? '',
      nativeName: json['nativeName'] ?? '',
      direction: json['dir'] ?? 'ltr',
    );
  }

  bool get isRightToLeft => direction == 'rtl';
}

class Word {
  int? _id;
  String _original;
  String _translated;
  String? _description;

  Word(this._id, this._original, this._translated, this._description);

  String get original => _original;

  set original(String value) {
    _original = value;
  }

  String get translated => _translated;

  set translated(String value) {
    _translated = value;
  }

  String? get description => _description;

  set description(String? value) {
    _description = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'original': _original,
      'translated': _translated,
      'description': _description,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) =>
      Word(json['id'], json['original'], json['translated'], json['description']);
}
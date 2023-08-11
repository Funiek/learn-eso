class Word {
  String _original;
  String _translated;
  String? _description;
  
  Word(this._original, this._translated, this._description);

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
}

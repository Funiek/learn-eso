class Word {
  final int? id;
  final String original;
  final String translated;
  final String? description;

  Word({this.id, required this.original, required this.translated, this.description});


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original': original,
      'translated': translated,
      'description': description,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) =>
      Word(id: json['id'], original: json['original'], translated: json['translated'], description: json['description']);
}

class Word {
  final int? id;
  final String original;
  final String translated;
  final String? description;
  int? priority;
  final String? translateFrom;
  final String? translateTo;

  Word({this.id, required this.original, required this.translated, this.description, this.priority, this.translateFrom, this.translateTo});


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original': original,
      'translated': translated,
      'description': description,
      'priority': priority,
      'translate_from': translateFrom,
      'translate_to': translateTo
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) =>
      Word(id: json['id'], original: json['original'], translated: json['translated'], description: json['description'], priority: json['priority'], translateFrom: json['translate_from'], translateTo: json['translate_to']);
}

class Word {
  final int? id;
  final String original;
  final String translated;
  final String? description;
  int? priority;
  final String? translateFrom;
  final String? translateTo;
  int? returnAtCount;

  Word({
    this.id,
    required this.original,
    required this.translated,
    this.description,
    int? priority,
    this.translateFrom,
    this.translateTo,
    int? returnAtCount,
  })  : priority = priority ?? 5,
        returnAtCount = returnAtCount ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original': original,
      'translated': translated,
      'description': description,
      'priority': priority,
      'translate_from': translateFrom,
      'translate_to': translateTo,
      'return_at_count': returnAtCount
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        id: json['id'],
        original: json['original'],
        translated: json['translated'],
        description: json['description'],
        priority: json['priority'] ?? 5,
        translateFrom: json['translate_from'],
        translateTo: json['translate_to'],
        returnAtCount: json['return_at_count'] ?? 0,
      );
}

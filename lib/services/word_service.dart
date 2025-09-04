import 'dart:collection';

import 'package:learneso/helpers/database_helper.dart';

import '../models/word.dart';
import 'dart:math';

class WordService {
  WordService._privateConstructor();
  static final WordService instance = WordService._privateConstructor();

  Future<List<Word>> getWordsAsync() async {
    return await DatabaseHelper.instance.getWords();
  }

  Future<List<Word>> getRandomizedWordsAsync() async {
    var words = await getWordsAsync();
    words.shuffle(Random());
    return words;
  }

  Future<ListQueue<Word>> getPrioritisedWordsQueueListAsync() async {
    var words = await getWordsAsync();

    if(words.isNotEmpty) {
      words.sort((a, b) => a.priority!.compareTo(b.priority!));
    }

    ListQueue<Word> lq = ListQueue();
    for(Word word in words) {
      if(word.priority! > 0) {
        lq.addFirst(word);
      }
    }

    return lq;
  }

  Future<int> update(Word word) async {
    return await DatabaseHelper.instance.update(word);
  }
}
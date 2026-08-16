import 'dart:collection';
import 'dart:math';

import 'package:learneso/helpers/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/word.dart';

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
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('total_asked_count') ?? 0;

    var words = await DatabaseHelper.instance.getPrioritisedWords(currentCount);

    ListQueue<Word> lq = ListQueue();
    for (Word word in words) {
      lq.addFirst(word);
    }

    return lq;
  }

  Future<int> update(Word word) async {
    return await DatabaseHelper.instance.update(word);
  }

  Future<void> registerWordAttemptAsync(Word word, bool isCorrect) async {
    // 1. Increment global asked count
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('total_asked_count') ?? 0;
    currentCount++;
    await prefs.setInt('total_asked_count', currentCount);

    // 2. Adjust priority and scheduled cooldown if it fell out of the queue
    if (isCorrect) {
      word.priority = (word.priority ?? 5) - 1;
      if (word.priority! <= 0) {
        word.priority = 0;
        word.returnAtCount = currentCount + 100;
      }
    } else {
      word.priority = (word.priority ?? 5) + 1;
      // If it returned, reset scheduled cooldown since it's actively back in the queue
      word.returnAtCount = 0;
    }

    // 3. Save to database
    await DatabaseHelper.instance.update(word);
  }
}
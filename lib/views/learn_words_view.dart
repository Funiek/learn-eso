import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/word.dart';
import '../services/word_service.dart';

class LearnWordsView extends StatefulWidget {
  const LearnWordsView({
    super.key,
    required this.setSelectedView,
  });

  final Function setSelectedView;

  @override
  State<LearnWordsView> createState() => _LearnWordsViewState();
}

class _LearnWordsViewState extends State<LearnWordsView> {
  final TextEditingController textController = TextEditingController();
  ListQueue<Word>? words;
  bool isLoading = true;
  String? error;
  Word? word;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      final fetchedWords =
          await WordService.instance.getPrioritisedWordsQueueListAsync();
      setState(() {
        words = fetchedWords;
        if (words!.isNotEmpty) {
          word = words!.removeFirst();
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Błąd: $error')),
      );
    }

    if (words == null || words!.isEmpty) {
      _loadWords();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        title: const Text('Naucz się słówek'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                word!.translated,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 4),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Wpisz słowo do przetłumaczenia',
              ),
              controller: textController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextButton(
              onPressed: () async {
                if (textController.text == word!.original) {
                  word!.priority = (word!.priority ?? 5) - 1;
                  WordService.instance.update(word!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Prawidłowo!')),
                  );

                  setState(() {
                    textController.clear();
                    if (words!.isNotEmpty) {
                      word = words!.removeFirst();
                    }
                  });
                } else {
                  word!.priority = (word!.priority ?? 5) + 1;
                  WordService.instance.update(word!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Błedna odpowiedź!')),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Text(
                'Sprawdź',
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(word!.original)),
                );

                setState(() {
                  textController.clear();
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Text(
                'Pokaż słowo',
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

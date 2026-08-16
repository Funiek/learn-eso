import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  Color? _feedbackColor;

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _feedbackColor ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _feedbackColor != null
                      ? [
                          BoxShadow(
                            color: _feedbackColor!.withOpacity(0.4),
                            blurRadius: 16,
                            spreadRadius: 3,
                          )
                        ]
                      : [],
                ),
                padding: const EdgeInsets.all(6),
                child: Card(
                  elevation: 6,
                  margin: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                    child: Center(
                      child: Text(
                        word!.translated,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Tłumaczenie',
                    hintText: 'Wpisz słowo po angielsku',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.edit),
                  ),
                  controller: textController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _checkAnswer(),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green,
                              Colors.green.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _checkAnswer,
                          child: const Text(
                            'Sprawdź',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Odpowiedź: ${word!.original} 💡'),
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                duration: const Duration(milliseconds: 1500),
                              ),
                            );
                            setState(() {
                              textController.clear();
                            });
                          },
                          child: Text(
                            'Pokaż słowo',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkAnswer() async {
    if (_feedbackColor != null) return; // Prevent double taps during animation

    final input = textController.text.trim().toLowerCase();
    final correct = word!.original.trim().toLowerCase();

    if (input == correct) {
      // Correct answer feedback
      setState(() {
        _feedbackColor = Colors.green;
      });
      HapticFeedback.lightImpact();

      await WordService.instance.registerWordAttemptAsync(word!, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prawidłowo! 🎉'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1000),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      setState(() {
        _feedbackColor = null;
        textController.clear();
        if (words!.isNotEmpty) {
          word = words!.removeFirst();
        } else {
          word = null; // Forces reload of words queue
        }
      });
    } else {
      // Incorrect answer feedback
      setState(() {
        _feedbackColor = Colors.red;
      });
      HapticFeedback.vibrate();

      await WordService.instance.registerWordAttemptAsync(word!, false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błędna odpowiedź! Poprawnie: ${word!.original} ❌'),
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 1200),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 650));

      if (!mounted) return;
      setState(() {
        _feedbackColor = null;
      });
    }
  }
}

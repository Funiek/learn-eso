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

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
          title: const Text('Naucz się słówek'),
        ),
        body: FutureBuilder(
            future: WordService.instance.getPrioritisedWordsQueueListAsync(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Błąd: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Brak słów'));
              }

              var word = snapshot.data!.removeFirst();

              return Column(
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
                        word.translated,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, top: 16, right: 8, bottom: 4),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Wpisz słowo do przetłumaczenia',
                      ),
                      controller: textController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () async {
                        if (textController.text == word.original) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Prawidłowo!')),
                          );

                          setState(() {
                            textController.clear();
                          });
                        } else {
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(word.original)),
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:learneso/database_helper.dart';
import 'package:learneso/word.dart';

class WordsListView extends StatefulWidget {
  const WordsListView({super.key, required this.setSelectedView});

  final Function setSelectedView;

  @override
  State<WordsListView> createState() => _WordsListViewState();
}

class _WordsListViewState extends State<WordsListView> {
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
        title: const Text('Lista fiszek'),
      ),
      body: Center(
        child: FutureBuilder<List<Word>>(
            future: DatabaseHeloper.instance.getWords(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Word>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('Wczytywanie...'),
                );
              }

              return snapshot.data!.isEmpty
                  ? const Center(
                      child: Text('Brak fiszek'),
                    )
                  : ListView(
                      children: snapshot.data!.reversed
                          .map(
                            (e) => Center(
                              child: ListTile(
                                title: Text('${e.original} -> ${e.translated}'), //TODO: DELETE BUTTON
                              ),
                            ),
                          )
                          .toList(),
                    );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.setSelectedView('Translator'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.translate),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learneso/enums/view_enum.dart';
import 'package:learneso/helpers/database_helper.dart';
import 'package:learneso/models/word.dart';
import 'package:google_translator/google_translator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TranslatorView extends StatefulWidget {
  const TranslatorView({super.key, required this.setSelectedView});

  final Function setSelectedView;

  @override
  State<TranslatorView> createState() => _TranslatorViewState();
}

class _TranslatorViewState extends State<TranslatorView> {
  final TextEditingController textController = TextEditingController();
  final GoogleTranslatorController translatorController =
      GoogleTranslatorController();

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
        title: const Text('Translator'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (!mounted) return;

                String translatedWord = await translatorController
                    .translateText(textController.text);

                if (Platform.isAndroid || Platform.isIOS) {
                  await Fluttertoast.showToast(
                    msg: translatedWord,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  // TODO: do przerobienia - szczegóły w warningu
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(translatedWord)),
                  );
                }

                Word word = Word(
                  original: textController.text,
                  translated: translatedWord,
                  description: 'słowo',
                  priority: 5,
                  translateFrom: 'en',
                  translateTo: 'pl'
                );
                await DatabaseHelper.instance.add(word);

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
                'Tłumacz',
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.setSelectedView(ViewEnum.wordsList),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.book_outlined),
      ),
    );
  }
}

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:proflow/models/word.dart';
import 'package:proflow/services/audio_play.dart';
import 'package:proflow/services/dict_define.dart';
import 'package:proflow/shared.dart';
import 'package:provider/provider.dart';
import '../models/dictionary_m.dart';
import '/services/last_data.dart';

const TextStyle mainTextStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 36);

class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  State<Dictionary> createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  bool isLoading = true;
  DictionaryM? data;

  Future<void> initData() async {
    data = lastDictEntry;
    if (isLastDictEmpty) {
      // print("called default data");
      data = defaultData;
      lastDictEntry = data;
    }
    setState(() {
      isLoading = false;
    });
  }

  DictionaryM get defaultData => easterEggs[ToolLabel.Dictionary];

  @override
  void initState() {
    super.initState();
    initData();
    debugPrint('createing dictionary');
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? Container()
      : Column(
          children: [
            for (var i = 0; i < data!.words.length; i++)
              DictionaryEntry(word: data!.words[i])
          ],
        );
}

class DictionaryEntry extends StatefulWidget {
  final Word word;
  const DictionaryEntry({super.key, required this.word});

  @override
  State<DictionaryEntry> createState() => _DictionaryEntryState();
}

class _DictionaryEntryState extends State<DictionaryEntry> {
  @override
  Widget build(BuildContext context) {
    final Word _word = widget.word;
    final String _wordStr = _word.word;
    final String _audioUrl = _word.audioUrl;
    return Column(
      children: [
        Row(
          children: [
            Text(_wordStr, textAlign: TextAlign.center, style: mainTextStyle),
            IconButton(
                onPressed: () => {playAsset(_audioUrl)},
                icon: const Icon(LineIcons.volumeUp)),
          ],
        ),
      ],
    );
  }
}

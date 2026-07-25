import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/hsk_card.dart';

class WordListScreen extends StatelessWidget {
  const WordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();
    final words = dataService.words;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HSK 1 単語'),
        centerTitle: true,
      ),
      body: words.isEmpty
          ? const Center(child: Text('データがありません'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return HskCard(item: words[index]);
              },
            ),
    );
  }
}

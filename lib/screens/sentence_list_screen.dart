import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/hsk_card.dart';

class SentenceListScreen extends StatelessWidget {
  const SentenceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();
    final sentences = dataService.sentences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HSK 1 例文'),
        centerTitle: true,
      ),
      body: sentences.isEmpty
          ? const Center(child: Text('データがありません'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: sentences.length,
              itemBuilder: (context, index) {
                return HskCard(item: sentences[index]);
              },
            ),
    );
  }
}

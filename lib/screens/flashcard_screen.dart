import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../models/hsk_item.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late List<HskItem> _cards;
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _showWordMode = true; // true=単語, false=例文

  @override
  void initState() {
    super.initState();
    _cards = [];
  }

  void _loadCards(DataService ds) {
    final source = _showWordMode ? ds.words : ds.sentences;
    if (source.isEmpty) return;
    _cards = List.from(source)..shuffle(Random());
    _currentIndex = 0;
    _showAnswer = false;
  }

  void _next() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      // Reshuffle and restart
      setState(() {
        _cards.shuffle(Random());
        _currentIndex = 0;
        _showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.watch<DataService>();
    final theme = Theme.of(context);

    if (!ds.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_cards.isEmpty) {
      _loadCards(ds);
    }

    if (_cards.isEmpty) {
      return const Scaffold(
        appBar: AppBar(title: Text('暗記カード')),
        body: Center(child: Text('データがありません')),
      );
    }

    final item = _cards[_currentIndex];
    final progress = '${_currentIndex + 1} / ${_cards.length}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('暗記カード'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text(progress, style: theme.textTheme.bodyMedium)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Mode toggle
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('単語'), icon: Icon(Icons.menu_book)),
                ButtonSegment(value: false, label: Text('例文'), icon: Icon(Icons.article)),
              ],
              selected: {_showWordMode},
              onSelectionChanged: (v) {
                setState(() {
                  _showWordMode = v.first;
                  _cards = [];
                  _loadCards(ds);
                });
              },
            ),
            const SizedBox(height: 20),
            // Card
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _showAnswer
                        ? theme.colorScheme.secondaryContainer
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.chinese,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_showAnswer) ...[
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 8),
                            Text(
                              item.pinyin,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.japanese,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.english,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (item.imageHint != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Chip(label: Text(item.imageHint!)),
                              ),
                          ] else
                            const SizedBox(height: 16),
                          Text(
                            _showAnswer ? '' : 'タップして答えを見る',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _showAnswer = true);
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('答え'),
                ),
                FilledButton.icon(
                  onPressed: _next,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('次へ'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

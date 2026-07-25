import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../models/hsk_item.dart';
import '../widgets/tts_service.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  late List<HskItem> _items;
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _showWordMode = true;
  final TtsService _tts = TtsService();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _items = [];
  }

  void _loadItems(DataService ds) {
    final source = _showWordMode ? ds.words : ds.sentences;
    if (source.isEmpty) return;
    _items = List.from(source)..shuffle(Random());
    _currentIndex = 0;
    _showAnswer = false;
  }

  Future<void> _playAudio(String text) async {
    setState(() => _isPlaying = true);
    await _tts.speak(text);
    setState(() => _isPlaying = false);
  }

  void _next() {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      setState(() {
        _items.shuffle(Random());
        _currentIndex = 0;
        _showAnswer = false;
      });
    }
  }

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.watch<DataService>();
    final theme = Theme.of(context);

    if (!ds.isLoaded) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_items.isEmpty) _loadItems(ds);
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('リスニング')),
        body: Center(child: Text('データがありません')),
      );
    }

    final item = _items[_currentIndex];
    final progress = '${_currentIndex + 1} / ${_items.length}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('リスニング'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text(progress)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('単語'), icon: Icon(Icons.menu_book)),
                ButtonSegment(value: false, label: Text('例文'), icon: Icon(Icons.article)),
              ],
              selected: {_showWordMode},
              onSelectionChanged: (v) {
                setState(() {
                  _showWordMode = v.first;
                  _items = [];
                  _loadItems(ds);
                });
              },
            ),
            const SizedBox(height: 32),
            // Play button
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _isPlaying ? null : () => _playAudio(item.chinese),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _isPlaying ? 140 : 120,
                        height: _isPlaying ? 140 : 120,
                        decoration: BoxDecoration(
                          color: _isPlaying
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: _isPlaying ? 24 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.volume_up : Icons.play_arrow,
                          size: 56,
                          color: _isPlaying
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'タップして音声を再生',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    if (_showAnswer) ...[
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        item.chinese,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.pinyin,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.japanese,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.english,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _showAnswer = true);
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('答えを見る'),
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

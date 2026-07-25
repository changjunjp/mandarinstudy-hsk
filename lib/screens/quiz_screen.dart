import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../models/hsk_item.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<HskItem> _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  int _correctCount = 0;
  bool _showResult = false;
  bool _showWordMode = true;
  List<HskItem> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    _questions = [];
  }

  void _loadQuestions(DataService ds) {
    final source = _showWordMode ? ds.words : ds.sentences;
    if (source.isEmpty) return;
    _questions = List.from(source)..shuffle(Random());
    _currentIndex = 0;
    _selectedAnswer = null;
    _correctCount = 0;
    _showResult = false;
    _generateOptions();
  }

  void _generateOptions() {
    if (_questions.isEmpty) return;
    final correct = _questions[_currentIndex];
    final others = _questions
        .where((e) => e.id != correct.id)
        .toList()
      ..shuffle(Random());

    final options = <HskItem>[correct];
    options.addAll(others.take(3));
    options.shuffle(Random());
    _currentOptions = options;
  }

  void _answer(int index) {
    if (_selectedAnswer != null) return;
    setState(() {
      _selectedAnswer = index;
      if (_currentOptions[index].id == _questions[_currentIndex].id) {
        _correctCount++;
      }
    });
  }

  void _next() {
    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        _selectedAnswer = null;
        _generateOptions();
      } else {
        _showResult = true;
      }
    });
  }

  void _restart(DataService ds) {
    setState(() {
      _questions = [];
      _loadQuestions(ds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.watch<DataService>();
    final theme = Theme.of(context);

    if (!ds.isLoaded) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions.isEmpty) {
      _loadQuestions(ds);
    }

    if (_showResult) {
      return Scaffold(
        appBar: AppBar(title: const Text('クイズ結果'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  '${_correctCount} / ${_questions.length}',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '正解率 ${(_correctCount / _questions.length * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => _restart(ds),
                  icon: const Icon(Icons.refresh),
                  label: const Text('もう一度'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('クイズ')),
        body: Center(child: Text('データがありません')),
      );
    }

    final item = _questions[_currentIndex];
    final progress = '${_currentIndex + 1} / ${_questions.length}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text('$_correctCount'),
                const SizedBox(width: 8),
                Text(progress),
              ],
            ),
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
                  _questions = [];
                  _loadQuestions(ds);
                });
              },
            ),
            const SizedBox(height: 24),
            // Question
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '日本語に合う中国語を選んでください',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.japanese,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.english,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Options
            Expanded(
              child: ListView.builder(
                itemCount: _currentOptions.length,
                itemBuilder: (context, index) {
                  final opt = _currentOptions[index];
                  bool isSelected = _selectedAnswer == index;
                  bool isCorrect = opt.id == item.id;

                  Color? bgColor;
                  if (_selectedAnswer != null) {
                    if (isCorrect) {
                      bgColor = Colors.green.withOpacity(0.15);
                    } else if (isSelected && !isCorrect) {
                      bgColor = Colors.red.withOpacity(0.15);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Material(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? (isCorrect ? Colors.green : Colors.red)
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              opt.chinese,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              opt.pinyin,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _answer(index),
                        trailing: _selectedAnswer != null && isCorrect
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : (_selectedAnswer != null && isSelected && !isCorrect
                                ? const Icon(Icons.cancel, color: Colors.red)
                                : null),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Next button
            if (_selectedAnswer != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _next,
                    icon: Icon(_currentIndex < _questions.length - 1
                        ? Icons.arrow_forward
                        : Icons.done),
                    label: Text(_currentIndex < _questions.length - 1
                        ? '次の問題'
                        : '結果を見る'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

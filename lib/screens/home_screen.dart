import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import 'word_list_screen.dart';
import 'sentence_list_screen.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';
import 'listening_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _loaded = false;

  final List<Widget> _screens = [
    const WordListScreen(),
    const SentenceListScreen(),
    const FlashcardScreen(),
    const QuizScreen(),
    const ListeningScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dataService = context.read<DataService>();
    if (!dataService.isLoaded) {
      await dataService.loadData();
      setState(() => _loaded = true);
    } else {
      setState(() => _loaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _loaded ? IndexedStack(
        index: _currentIndex,
        children: _screens,
      ) : const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading HSK data...'),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: '単語'),
          NavigationDestination(icon: Icon(Icons.article), label: '例文'),
          NavigationDestination(icon: Icon(Icons.style), label: '暗記'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'クイズ'),
          NavigationDestination(icon: Icon(Icons.headphones), label: 'リスニング'),
        ],
      ),
    );
  }
}

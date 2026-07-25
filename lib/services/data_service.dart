import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/hsk_item.dart';

class DataService extends ChangeNotifier {
  List<HskItem> _words = [];
  List<HskItem> _sentences = [];
  List<HskItem> _allItems = [];
  bool _loaded = false;

  List<HskItem> get words => _words;
  List<HskItem> get sentences => _sentences;
  List<HskItem> get allItems => _allItems;
  bool get isLoaded => _loaded;

  Future<void> loadData() async {
    if (_loaded) return;

    final jsonString = await rootBundle.loadString('assets/hsk1_data.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    final wordsList = (json['words'] as List<dynamic>)
        .map((e) => HskItem.fromJson(e as Map<String, dynamic>))
        .toList();
    final sentencesList = (json['sentences'] as List<dynamic>)
        .map((e) => HskItem.fromJson(e as Map<String, dynamic>))
        .toList();

    _words = wordsList;
    _sentences = sentencesList;
    _allItems = [...wordsList, ...sentencesList];
    _loaded = true;
    notifyListeners();
  }

  List<String> getTopics() {
    final topics = _allItems.map((e) => e.topic).toSet().toList();
    topics.sort();
    return topics;
  }
}

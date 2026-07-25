/// HSK単語/例文のデータモデル
class HskItem {
  final String id;
  final String type; // "word" or "sentence"
  final String chinese;
  final String pinyin;
  final String english;
  final String japanese;
  final String difficulty;
  final String topic;
  final String? imageSrc;
  final String? audioSrc;
  final String? englishAudioSrc;
  final String? japaneseAudioSrc;
  final String? imageHint;
  final List<String> relatedWords;
  final String? createdAt;

  HskItem({
    required this.id,
    required this.type,
    required this.chinese,
    required this.pinyin,
    required this.english,
    required this.japanese,
    required this.difficulty,
    required this.topic,
    this.imageSrc,
    this.audioSrc,
    this.englishAudioSrc,
    this.japaneseAudioSrc,
    this.imageHint,
    this.relatedWords = const [],
    this.createdAt,
  });

  factory HskItem.fromJson(Map<String, dynamic> json) {
    return HskItem(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'word',
      chinese: json['chinese'] as String? ?? '',
      pinyin: json['pinyin'] as String? ?? '',
      english: json['english'] as String? ?? '',
      japanese: json['japanese'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      imageSrc: json['imageSrc'] as String?,
      audioSrc: json['audioSrc'] as String?,
      englishAudioSrc: json['englishAudioSrc'] as String?,
      japaneseAudioSrc: json['japaneseAudioSrc'] as String?,
      imageHint: json['imageHint'] as String?,
      relatedWords: (json['relatedWords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] as String?,
    );
  }

  bool get isWord => type == 'word';
  bool get isSentence => type == 'sentence';
}

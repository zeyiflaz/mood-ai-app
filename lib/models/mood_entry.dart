/*
 * ----------------------------------------------------------------------------
 * KATMAN: VERİ MODELİ (Data Model)
 * ----------------------------------------------------------------------------
 */
class MoodEntry {
  final String mood;
  final String emotion;
  final String motivation;
  final String emoji;
  final DateTime timestamp;

  MoodEntry({
    required this.mood,
    required this.emotion,
    required this.motivation,
    this.emoji = '✨',
    required this.timestamp,
  });

  Map toJson() => {
        'mood': mood,
        'emotion': emotion,
        'motivation': motivation,
        'emoji': emoji,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MoodEntry.fromJson(Map json) => MoodEntry(
        mood: json['mood'],
        emotion: json['emotion'],
        motivation: json['motivation'],
        emoji: json['emoji'] ?? '✨',
        timestamp: DateTime.parse(json['timestamp']),
      );
}

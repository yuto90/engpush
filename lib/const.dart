const baseUrl = 'https://example.com/api';

class ColorPalette {
  static const int main = 0xFF8CCDD5;
  static const int white = 0xFFFFFFFF;

  static const int skyEarlyMorning = 0xCCFFFF;
  static const int skyMorning = 0x66FFFF;
  static const int skyNoon = 0x66CCFF;
  static const int skyEvening = 0xFFCC99;
  static const int skyNight = 0x0000DD;
  static const int skyLateNight = 0x000088;
}

// 単語の品詞
Map<String, String> partOfSpeech = {
  'noun': '名詞',
  'verb': '動詞',
  'adjective': '形容詞',
  'adverb': '副詞',
  'pronoun': '代名詞',
  'preposition': '前置詞',
  'conjunction': '接続詞',
  'interjection': '間投詞',
};

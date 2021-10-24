import 'dart:math';

class LoLWords {
  final String word;
  final String wordEnglish;

  LoLWords(this.word, this.wordEnglish);
}

class LoLWordsFactory {
  static List<LoLWords> words = [
    LoLWords('今天也是正能量的一天', 'Follow the wind, but watch your back.'),
    LoLWords('今天也是阳光明媚的一天', 'Who wants a piece of the champ?'),
    LoLWords('今天也是非常开心的一天', 'Who wants a piece of the champ?')
  ];

  static LoLWords randomWord() {
    return words[Random().nextInt(words.length)];
  }
}

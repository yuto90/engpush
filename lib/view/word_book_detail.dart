import 'package:engpush/const/bottom_nav_bar_items.dart';
import 'package:engpush/model/word_book/word_book_model.dart';
import 'package:engpush/provider/bottom_nav_index_provider.dart';
import 'package:engpush/provider/word_provider.dart';
import 'package:engpush/ui/show_word_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:engpush/provider/reminder_provider.dart';
import 'package:engpush/ios_local_push.dart';

class WordBookDetailPage extends ConsumerStatefulWidget {
  final WordBook wordBook;

  const WordBookDetailPage({
    super.key,
    required this.wordBook,
  });

  @override
  WordBookDetailPageState createState() => WordBookDetailPageState();
}

class WordBookDetailPageState extends ConsumerState<WordBookDetailPage> {
  final IOSLocalPush iosLocalPush = IOSLocalPush();

  @override
  void initState() {
    super.initState();

    // 画面の描画が始まったタイミングで状態の変更
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wordProvider.notifier).fetchWordList(widget.wordBook.wordBookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.watch(bottomNavIndexProvider.notifier);
    final asyncWords = ref.watch(wordProvider);

    final reminder = ref.watch(reminderProvider);
    final reminderNotifier = ref.watch(reminderProvider.notifier);

    final _numbers = List.generate(59, (index) => (index + 1).toString());
    final _times = ["時間", "分", "秒"];

    return Scaffold(
      appBar: AppBar(title: Text(widget.wordBook.name)),
      body: asyncWords.when(
        data: (words) {
          // word内のwordBookIdがwidget.wordBook.wordBookIdと一致するものだけを抽出
          // todo: Viewにロジック書きたくない
          words = words
              .where((word) => word.wordBookId == widget.wordBook.wordBookId)
              .toList();

          return words.isEmpty
              ? const Center(child: Text('まだ単語が登録されていません'))
              : Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    value: true,
                                    title: Text(
                                      words[index].word,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        '[${words[index].partOfSpeech}]${words[index].mean}'),
                                    onChanged: (bool? value) {
                                      showWordModal(
                                        context,
                                        ref,
                                        widget.wordBook.wordBookId,
                                        words[index].wordId,
                                        word: {
                                          'word': words[index].word,
                                          'meaning': words[index].mean,
                                          'partOfSpeech':
                                              words[index].partOfSpeech,
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                              childCount: words.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 10,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: const Color.fromARGB(255, 99, 185, 255),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CupertinoPicker(
                                  itemExtent: 30.0,
                                  children:
                                      _numbers.map((e) => Text(e)).toList(),
                                  onSelectedItemChanged: (newValue) {
                                    reminderNotifier.changeNumber(newValue + 1);
                                  },
                                ),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  itemExtent: 30.0,
                                  children: _times.map((e) => Text(e)).toList(),
                                  onSelectedItemChanged: (newValue) {
                                    reminderNotifier.changeTime(newValue);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    final reminderValue = reminder;
                                    iosLocalPush.scheduleNotification(
                                      '通知タイトル',
                                      '通知内容',
                                      DateTime.now().add(
                                        Duration(
                                          hours: reminderValue.time == 0
                                              ? reminderValue.number
                                              : 0,
                                          minutes: reminderValue.time == 1
                                              ? reminderValue.number
                                              : 0,
                                          seconds: reminderValue.time == 2
                                              ? reminderValue.number
                                              : 0,
                                        ),
                                      ),
                                    );
                                    print(reminderValue);
                                  },
                                  child: const Text('リマインダーをセット'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showWordModal(context, ref, widget.wordBook.wordBookId, null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            bottomNavIndexNotifier.changeDisplay(index);
            context.push('/base', extra: index);
          },
          selectedItemColor: Colors.amber[800],
          items: BottomNavBarItems.items),
    );
  }
}

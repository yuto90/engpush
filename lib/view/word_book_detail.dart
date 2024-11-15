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
import 'package:engpush/view_model/word_book_detail_view_model.dart';

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
      ref
          .read(wordBookDetailViewModelProvider)
          .fetchWords(widget.wordBook.wordBookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final bottomNavIndexNotifier = ref.watch(bottomNavIndexProvider.notifier);
    final asyncWords = ref.watch(wordProvider);
    final checkedWords = ref.watch(checkedWordsProvider).toSet();

    final reminderNotifier = ref.watch(reminderProvider.notifier);
    final viewModel = ref.read(wordBookDetailViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.wordBook.name)),
      body: asyncWords.when(
        data: (words) {
          words = viewModel.filterWords(words, widget.wordBook.wordBookId);

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
                                    value: checkedWords
                                        .contains(words[index].wordId),
                                    title: Text(
                                      words[index].word,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        '[${words[index].partOfSpeech}]${words[index].mean}'),
                                    secondary: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
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
                                    onChanged: (bool? value) {
                                      viewModel
                                          .toggleWordCheck(words[index].wordId);
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
                                  children: viewModel.numbers
                                      .map((e) => Text(e))
                                      .toList(),
                                  onSelectedItemChanged: (newValue) {
                                    reminderNotifier.changeNumber(newValue + 1);
                                  },
                                ),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  itemExtent: 30.0,
                                  children: viewModel.times
                                      .map((e) => Text(e))
                                      .toList(),
                                  onSelectedItemChanged: (newValue) {
                                    reminderNotifier.changeTime(newValue);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    viewModel.scheduleReminder();
                                  },
                                  child: const Text('リマインダーをセット'),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    viewModel.cancelAllReminder();
                                  },
                                  child: const Text('リマインダーを解除'),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    viewModel.scheduleRepeatingReminder();
                                  },
                                  child: const Text('繰り返しリマインダーをセット'),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showWordModal(context, ref, widget.wordBook.wordBookId, null);
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
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

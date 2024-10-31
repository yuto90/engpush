import 'package:engpush/provider/word_provider.dart';
import 'package:engpush/util/aws_dynamodb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showWordModal(
    BuildContext context, WidgetRef ref, String wordBookId, String? wordId,
    {Map<String, String>? word}) {
  final DynamodbUtil dynamodbUtil = DynamodbUtil();
  final formKey = GlobalKey<FormState>();
  final TextEditingController wordController =
      TextEditingController(text: word?['word'] ?? '');
  final TextEditingController meanController =
      TextEditingController(text: word?['meaning'] ?? '');
  String selectedPartOfSpeech = word?['partOfSpeech'] ?? 'noSelected';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(word == null ? '新しい単語を作成' : '単語を編集'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: wordController,
                decoration: const InputDecoration(labelText: '単語: apple'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '必須項目です';
                  }
                  if (value.length > 300) {
                    return '最大300文字まで入力できます';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: meanController,
                decoration: const InputDecoration(labelText: '意味: りんご'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '必須項目です';
                  }
                  if (value.length > 300) {
                    return '最大300文字まで入力できます';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '品詞'),
                value: selectedPartOfSpeech,
                items: const [
                  DropdownMenuItem(value: 'noSelected', child: Text('-')),
                  DropdownMenuItem(value: 'noun', child: Text('名詞')),
                  DropdownMenuItem(value: 'verb', child: Text('動詞')),
                  DropdownMenuItem(value: 'adjective', child: Text('形容詞')),
                  DropdownMenuItem(value: 'adverb', child: Text('副詞')),
                  DropdownMenuItem(value: 'pronoun', child: Text('代名詞')),
                  DropdownMenuItem(value: 'preposition', child: Text('前置詞')),
                  DropdownMenuItem(value: 'conjunction', child: Text('接続詞')),
                  DropdownMenuItem(value: 'interjection', child: Text('間投詞')),
                ],
                onChanged: (value) {
                  selectedPartOfSpeech = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('削除'),
            onPressed: () {
              dynamodbUtil.deleteWord(wordBookId, wordId!);
              ref.read(wordProvider.notifier).deleteWord(wordId);
              context.pop();
            },
          ),
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () => context.pop(),
          ),
          TextButton(
            child: Text(word == null ? '追加' : '更新'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (word == null) {
                  final newWord = await dynamodbUtil.createWord(
                    wordBookId,
                    wordController.text,
                    meanController.text,
                    selectedPartOfSpeech,
                  );
                  ref.read(wordProvider.notifier).addNewWord(newWord);
                } else {
                  dynamodbUtil.updateWord(
                    wordBookId,
                    wordId!,
                    wordController.text,
                    meanController.text,
                    selectedPartOfSpeech,
                  );
                }
                context.pop();
              }
            },
          ),
        ],
      );
    },
  );
}

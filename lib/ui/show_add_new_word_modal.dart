import 'package:engpush/util/aws_dynamodb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showAddNewWordModal(BuildContext context, String wordBookId) {
  final DynamodbUtil dynamodbUtil = DynamodbUtil();
  final formKey = GlobalKey<FormState>();
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meanController = TextEditingController();
  String selectedPartOfSpeech = 'noSelected';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('新しい単語を作成'),
        content: Form(
          key: formKey,
          child: Column(
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
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return '必須項目です';
                //   }
                //   return null;
                // },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () => context.pop(),
          ),
          ElevatedButton(
            child: const Text('追加'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                dynamodbUtil.createWord(
                  wordBookId,
                  wordController.text,
                  meanController.text,
                  selectedPartOfSpeech,
                );
                context.pop();
              }
            },
          ),
        ],
      );
    },
  );
}

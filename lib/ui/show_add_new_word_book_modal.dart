import 'package:engpush/provider/word_book_provider.dart';
import 'package:engpush/util/aws_dynamodb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showAddNewWordBookModal(BuildContext context, WidgetRef ref) {
  final DynamodbUtil dynamodbUtil = DynamodbUtil();
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('新しい単語帳を作成'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: '単語帳名: 中学英単語'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '必須項目です';
              }
              if (value.length > 50) {
                return '最大50文字まで入力できます';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () => context.pop(),
          ),
          ElevatedButton(
            child: const Text('追加'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // 単語帳を作成した後、単語帳リストを再取得して状態を更新
                await dynamodbUtil.createWordBook(controller.text);
                await ref.read(wordBookProvider.notifier).fetchWordBookList();
                context.pop();
              }
            },
          ),
        ],
      );
    },
  );
}

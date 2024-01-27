// chat-GPTと何回かやり取りして
// 『さきほどの回答に　isDarkMode.state　は何回出現しましたか。』
// 『先ほどの回答では、isDarkMode.stateは3回出現しています。』
// 『３回の出現しているすべての箇所を isDarkMode に修正してください。』
// で生成させた回答。いちおうこれで大丈夫なもの。
// https://chat.openai.com/share/97fae998-430a-4db7-acf5-a0f039084278

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<bool>((ref) => false);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Dark Mode Demo',
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider); // StateController<bool> を取得する

    // テーマを取得
    final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();

    return MaterialApp(
      theme: theme, // テーマを更新
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const MainScreen();
                    }),
                  );
                },
                child: const Text('Go to Main Screen'),
              ),
              const SizedBox(height: 20),
              Switch(
                value: isDarkMode, // isDarkMode の状態を直接使用する
                onChanged: (value) {
                  ref.read(themeProvider.notifier).state = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider); // StateController<bool> を取得する

    // テーマを取得
    final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();

    return MaterialApp(
      theme: theme, // テーマを更新
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back to Menu Screen'),
          ),
        ),
      ),
    );
  }
}

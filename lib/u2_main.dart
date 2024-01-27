import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<bool>((ref) => false);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Dark Mode Demo',
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends ConsumerWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider); // StateController<bool> を取得する
    final isDarkModeNotifier = ref
        .read(themeProvider.notifier); // StateController<bool> の notifier を取得する

    return Scaffold(
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
                  // MaterialPageRoute(builder: (context) => MainScreen()),
                  MaterialPageRoute(builder: (context) {
                    return const MainScreen();
                  }),
                );
              },
              child: const Text('Go to Main Screen'),
            ),
            const SizedBox(height: 20),
            Switch(
              // value: isDarkMode.state, // isDarkMode の状態を直接使用する
              value: isDarkMode, // isDarkMode の状態を直接使用する
              onChanged: (value) {
                isDarkModeNotifier.state =
                    value; // StateController の state プロパティを更新する
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider); // StateController<bool> を取得する

    // テーマを取得
    // final theme = isDarkMode.state ? ThemeData.dark() : ThemeData.light();
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
        ));
  }
}

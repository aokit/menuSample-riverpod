import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<bool>((ref) => false);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // MyApp({super.key});

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
    final isDarkMode = ref.watch(themeProvider);
    final isDarkModeNotifier = ref.read(themeProvider.notifier);
    // final isDarkMode = ref.watch(themeProvider);
    // bool appIsDarkMode = isDarkMode.state;
    // final bool appIsDarkMode = ref.watch(themeProvider.state);
    final appIsDarkMode = isDarkMode.state; // StateController の状態を取得する

    //
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
              // value: isDarkMode.state,
              value: isDarkMode, // appIsDarkMode,
              onChanged: (value) {
                // ref.read(themeProvider).state = value;
                // isDarkMode.setState(value);
                isDarkModeNotifier.state = value;
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
    final isDarkMode = ref.watch(themeProvider);
    return Scaffold(
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
    );
  }
}

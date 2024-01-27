// chat-GPTと何回かやり取りして
// 『さきほどの回答に　isDarkMode.state　は何回出現しましたか。』
// 『先ほどの回答では、isDarkMode.stateは3回出現しています。』
// 『３回の出現しているすべての箇所を isDarkMode に修正してください。』
// で生成させた回答。いちおうこれで大丈夫なもの。
// https://chat.openai.com/share/97fae998-430a-4db7-acf5-a0f039084278

// ⬇
// themeProvider　を　preferenceStateProvider　として値を　dark　に
// 持たせる方法にした。　preferenceStateProvider　の実装の内容としては
// PreferenceStateNotifier　の中に記載。構造は　PreferenceState　と
// して定義してある。
// 20240127-2204---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final themeProvider = StateProvider<bool>((ref) => false);

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
    // final isDarkMode = ref.watch(themeProvider); // StateController<bool> を取得する

    // テーマを取得
    // final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();

    //
    final darkState = ref.watch(preferenceStateProvider.select((state) {
      return state.dark;
    }));
    final preferenceNotifier = ref.read(preferenceStateProvider.notifier);
    final theme = darkState ? ThemeData.dark() : ThemeData.light();
    //

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
              /* Switch(
                // value: isDarkMode, // isDarkMode の状態を直接使用する
                value: darkState,
                onChanged: (value) {
                  // ref.read(themeProvider.notifier).state = value;
                  preferenceNotifier.set(dark: value);
                },
              ), */
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: darkState,
                onChanged: (value) {
                  preferenceNotifier.set(dark: value);
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
    // final isDarkMode = ref.watch(themeProvider); // StateController<bool> を取得する

    // テーマを取得
    // final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();

    //
    final darkState = ref.watch(preferenceStateProvider.select((state) {
      return state.dark;
    }));
    // final preferenceNotifier = ref.read(preferenceStateProvider.notifier);
    final theme = darkState ? ThemeData.dark() : ThemeData.light();
    //

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

/* --- ================================================================================================= --- */

@immutable
class PreferenceState {
  const PreferenceState({
    this.dark = false,
  });
  final bool dark;
  //
  PreferenceState copyWith({
    bool? dark,
  }) {
    return PreferenceState(
      dark: dark ?? this.dark,
    );
  }
}

class PreferenceStateNotifier extends StateNotifier<PreferenceState> {
  PreferenceStateNotifier() : super(const PreferenceState()) {
    initialize();
  }

  Future initialize() async {
    // final dark = //darkByHive;
    // const dark = false;
    set(
      dark: false, //dark,
    );
  }

  //
  Future<bool> get _dark async {
    return false;
  }

  //
  Future<void> set({
    bool? dark,
  })
  //
  async {
    state = state.copyWith(
      dark: dark,
    );
    if (dark == null) {
    } else {
      // Hive.box<bool>(boolsBoxName).put('darkByHive', dark);
      // bool? darkByHive = Hive.box<bool>(boolsBoxName).get('darkByHive');
    }
  }
}

final preferenceStateProvider =
    StateNotifierProvider<PreferenceStateNotifier, PreferenceState>((ref) {
  return PreferenceStateNotifier();
});

/* --- ================================================================================================= --- */

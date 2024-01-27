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

// ⬇
// ThemeData.dark()　を　ThemeData(brightness: Brightness.dark,)
// で記述して、ここに　useMaterial: false,　も付け加えればマテリアル３
// の適用を止めることができるので、以前のマテリアルデザインのスイッチなどを
// 表示させることができるとのことがわかった・・・ほとんど情報がなかったのだ
// がマテリアルデザインが変わったかどうかを検索したらマテリアル３という用語
// とその記事がいくつか出てきてわかった。マテリアル３の適用をスイッチで切り
// 替えることができるようにした。切り替えるとスイッチ自身の表示形状が変わる。
// https://chat.openai.com/share/5d3fa5d1-fbdd-45da-8ea6-7dbf93b3365c
// 20240128-0053---

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
    final useMaterial3State = ref.watch(preferenceStateProvider.select((state) {
      return state.useMaterial3;
    }));
    final preferenceNotifier = ref.read(preferenceStateProvider.notifier);
    // final theme = darkState ? ThemeData.dark() : ThemeData.light();
    final theme = darkState
        ? ThemeData(
            // useMaterial3: false,
            useMaterial3: useMaterial3State,
            brightness: Brightness.dark,
          )
        : ThemeData(
            // useMaterial3: false,
            useMaterial3: useMaterial3State,
            brightness: Brightness.light,
          );
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
              SwitchListTile(
                title: const Text('useMaterial3'),
                value: useMaterial3State,
                onChanged: (value) {
                  preferenceNotifier.set(useMaterial3: value);
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
    final useMaterial3State = ref.watch(preferenceStateProvider.select((state) {
      return state.useMaterial3;
    }));
    // final preferenceNotifier = ref.read(preferenceStateProvider.notifier);
    // final theme = darkState ? ThemeData.dark() : ThemeData.light();
    final theme = darkState
        ? ThemeData(
            // useMaterial3: false,
            useMaterial3: useMaterial3State,
            brightness: Brightness.dark,
          )
        : ThemeData(
            // useMaterial3: false,
            useMaterial3: useMaterial3State,
            brightness: Brightness.light,
          );
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
// riverpod のプロバイダに管理させる状態（を提供するクラス）；生成されるのみで変更は不可能
// https://chat.openai.com/share/337e1a2e-065e-4861-b919-53f8a2894cc1
// そういうルールに従うことで、安全（実行のタイミングなどに関わらずコードの上で記述
// との関係が明確になるよう）にコーディングできる。
@immutable
class PreferenceState {
  const PreferenceState({
    this.dark = false,
    this.useMaterial3 = false,
  });
  final bool dark;
  final bool useMaterial3;
  //
  PreferenceState copyWith({
    bool? dark,
    bool? useMaterial3,
  }) {
    return PreferenceState(
      dark: dark ?? this.dark,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
    );
  }
}

class PreferenceStateNotifier extends StateNotifier<PreferenceState> {
  PreferenceStateNotifier() : super(const PreferenceState()) {
    initialize();
  }

  // 初期値はここで定義する
  Future initialize() async {
    set(
      dark: false,
      useMaterial3: false,
    );
  }

  //　ひょっとしたら get のほうも定義できるのだろう。
  Future<bool> get _dark async {
    return false;
  }

  // 値の更新をimmutableに焼き付けるのはこの関数（set）の記述
  Future<void> set({
    bool? dark,
    bool? useMaterial3,
  })
  // 実際の処理はここから
  async {
    // まずはコピー
    state = state.copyWith(
      dark: dark,
      useMaterial3: useMaterial3,
    );
    // 必要ならここで与えられた値の間の相互作用も記述できると思う。
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

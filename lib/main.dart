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

// ⬇
// preferenceStateProvider　の中に　getTheme()　を実装した。
// 20240128-1413---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // 追加

// final themeProvider = StateProvider<bool>((ref) => false);

const navigateMain = true; // false; // true;
// true で再起動した場合（起動した場合）MenuScreenで設定したテーマ
// が MainScreen に反映されないバグがある。
// Hive で設定されるものもあってもよいかも。

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Dark Mode Demo',
      // home: MenuScreen(),
      // home: MainScreen(),
      home: navigateMain ? MainScreen() : MenuScreen(),
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
    /* final darkState = ref.watch(preferenceStateProvider.select((state) {
      return state.dark;
    })); */
    /* final useMaterial3State = ref.watch(preferenceStateProvider.select((state) {
      return state.useMaterial3;
    })); */
    // ⬇・・・以下の theme でまとめて取得することができる。
    final sample = ref.watch(preferenceStateProvider.select((state) {
      return state.sample;
    }));
    final preferenceNotifier = ref.read(preferenceStateProvider.notifier);
    // final theme = darkState ? ThemeData.dark() : ThemeData.light();
    final theme = ref.read(preferenceStateProvider).getTheme();
    // ⬆・・・preferenceStateProvider　の中に　getTheme()　を実装した。
    /* final theme = darkState
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
    */ //
    // final darkState = (theme.brightness == Brightness.dark);
    // final useMaterial3State = theme.useMaterial3;
    // ┗・・・この方法だと変更がインタラクティブに反映されないので使わない。
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
                  navigateMain
                      ? Navigator.pop(context)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const MainScreen();
                          }),
                        );
                },
                child: navigateMain
                    ? const Text('Back to Main Screen')
                    : const Text('Go to Main Screen'),
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
                // value: darkState,
                // ⬆・・・（上の方でfinal darkState = (theme.brightness == Brightness.dark);）
                // ・・・・これだと値が変わったときに表示にインタラクティブに反映されない。
                // value: ref.read(preferenceStateProvider).dark,
                // ・・・・これも同様にだめ。
                value: ref.watch(preferenceStateProvider.select((state) {
                  return state.dark;
                })),
                onChanged: (value) {
                  preferenceNotifier.set(dark: value);
                },
              ),
              SwitchListTile(
                title: const Text('useMaterial3'),
                // value: useMaterial3State,
                value: ref.watch(preferenceStateProvider.select((state) {
                  return state.useMaterial3;
                })),
                onChanged: (value) {
                  preferenceNotifier.set(useMaterial3: value);
                },
              ),
              SwitchListTile(
                title: const Text('sample'),
                value: sample,
                onChanged: (value) {
                  preferenceNotifier.set(sample: value);
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
    //
    print('再ビルド');
    final theme = ref.read(themeDataProvider); // テーマを取得
    // final theme = ref.read(preferenceStateProvider).getTheme();

    return MaterialApp(
      theme: theme, // テーマを更新
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              navigateMain
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const MenuScreen();
                      }),
                    )
                  : Navigator.pop(context);
            },
            child: navigateMain
                ? const Text('Go to Menu Screen')
                : const Text('Back to Menu Screen'),
          ),
        ),
      ),
    );
  }
}

class _MainScreen extends ConsumerWidget {
  const _MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isDarkMode = ref.watch(themeProvider); // StateController<bool> を取得する

    // テーマを取得
    // final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();

    //
    /*
    final darkState = ref.watch(preferenceStateProvider.select((state) {
      return state.dark;
    }));
    final useMaterial3State = ref.watch(preferenceStateProvider.select((state) {
      return state.useMaterial3;
    })); 
    */
    // ⬇・・・以下の theme でまとめて取得することができる。
    // final preferenceNotifier = ref.read(preferenceStateProvider.notifier);
    // final theme = darkState ? ThemeData.dark() : ThemeData.light();

    // final theme = useProvider(themeDataProvider);
    // final theme = ref.read(preferenceStateProvider).getTheme();
    final theme = ref.read(themeDataProvider);
    // ⬆・・・preferenceStateProvider　の中に　getTheme()　を実装した。
    /* final theme = darkState
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
    */ //

    return MaterialApp(
      theme: theme, // テーマを更新
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              navigateMain
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const MenuScreen();
                      }),
                    )
                  : Navigator.pop(context);
            },
            child: navigateMain
                ? const Text('Go to Menu Screen')
                : const Text('Back to Menu Screen'),
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
    // ここでの設定は初期値としては機能しないってことかな。
    this.dark = false,
    this.useMaterial3 = false,
    this.startMain = false,
    this.sample = false,
  });
  final bool dark;
  final bool useMaterial3;
  final bool startMain;
  final bool sample;
  //
  PreferenceState copyWith({
    bool? dark,
    bool? useMaterial3,
    bool? startMain,
    bool? sample,
  }) {
    return PreferenceState(
      dark: dark ?? this.dark,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      startMain: startMain ?? this.startMain,
      sample: sample ?? this.sample,
    );
  }

  //　プロバイダから値を得たいときにはここで定義する。
  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: dark ? Brightness.dark : Brightness.light,
    );
  }

  // ⬇以下のようにして値を得る。
  // final theme = ref.read(preferenceStateProvider).getTheme();
  //
  bool getdark() {
    return dark;
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
      useMaterial3: true, //false,
      startMain: true,
      sample: false,
    );
  }

  //　ひょっとしたら get のほうも定義できるのだろう。
  Future<bool> get _dark async {
    return false;
  }

  /*
  ThemeData _theme() {
    return ThemeData(
      useMaterial3: state.useMaterial3,
      brightness: state.dark ? Brightness.dark : Brightness.light,
    );
  }
  */

  // 値の更新をimmutableに焼き付けるのはこの関数（set）の記述
  Future<void> set({
    bool? dark,
    bool? useMaterial3,
    bool? startMain,
    bool? sample,
  })
  // 実際の処理はここから
  async {
    // まずはコピー
    state = state.copyWith(
      dark: dark,
      useMaterial3: useMaterial3,
      startMain: startMain,
      sample: sample,
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

final themeDataProvider = Provider<ThemeData>((ref) {
  final preferenceState = ref.watch(preferenceStateProvider);

  return ThemeData(
    useMaterial3: preferenceState.useMaterial3,
    brightness: preferenceState.dark ? Brightness.dark : Brightness.light,
    // 他のテーマデータプロパティをここに追加できます
  );
});

/* --- ================================================================================================= --- */

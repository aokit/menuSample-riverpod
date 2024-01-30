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

// const startFromMain = true; // false; // true;
// true で再起動した場合（起動した場合）MenuScreenで設定したテーマ
// が MainScreen に反映されないバグがある。
// Hive で設定されるものもあってもよいかも。
//
const defaultStartIsFromMain = true; // false; // true;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// class MyApp extends StatelessWidget {
// ⬇
// ⬇・・・『ref.read(preferenceStateProvider).startFromMain』が必要
// になったので『Widget build(BuildContext context) {』
// を『Widget build(BuildContext context, WidgetRef ref) {』
// にする。そのために『Stateless』ではなくて『Consumer』にする。そういう
// 書き換えができるということがわかった。
// 20240131-0033---
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool startFromMain = ref.read(preferenceStateProvider).startFromMain;
    // 最初のスクリーンをメインのとするかメニューのとするかを設定に従うようにした。
    // 設定値によりいずれかのウイジェットを生成する。
    // 20240131-0033---
    if (startFromMain) {
      return const MaterialApp(
        title: 'Flutter Dark Mode Demo',
        home: MainScreen(),
      );
    } else {
      return const MaterialApp(
        title: 'Flutter Dark Mode Demo',
        home: MenuScreen(),
      );
    }
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
    // final theme = ref.read(preferenceStateProvider).getTheme();
    // ⬆・・・preferenceStateProvider　の中に　getTheme()　を実装した。
    final theme = ref.read(themeDataProvider); // テーマを取得
    // ⬆・・・こちら（MenuScreeの側）だと別に作ったthemeDataProviderでも大丈夫。
    // いっぽう MainScreen の側ではプロバイダから変化を受け取るために read ではな
    // くて watch で作られている
    // final theme = ref.watch(preferenceStateProvider).getTheme();
    // を使う必要がある。
    // final theme = ref.watch(themeDataProvider); // テーマを取得
    // でもよさそう。
    //
    final bool startFromMain = ref.read(preferenceStateProvider).startFromMain;
    // ref.read(...) を ref.watch(...) に変えると状態が変わったときに
    // ウィジェットの再ビルドをトリガすることができるらしい。read か watch か
    // を選べることがわかったぞ。⬇
    // final bool startFromMain = ref.watch(preferenceStateProvider).startFromMain;
    // 20240131-0033---
    //
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
    // その理由がはじめは分からなかったのだが、それは ref.read() で theme を
    // 得ているからだったのだろうと思う。
    // 20240131-0033---
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
                /*onPressed: () {
                  startFromMain
                      ? Navigator.pop(context)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const MainScreen();
                          }),
                        );
                },*/
                onPressed: () {
                  if (startFromMain) {
                    /* ref
                        .read(preferenceStateProvider.notifier)
                        .set(startFromMain: true); // Providerの状態変更 */
                    // .set(sample: true); // Providerの状態変更
                    // ┗・・・インタラクティブに再ビルドしてもらうために
                    // これらを入れるというアイデアを　chat-GPT　から
                    // 得たがそれは必要ではなかった。
                    // 20240131-0033---
                    Navigator.pop(context);
                  } else {
                    // 画面遷移は一方方向にすすめることも戻ることもできるらしい。
                    // 20240131-0033---
                    // Navigator.pushReplacement(
                    // ┗・・・戻るのではなくて一方向に進める場合はこれ
                    // ┏・・・戻る場合はこれ
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const MainScreen();
                      }),
                    );
                  }
                },
                child: startFromMain
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
                // これらがだめだったのは、 ref.read() であるオブジェクトの操作だったから
                // かもしれない。実際、うまく機能している以下の記述は ref.watch() である。
                // 20240131-0033---
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
                title: const Text('startFromMain(required Reboot)'),
                value: startFromMain,
                onChanged: (value) {
                  // preferenceNotifier.set(startFromMain: value);
                  // ┗・・・・・・startFromMainは　Navigator　についての
                  // ハードコーディングと干渉してしまうのでアプリを再起動する
                  // ときにしか値の変更を反映させないようにすることが必要。
                  // 20240131-0033---
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
    // final theme = ref.read(themeDataProvider); // テーマを取得
    // final theme = ref.watch(preferenceStateProvider).getTheme();
    // ref.watch() であることが重要。おそらく以下⬇でも大丈夫のはず。
    final theme = ref.watch(themeDataProvider); // テーマの更新を取得
    // 大丈夫だった。
    // 20240131-0033---
    final bool startFromMain = ref.read(preferenceStateProvider).startFromMain;

    return MaterialApp(
      theme: theme, // テーマを更新
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              startFromMain
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const MenuScreen();
                      }),
                    )
                  : Navigator.pop(context);
            },
            child: startFromMain
                ? const Text('Go to Menu Screen')
                : const Text('Back to Menu Screen'),
          ),
        ),
      ),
    );
  }
}

/*
class E_MainScreen extends ConsumerWidget {
  const E_MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeDataProvider); // テーマを取得
    // final theme = ref.watch(preferenceStateProvider).getTheme();

    return MaterialApp(
      theme: theme, // テーマを更新
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const MenuScreen();
                }),
              );
            },
            child: const Text('Go to Menu Screen'),
          ),
        ),
      ),
    );
  }
}

class D_MainScreen extends ConsumerWidget {
  const D_MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /* final preferenceState =
        ref.watch(preferenceStateProvider); // Providerの状態をウォッチ
    */
    final theme = ref.read(themeDataProvider); // テーマを取得

    return MaterialApp(
      theme: theme, // テーマを更新
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const MenuScreen();
                }),
              );
            },
            child: const Text('Go to Menu Screen'),
          ),
        ),
      ),
    );
  }
}

class C_MainScreen extends ConsumerWidget {
  const C_MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferenceState =
        ref.watch(preferenceStateProvider); // Providerの状態をウォッチ

    final theme = ref.read(themeDataProvider); // テーマを取得

    return MaterialApp(
      theme: theme, // テーマを更新
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // if (!preferenceState.startFromMain) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const MenuScreen();
                }),
              );
              // }
            },
            child: const Text('Go to Menu Screen'),
          ),
        ),
      ),
    );
  }
}

class B_MainScreen extends ConsumerWidget {
  const B_MainScreen({super.key});

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
              startFromMain
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const MenuScreen();
                      }),
                    )
                  : Navigator.pop(context);
            },
            child: startFromMain
                ? const Text('Go to Menu Screen')
                : const Text('Back to Menu Screen'),
          ),
        ),
      ),
    );
  }
}

class A_MainScreen extends ConsumerWidget {
  const A_MainScreen({super.key});

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
              startFromMain
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const MenuScreen();
                      }),
                    )
                  : Navigator.pop(context);
            },
            child: startFromMain
                ? const Text('Go to Menu Screen')
                : const Text('Back to Menu Screen'),
          ),
        ),
      ),
    );
  }
}
*/

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
    this.startFromMain = false,
    this.sample = false,
  });
  final bool dark;
  final bool useMaterial3;
  final bool startFromMain;
  final bool sample;
  //
  PreferenceState copyWith({
    bool? dark,
    bool? useMaterial3,
    bool? startFromMain,
    bool? sample,
  }) {
    return PreferenceState(
      dark: dark ?? this.dark,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      startFromMain: startFromMain ?? this.startFromMain,
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

  // メンバ変数は以下のような関数を明示的に作らなくても
  // 以下のようにして値を得ることができる。
  // final startFromMain = ref.read(preferenceStateProvider).startFromMain;
  // final startFromMain = ref.watch(preferenceStateProvider).startFromMain;
  // 後者は値を得るほかに更新を検出してウイジェットの再ビルドをトリガさせることができる。
  // 20240131-0033---
  /*
  bool getdark() {
    return dark;
  }
  */
  /*
  bool startFromMain() {
    return startFromMain;
  }
  */
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
      startFromMain: defaultStartIsFromMain,
      sample: false,
    );
  }

  // ひょっとしたら get のほうも定義できる？・・・いやできなさそう。
  // ここではメンバ変数にアクセスできない。
  // ・・・というか要らない。『ref.read(preferenceStateProvider).メンバ変数名』
  // でアクセスできるから。ではここには何を書くのがよいのだろうか。
  // 20240131-0033---
  /*
  Future<bool> get _dark async {
    // return dark;
    return false;
  }

  Future<bool> get _startFromMain async {
    return false;
    //startFromMain;
  }
  */
  /*
  ThemeData _theme() {
    return ThemeData(
      useMaterial3: state.useMaterial3,
      brightness: state.dark ? Brightness.dark : Brightness.light,
    );
  }
  */

  // 値の更新をimmutableに焼き付ける（単一代入する＝新たな値で生成する）のは
  // この関数（set）の記述。中身は state である PreferenceState に用意し
  // てある copywith 関数を実行すること。
  Future<void> set({
    bool? dark,
    bool? useMaterial3,
    bool? startFromMain,
    bool? sample,
  })
  // 実際の処理はここから
  async {
    // まずはコピー
    state = state.copyWith(
      dark: dark,
      useMaterial3: useMaterial3,
      startFromMain: startFromMain,
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

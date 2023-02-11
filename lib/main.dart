import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// パーツ1つ1つを管理する
class Part {
  // プロパティ
  String category; // 輪郭、目、まゆげなど、どこに属するパーツなのか
  String path; // 画像のパス
  bool isSelected; // 選択されているかどうか

  // 初期化
  Part(this.category, this.path, this.isSelected);

  @override
  String toString() {
    return 'Part: {category: $category, path: $path, selected: $isSelected';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'momochyのおんなのこ テスト',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'momochyのおんなのこ テスト'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // パーツ一覧を定義
  // プロダクション用の実装ならここはDBから取得するのが正
  List<Part> assetsList = [
    Part("rinkaku", "images/0.png", true),
    Part("rinkaku", "images/1.png", false),
    Part("rinkaku", "images/2.png", false),
    Part("me", "images/3.png", false),
    Part("me", "images/4.png", false),
    Part("me", "images/5.png", false),
    Part("mayuge", "images/6.png", false),
    Part("mayuge", "images/7.png", false),
    Part("mayuge", "images/8.png", false),
    Part("kuchi", "images/9.png", false),
    Part("kuchi", "images/10.png", false),
    Part("kuchi", "images/11.png", false),
    Part("kami", "images/12.png", false),
    Part("kami", "images/13.png", false),
    Part("kami", "images/14.png", false),
    Part("maegami", "images/15.png", false),
    Part("maegami", "images/16.png", false),
    Part("maegami", "images/17.png", false),
    Part("huku", "images/18.png", false),
    Part("huku", "images/19.png", false),
    Part("huku", "images/20.png", false),
  ];

  String _selectedCategory = "rinkaku"; // 初期値を入れておく

  // 初期値が入らず、後から定義するものには late で始める
  late List<Part>? _selectableParts; // Part の配列
  late List<String>? _categoryList; // String の配列
  late List<Part>? _selectedAssetsList; // Part の配列

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _selectPart(Part part) {
    setState(() {
      // カテゴリーごとに1つしか選択させないのですべて未選択状態に
      // パーツ数が増えた時に forループだとつらいので要改善
      for (int i = 0; i < _selectableParts!.length; i++) {
        _selectableParts![i].isSelected = false;
      }
      part.isSelected = true;
    });
  }

  CategorytoJapanese(String category) {
    switch(category) {
      case 'rinkaku':
        return "輪郭";
      case 'me':
        return "目";
      case 'mayuge':
        return "まゆげ";
      case 'kuchi':
        return "くち";
      case 'kami':
        return "髪型";
      case 'maegami':
        return "前髪";
      case 'huku':
        return "服装";
      default:
        print('$category は定義されていないカテゴリーです');
        break;
    };
  }

  @override
  Widget build(BuildContext context) {
    // 選択されたカテゴリーに合わせて、パーツ一覧を差し替える
    _selectableParts = assetsList.where((assets) => assets.category == _selectedCategory).toList();

    // パーツ一覧からカテゴリー一覧を生成
    _categoryList = assetsList.map((asset) => asset.category).toSet().toList();

    // 選択されているパーツ一覧を取得（これをメインフレームに描画）
    _selectedAssetsList = assetsList.where((assets) => assets.isSelected == true).toList();

    // デバッグ用表示
    print(_selectedCategory);
    for (int i = 0; i < _selectableParts!.length; i++) {
      print(_selectableParts![i]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 選択されているパーツを Stack ウィジェットで重ねて表示
            Stack(
              alignment: Alignment.center,
              children: [
                for (int i = 0; i < _selectedAssetsList!.length; i++) Image.asset(
                  _selectedAssetsList![i].path.toString(),
                  width: 300,
                  height: 300,
                ),
              ]
            ),
            // SingleChildScrollView と Row ウィジェットでカテゴリー一覧の横スクロールを実装
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < _categoryList!.length; i++) GestureDetector(
                    onTap: () {
                      _selectCategory(_categoryList![i]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          CategorytoJapanese(_categoryList![i]),
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                      )
                    )
                  )
                ],
              )
            ),
            // GridView でパーツ一覧を3列グリッド表示
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(3, (i) {
                  return GestureDetector(
                    onTap: () {
                      _selectPart(_selectableParts![i]);
                    },
                    child: Image.asset(_selectableParts![i].path),
                  );
                }),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

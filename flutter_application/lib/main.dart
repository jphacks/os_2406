import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Syncfusionのインポート
import 'src/input_before.dart'; // 遷移先の画面ファイルをインポート
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // APIからデータを取得する関数
  Future<Map<String, dynamic>> fetchResult() async {
    final url = Uri.parse('http://10.0.2.2:8000/result'); // APIエンドポイントを指定
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // サーバーが200 OKを返した場合、JSONを解析
      return jsonDecode(response.body);
    } else {
      // サーバーが200 OK以外のレスポンスを返した場合、例外をスロー
      throw Exception('データの読み込みに失敗しました');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: FutureBuilder<Map<String, dynamic>>(
        future: fetchResult(), // APIからのデータ取得を行う
        builder: (context, snapshot) {
          // スナップショットの状態に応じたUIを構築
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // ローディング中
          } else if (snapshot.hasError) {
            return Center(child: Text('エラー: ${snapshot.error}')); // エラー処理
          } else {
            // データが正常に取得できた場合、DashboardScreenを表示
            return DashboardScreen(data: snapshot.data!); // データを渡す
          }
        },
      ),
    );
  }
}


class DashboardScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DashboardScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0, // 影を消す
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {}, // 戻るボタンの機能
        ),
        title: const Text(
          'ダッシュボード',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // スクロール可能にする
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            // 飲料摂取のグラフ
            Container(
              height: 300,
              child: SfCartesianChart(
                title: ChartTitle(text: '飲料別の摂取'),
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<DrinkData, String>(
                    dataSource: getDrinkData(),
                    xValueMapper: (DrinkData data, _) => data.drink,
                    yValueMapper: (DrinkData data, _) => data.consumption,
                    name: '摂取量',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            // 集中度合いのグラフ
            Container(
              height: 300,
              child: SfCartesianChart(
                title: ChartTitle(text: '飲料別の集中度合い'),
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<FocusData, String>(
                    dataSource: getFocusData(),
                    xValueMapper: (FocusData data, _) => data.drink,
                    yValueMapper: (FocusData data, _) => data.score,
                    name: '集中度合い',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            // 睡眠時間と集中度合いのグラフ
            Container(
              height: 300,
              child: SfCartesianChart(
                title: ChartTitle(text: '睡眠時間と集中度合い'),
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<SleepFocusData, String>(
                    dataSource: getSleepFocusData(),
                    xValueMapper: (SleepFocusData data, _) => data.sleepHours,
                    yValueMapper: (SleepFocusData data, _) => data.focusScore,
                    name: '集中度合い',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PreWorkScreen()),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  // 飲料摂取データを取得するメソッド
  List<DrinkData> getDrinkData() {
    // データマップから飲料とその摂取量を抽出
    List<DrinkData> drinkDataList = [];
    
    // dataから各飲料の摂取量を取得
    data.forEach((key, value) {
      // valueはリストで、最初の要素を摂取量として取得
      if (value is List && value.isNotEmpty) {
        drinkDataList.add(DrinkData(key, value[0]));
      }
    });

    return drinkDataList;
  }

  // 集中度合いデータを取得するメソッド
  List<FocusData> getFocusData() {
    return [
      FocusData('Red Bull', 80),
      FocusData('Monster', 70),
      FocusData('Bang', 85),
      FocusData('High Brew', 60),
      FocusData('Rockstar', 75),
    ];
  }

  // 睡眠時間と集中度合いデータを取得するメソッド
  List<SleepFocusData> getSleepFocusData() {
    return [
      SleepFocusData('1時間', 40),
      SleepFocusData('2時間', 50),
      SleepFocusData('3時間', 60),
      SleepFocusData('4時間', 70),
      SleepFocusData('5時間', 80),
      SleepFocusData('6時間', 90),
      SleepFocusData('7時間以上', 95),
    ];
  }
}

// データクラス
class DrinkData {
  final String drink;
  final double consumption;

  DrinkData(this.drink, this.consumption);
}

class FocusData {
  final String drink;
  final double score;

  FocusData(this.drink, this.score);
}

class SleepFocusData {
  final String sleepHours;
  final double focusScore;

  SleepFocusData(this.sleepHours, this.focusScore);
}

class StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final String percent;
  final Color percentColor;

  const StatusCard({
    required this.title,
    required this.status,
    required this.percent,
    required this.percentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF543b40)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 4),
          Text(status, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(percent, style: TextStyle(color: percentColor, fontSize: 16)),
        ],
      ),
    );
  }
}

class DrinkProgress extends StatelessWidget {
  final String title;
  final double percent;

  const DrinkProgress({
    required this.title,
    required this.percent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(color: Color(0xFFba9ca2), fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: const Color(0xFF39282b),
                color: const Color(0xFFba9ca2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Syncfusionのインポート
import 'src/input_before.dart'; // 遷移先の画面ファイルをインポート

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
    return [
      DrinkData('Red Bull', 20),
      DrinkData('Monster', 35),
      DrinkData('Bang', 30),
      DrinkData('High Brew', 10),
      DrinkData('Rockstar', 50),
    ];
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

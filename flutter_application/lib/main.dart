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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF543b40)),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '飲料摂取の相関',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '平均',
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text('1ヶ月', style: TextStyle(color: Color(0xFFba9ca2))),
                      SizedBox(width: 8),
                      Text('+3%', style: TextStyle(color: Color(0xFF0bda92))),
                    ],
                  ),
                  SizedBox(height: 16),
                  DrinkProgress(title: 'Red Bull', percent: 0.2),
                  DrinkProgress(title: 'Monster', percent: 1.0),
                  DrinkProgress(title: 'Bang', percent: 0.3),
                  DrinkProgress(title: 'High Brew', percent: 0.1),
                  DrinkProgress(title: 'Rockstar', percent: 0.8),
                ],
              ),
            ),
          ),
          // ここからグラフを追加
          Container(
            height: 300, // グラフの高さ
            child: SfCartesianChart(
              title: ChartTitle(text: '時間ごとの飲料消費量'),
              legend: Legend(isVisible: true),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
              series: <CartesianSeries>[
                LineSeries<ChartData, String>(
                  dataSource: getChartData(),
                  xValueMapper: (ChartData data, _) => data.month,
                  yValueMapper: (ChartData data, _) => data.consumption,
                  name: '消費量',
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
          // ここまでグラフを追加
        ],
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

  // グラフデータを取得するメソッド
  List<ChartData> getChartData() {
    return [
      ChartData('1月', 20),
      ChartData('2月', 35),
      ChartData('3月', 40),
      ChartData('4月', 25),
      ChartData('5月', 50),
    ];
  }
}

// データクラス
class ChartData {
  final String month;
  final double consumption;

  ChartData(this.month, this.consumption);
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

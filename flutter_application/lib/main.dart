import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'ダッシュボード',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildGraphCard(
              title: '飲料別の摂取',
              series: ColumnSeries<DrinkData, String>(
                dataSource: getDrinkData(),
                xValueMapper: (DrinkData data, _) => data.drink,
                yValueMapper: (DrinkData data, _) => data.consumption,
                name: '摂取量',
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Colors.blueAccent,
              ),
            ),
            _buildGraphCard(
              title: '飲料別のスコア',
              series: ColumnSeries<FocusData, String>(
                dataSource: getFocusData(),
                xValueMapper: (FocusData data, _) => data.drink,
                yValueMapper: (FocusData data, _) => data.score,
                name: '集中度合い',
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Colors.greenAccent,
              ),
            ),
            _buildGraphCard(
              title: '前日の睡眠時間と集中度合い',
              series: ColumnSeries<SleepFocusData, String>(
                dataSource: getSleepFocusData(),
                xValueMapper: (SleepFocusData data, _) => data.sleepHours,
                yValueMapper: (SleepFocusData data, _) => data.focusScore,
                name: '集中度合い',
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Colors.purpleAccent,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGraphCard({required String title, required CartesianSeries series}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: const Color(0xFF1c1c1c),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries>[series],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<DrinkData> getDrinkData() {
    return [
      DrinkData('Red Bull', 20),
      DrinkData('Monster', 35),
      DrinkData('Bang', 30),
      DrinkData('High Brew', 10),
      DrinkData('Rockstar', 50),
    ];
  }

  static List<FocusData> getFocusData() {
    return [
      FocusData('Red Bull', 80),
      FocusData('Monster', 70),
      FocusData('Bang', 85),
      FocusData('High Brew', 60),
      FocusData('Rockstar', 75),
    ];
  }

  static List<SleepFocusData> getSleepFocusData() {
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

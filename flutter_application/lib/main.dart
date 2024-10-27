import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'src/input_before.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, dynamic>> fetchResult() async {
    final url = Uri.parse('http://10.0.2.2:8000/result');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('データの読み込みに失敗しました');
    }
  }

  Future<Map<String, dynamic>> fetchResult2() async {
    final url = Uri.parse('http://10.0.2.2:8000/result_sleep');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('データの読み込みに失敗しました');
    }
  }

  Future<Map<String, dynamic>> fetchResult3() async {
    final url = Uri.parse('http://10.0.2.2:8000/result_count');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('データの読み込みに失敗しました');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: FutureBuilder<Map<String, dynamic>>(
        future: fetchResult(),
        builder: (context, snapshot1) {
          if (snapshot1.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot1.hasError) {
            return Center(child: Text('エラー: ${snapshot1.error}'));
          } else {
            return FutureBuilder<Map<String, dynamic>>(
              future: fetchResult2(),
              builder: (context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot2.hasError) {
                  return Center(child: Text('エラー: ${snapshot2.error}'));
                } else {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchResult3(),
                    builder: (context, snapshot3) {
                      if (snapshot3.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot3.hasError) {
                        return Center(child: Text('エラー: ${snapshot3.error}'));
                      } else {
                        return DashboardScreen(
                          data: snapshot1.data!,
                          data2: snapshot2.data!,
                          data3: snapshot3.data!,
                        );
                      }
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> data2;
  final Map<String, dynamic> data3;

  const DashboardScreen({Key? key, required this.data, required this.data2, required this.data3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('統計分析画面'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildDrinkScoreChart(),
            _buildConsumptionChart(),
            _buildSleepFocusChart(),
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

  Widget _buildDrinkScoreChart() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black54,
        // color: Colors.black54,
      ),
      child: SfCircularChart(
        title: ChartTitle(text: '飲料別の平均集中時間(1本あたり)'),
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          PieSeries<DrinkData, String>(
            dataSource: getDrinkData(),
            xValueMapper: (DrinkData data, _) => data.drink,
            yValueMapper: (DrinkData data, _) => data.consumption,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionChart() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black54,
      ),
      child: SfCartesianChart(
        title: ChartTitle(text: '飲料別の摂取本数'),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: <CartesianSeries>[
          ColumnSeries<FocusData, String>(
            dataSource: getFocusData(),
            xValueMapper: (FocusData data, _) => data.drink,
            yValueMapper: (FocusData data, _) => data.score,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            color: Colors.blue, // 固定色
            // カラフルにする場合は以下のように設定
            // color: colors[i % colors.length],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepFocusChart() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black54,
      ),
      child: SfCartesianChart(
        title: ChartTitle(text: '睡眠時間と集中度合い'),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: <CartesianSeries>[
          LineSeries<SleepFocusData, String>(
            dataSource: getSleepFocusData(),
            xValueMapper: (SleepFocusData data, _) => data.sleepHours,
            yValueMapper: (SleepFocusData data, _) => data.focusScore,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  List<DrinkData> getDrinkData() {
    List<DrinkData> drinkDataList = [];
    data.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        drinkDataList.add(DrinkData(key, value[0]));
      }
    });
    return drinkDataList;
  }

  List<FocusData> getFocusData() {
    List<FocusData> focusDataList = [];
    data3.forEach((key, value) {
      focusDataList.add(FocusData(key, value.first.toDouble()));
    });
    return focusDataList;
  }

  List<SleepFocusData> getSleepFocusData() {
    List<SleepFocusData> sleepFocusDataList = [];
    data2.forEach((key, value) {
      sleepFocusDataList.add(SleepFocusData('${key}時間', value.first));
    });
    return sleepFocusDataList;
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

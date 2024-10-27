import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'src/input_before.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer';
import 'dart:io';

void main() async {
  await dotenv.load(fileName: ".env");
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

  // data3 を JSON 形式の文字列に変換
  String getJsonString() {
    return jsonEncode(data2); // data3 を JSON 形式の文字列に変換
  }
  // 生成メソッドを追加
  Stream<String> generateExampleSentences(String post) {
    final prompt = '''
    ---
    $post
    ---

    上記の文字列を
    keyを睡眠時間、valueを集中度として、
    健康の観点から分析して
    ''';
    // final prompt = '''
    //   1から10まで出力するコードをpythonで書いて
    // ''';

    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: dotenv.env['GEMINI_API_KEY']!, // .envからAPIキーを読み込み
    );

    final content = [Content.text(prompt)];
    return model.generateContentStream(content).map((response) {
      return response.text ?? 'No response because Gemini API went wrong.';
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
         title: const Text(
           '統計分析画面',
           style: TextStyle(fontSize: 16), // フォントサイズを指定
         ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildDrinkScoreChart(),
            _buildConsumptionChart(),
            _buildSleepFocusChart(),
            SizedBox(height: 50),
            _buildGeneratedExamples(),
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
      margin: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black54,
      ),
      child: SfCircularChart(
        title: ChartTitle(text: '飲料別の平均集中時間(1本あたり)',
          textStyle: TextStyle(fontSize: 11)
        ), // タイトルのフォントサイズを変更),        
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
      margin: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black54,
      ),
      child: SfCartesianChart(
        title: ChartTitle(text: '飲料別の摂取本数',
          textStyle: TextStyle(fontSize: 11)
        ), // タイトルのフォントサイズを変更),
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
      margin: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black54,
      ),
      child: SfCartesianChart(
        title: ChartTitle(
          text: '睡眠時間と集中度合い',
          textStyle: TextStyle(fontSize: 11), // タイトルのフォントサイズを変更
        ),
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

  Widget _buildGeneratedExamples() {
    Future<String> chatting(String inputText) async {
      var apiKey = dotenv.get('GEMINI_API_KEY');
      if (apiKey == null) {
        log('API Key取得失敗');
        exit(1);
      }
      
      final genModel = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [Content.text(inputText)];

      final response = await genModel.generateContent(content);
      String resText = response.text ?? 'Gemini返答失敗';
      return resText;
    }

    final jsonString = getJsonString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // タイトルを中央揃え
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10), // タイトル上部の余白
          child: Align(
            alignment: Alignment.center, // 中央に配置
            child: Text(
              'AIによる分析',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // 適切な色を指定
              ),
            ),
          ),
        ),
        // 既存のContainerウィジェット
        Container(
          height: 800,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(136, 131, 130, 130),
          ),
          child: FutureBuilder<String>(
            future: chatting('このデータを元に健康の観点から分析してみてください。keyは睡眠時間、valueは集中度となっています。: $jsonString '), // chattingメソッドを呼び出す
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('エラー: ${snapshot.error}'));
              } else {
                return Text(
                  snapshot.data ?? 'No examples generated',
                  style: const TextStyle(color: Colors.white),
                );
              }
            },
          ),
        ),
      ],
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

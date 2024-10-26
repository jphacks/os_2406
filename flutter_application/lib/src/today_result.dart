import 'package:flutter/material.dart';
import 'dart:convert';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'input_eveluate.dart';
import 'input_before.dart';


class TMP extends StatelessWidget {
  final String result;
  final InputData data;
  const TMP({Key? key, required this.result, required this.data,}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '登録画面',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: const <Widget>[
                ListTile(
                  title: Text(
                    '日付',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '2024年10月26日(Sat)',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'エナジードリンク名',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      'Red Bull',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),                
                ListTile(
                  title: Text(
                    '飲んだ本数',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '2',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    '作業時間',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '3',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    '前日の睡眠時間',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '8.5',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),                
                ListTile(
                  title: Text(
                    '起床からの時間',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '8',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),                
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(84, 40),
                // primary: const Color(0xFF1980E6),
              ),
              onPressed: () async {
                  try {
                    // APIからデータを取得
                    final resultData = await fetchResult();
                    // DashboardScreenに遷移し、取得したデータを渡す
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(data: resultData),
                      ),
                    );
                  } catch (e) {
                    // エラーハンドリング
                    print("エラー: $e");
                  }
                },
              child: const Text(
                '送信',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
 }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'today_result.dart';
import 'input_before.dart';

class InputEvaluate extends StatefulWidget {
  final InputData data;

  const InputEvaluate({Key? key, required this.data}) : super(key: key);

  @override
  _InputEvaluateState createState() => _InputEvaluateState();
}

class _InputEvaluateState extends State<InputEvaluate> {
  int? _focusedRating; // ラジオボタンの値
  int? _sleepyRating;  // ラジオボタンの値

  // FastAPIからデータを取得するメソッド
  Future<void> sendData() async {
    late Uri url;
    if (Platform.isAndroid) {
      url = Uri.parse('http://10.0.2.2:8000/submit');
    } else if (Platform.isIOS) {
      url = Uri.parse('http://127.0.0.1:8000/submit');
    } else {
      throw Exception('Unsupported platform');
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'energyDrink': widget.data.energyDrink,
        'wakeUpTime': widget.data.wakeUpTime,
        'currentTime': widget.data.currentTime,
        'sleepDuration': widget.data.sleepDuration,
        'focusedRating': _focusedRating,
        'sleepyRating': _sleepyRating,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('データの送信に失敗しました');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // 背景を黒に設定
      appBar: AppBar(
        title: Text(widget.data.energyDrink, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F1F1F), // AppBarの色を変更
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // アイコンを白に
          onPressed: () {
            Navigator.pop(context); // 戻るボタン
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '仕事後、どれくらい集中できましたか？', // 質問文
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // テキストを白に
                  ),
                ),
              ),
              RatingRow(
                groupValue: _focusedRating,
                onChanged: (value) {
                  setState(() {
                    _focusedRating = value; // 選択された値を更新
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '今、どれくらい眠いですか？', // 質問文
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // テキストを白に
                  ),
                ),
              ),
              RatingRow(
                groupValue: _sleepyRating,
                onChanged: (value) {
                  setState(() {
                    _sleepyRating = value; // 選択された値を更新
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(84, 40)),
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF1F1F1F)), // ダークグレーのボタン
                  ),
                  onPressed: () async {
                    try {
                      await sendData(); // データを送信
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TMP(result: '成功', data: widget.data),
                        ),
                      );
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: const Text(
                    '送信',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // テキストを白に
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RatingRow extends StatelessWidget {
  final ValueChanged<int?> onChanged;
  final int? groupValue; // 選択されている値を保持

  const RatingRow({Key? key, required this.onChanged, this.groupValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          5,
              (index) => Radio<int>(
            value: index + 1,
            groupValue: groupValue, // 選択されている値をここで使用
            onChanged: (value) {
              onChanged(value); // 親ウィジェットに値を渡す
            },
            activeColor: Colors.blueAccent, // 選択された時の色を設定
          ),
        ),
      ),
    );
  }
}

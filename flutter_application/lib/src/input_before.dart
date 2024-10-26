import 'package:flutter/material.dart';
import 'ongoing_mode.dart';

// InputData クラスを定義
class InputData {
  final String energyDrink;
  final String wakeUpTime;
  final String currentTime;
  final String sleepDuration;

  InputData({
    required this.energyDrink,
    required this.wakeUpTime,
    required this.currentTime,
    required this.sleepDuration,
  });
}

class PreWorkScreen extends StatefulWidget {
  PreWorkScreen({super.key});

  @override
  _PreWorkScreenState createState() => _PreWorkScreenState();
}

class _PreWorkScreenState extends State<PreWorkScreen> {
  String energyDrink = '';
  String wakeUpTime = '';
  String currentTime = '';
  String lastNightSleepDuration = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // 背景色を黒に
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000), // ダークグレー
        title: const Text(
          '入力画面',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Scrollable Widget
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Energy Drink TextField
            const Text(
              'エナジードリンク名',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  energyDrink = value;
                });
              },
              decoration: InputDecoration(
                hintText: '選択',
                hintStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                filled: true,
                fillColor: const Color(0xFF2C2C2C), // ダークグレー
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFFFFFFFF), width: 1), // 薄いグレーのボーダー
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Wake up time TextField
            const Text(
              '起床時間',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  wakeUpTime = value;
                });
              },
              decoration: InputDecoration(
                hintText: '入力',
                hintStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                filled: true,
                fillColor: const Color(0xFF2C2C2C), // ダークグレー
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFF3E3E3E), width: 1), // 薄いグレーのボーダー
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Current time TextField
            const Text(
              '現在時刻',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  currentTime = value;
                });
              },
              decoration: InputDecoration(
                hintText: '入力',
                hintStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                filled: true,
                fillColor: const Color(0xFF2C2C2C), // ダークグレー
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFF3E3E3E), width: 1), // 薄いグレーのボーダー
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Last night sleep duration TextField
            const Text(
              '前日の睡眠時間',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  lastNightSleepDuration = value;
                });
              },
              decoration: InputDecoration(
                hintText: '入力',
                hintStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                filled: true,
                fillColor: const Color(0xFF2C2C2C), // ダークグレー
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFF3E3E3E), width: 1), // 薄いグレーのボーダー
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE30D38), // 赤色
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // InputData インスタンスを作成し、次の画面に渡す
                      InputData inputData = InputData(
                        energyDrink: energyDrink,
                        wakeUpTime: wakeUpTime,
                        currentTime: currentTime,
                        sleepDuration: lastNightSleepDuration,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FocusScreen(data: inputData)),
                      );
                    },
                    child: const Text('スタート', style: TextStyle(color: Colors.white)), // テキスト色を白に
                  ),
                ),
                const SizedBox(width: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

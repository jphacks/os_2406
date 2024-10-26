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
  String selectedEnergyDrink = '';
  String wakeUpTime = '';
  String currentTime = '';
  String lastNightSleepDuration = '';

  final List<String> energyDrinkOptions = [//ここにエナジードリンクの名前リストを作る
    'Red Bull',
    'MONSTER',
    'ZONE',
    'SURVIVOR!',
    'その他',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // ダークグレーの背景
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F), // 上のバーの色
        title: const Text(
          '入力画面',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Energy Drink Dropdown
            const Text(
              'エナジードリンク名',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildEnergyDrinkDropdown(),
            const SizedBox(height: 8),
            // Wake up time TextField
            const Text(
              '起床時間',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hint: '入力',
              onChanged: (value) => setState(() => wakeUpTime = value),
            ),
            const SizedBox(height: 8),
            // Current time TextField
            const Text(
              '現在時刻',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hint: '入力',
              onChanged: (value) => setState(() => currentTime = value),
            ),
            const SizedBox(height: 8),
            // Last night sleep duration TextField
            const Text(
              '前日の睡眠時間',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hint: '入力',
              onChanged: (value) => setState(() => lastNightSleepDuration = value),
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
                      elevation: 5, // シャドウ効果
                    ),
                    onPressed: () {
                      // InputData インスタンスを作成し、次の画面に渡す
                      InputData inputData = InputData(
                        energyDrink: selectedEnergyDrink,
                        wakeUpTime: wakeUpTime,
                        currentTime: currentTime,
                        sleepDuration: lastNightSleepDuration,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FocusScreen(data: inputData)),
                      );
                    },
                    child: const Text('スタート', style: TextStyle(color: Colors.white)),
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

  Widget _buildEnergyDrinkDropdown() {
    return DropdownButton<String>(
      value: selectedEnergyDrink.isEmpty ? null : selectedEnergyDrink,
      hint: const Text('選択', style: TextStyle(color: Color(0xFFB3B3B3))),
      dropdownColor: const Color(0xFF2C2C2C),
      isExpanded: true,
      onChanged: (String? newValue) {
        setState(() {
          selectedEnergyDrink = newValue ?? '';
        });
      },
      items: energyDrinkOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({required String hint, required ValueChanged<String> onChanged}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB3B3B3)), // 薄いグレー
        filled: true,
        fillColor: const Color(0xFF2C2C2C), // ダークグレー
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFFFFFFFF), width: 1), // 白のボーダー
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

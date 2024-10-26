import 'package:flutter/material.dart';
import 'ongoing_mode.dart';


class PreWorkScreen extends StatelessWidget {
  const PreWorkScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181112),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181112),
        title: const Text(
          'Pre-Work',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const InputField(label: 'Energy Drink', hintText: 'Select'),
            const SizedBox(height: 8),
            const InputField(label: 'Wake up time', hintText: 'Enter'),
            const SizedBox(height: 8),
            const InputField(label: 'Current time', hintText: 'Enter'),
            const SizedBox(height: 8),
            const InputField(label: 'Last night sleep duration', hintText: 'Enter'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE30D38),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FocusScreen()),
                      );
                    },
                    child: const Text('Start Focus Session'),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hintText;

  const InputField({Key? key, required this.label, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFFBA9CA2)),
            filled: true,
            fillColor: const Color(0xFF39282B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

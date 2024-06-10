import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime expiresAt;
  final String chargeId;
  const CountdownTimer({
    super.key,
    required this.expiresAt,
    required this.chargeId,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late DateTime _currentTime;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _remainingSeconds = widget.expiresAt.difference(_currentTime).inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits((seconds ~/ 60) % 60);
    String secs = twoDigits(seconds % 60);
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_remainingSeconds),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

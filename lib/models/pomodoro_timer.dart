import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

enum TimerPhase {
  work,
  shortBreak,
  longBreak,
}

class PomodoroTimer extends ChangeNotifier {
  Timer? _timer;
  int _timeLeft = 25 * 60; // 25 minutes in seconds
  bool _isRunning = false;
  bool _isPaused = false;
  TimerPhase _currentPhase = TimerPhase.work;
  int _completedPomodoros = 0;
  int _completedBreaks = 0;
  AudioPlayer? _audioPlayer;
  bool _soundEnabled = true;

  // Timer durations in seconds
  static const int workDuration = 25 * 60;
  static const int shortBreakDuration = 5 * 60;
  static const int longBreakDuration = 15 * 60;

  PomodoroTimer() {
    _initializeAudio();
  }

  // Initialize audio player
  void _initializeAudio() {
    _audioPlayer = AudioPlayer();
  }

  // Play timeout sound
  Future<void> _playTimeoutSound() async {
    if (!_soundEnabled) return;
    
    try {
      await _audioPlayer?.play(AssetSource('voice/timeout.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing audio: $e');
      }
    }
  }

  // Toggle sound
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  // Getters
  int get timeLeft => _timeLeft;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  TimerPhase get currentPhase => _currentPhase;
  int get completedPomodoros => _completedPomodoros;
  int get completedBreaks => _completedBreaks;
  bool get soundEnabled => _soundEnabled;

  // Format time as MM:SS
  String get formattedTime {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Get phase name
  String get phaseName {
    switch (_currentPhase) {
      case TimerPhase.work:
        return 'Focus Time';
      case TimerPhase.shortBreak:
        return 'Short Break';
      case TimerPhase.longBreak:
        return 'Long Break';
    }
  }

  // Get phase description
  String get phaseDescription {
    switch (_currentPhase) {
      case TimerPhase.work:
        return 'Time to focus and get things done';
      case TimerPhase.shortBreak:
        return 'Take a short break to refresh';
      case TimerPhase.longBreak:
        return 'Enjoy a longer break to recharge';
    }
  }

  // Start timer
  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _isPaused = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0) {
          _timeLeft--;
          notifyListeners();
        } else {
          _completePhase();
        }
      });
      notifyListeners();
    }
  }

  // Pause timer
  void pause() {
    if (_isRunning && !_isPaused) {
      _isPaused = true;
      _timer?.cancel();
      notifyListeners();
    }
  }

  // Resume timer
  void resume() {
    if (_isRunning && _isPaused) {
      _isPaused = false;
      start();
    }
  }

  // Stop timer
  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _resetCurrentPhase();
    notifyListeners();
  }

  // Reset timer
  void reset() {
    stop();
    _completedPomodoros = 0;
    _completedBreaks = 0;
    _currentPhase = TimerPhase.work;
    _resetCurrentPhase();
    notifyListeners();
  }

  // Skip to next phase
  void skip() {
    _completePhase();
  }

  // Complete current phase and move to next
  void _completePhase() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;

    // Play timeout sound
    _playTimeoutSound();

    switch (_currentPhase) {
      case TimerPhase.work:
        _completedPomodoros++;
        // After 4 pomodoros, take a long break, otherwise short break
        if (_completedPomodoros % 4 == 0) {
          _currentPhase = TimerPhase.longBreak;
          _timeLeft = longBreakDuration;
        } else {
          _currentPhase = TimerPhase.shortBreak;
          _timeLeft = shortBreakDuration;
        }
        break;
      case TimerPhase.shortBreak:
      case TimerPhase.longBreak:
        _completedBreaks++;
        _currentPhase = TimerPhase.work;
        _timeLeft = workDuration;
        break;
    }

    notifyListeners();
  }

  // Reset current phase timer
  void _resetCurrentPhase() {
    switch (_currentPhase) {
      case TimerPhase.work:
        _timeLeft = workDuration;
        break;
      case TimerPhase.shortBreak:
        _timeLeft = shortBreakDuration;
        break;
      case TimerPhase.longBreak:
        _timeLeft = longBreakDuration;
        break;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }
}
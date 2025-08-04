import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pomodoro_timer.dart';

class TimerDisplaySimple extends StatelessWidget {
  const TimerDisplaySimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroTimer>(
      builder: (context, timer, child) {
        final progress = _calculateProgress(timer);
        final color = _getPhaseColor(timer.currentPhase);
        
        // Make the timer responsive
        final screenWidth = MediaQuery.of(context).size.width;
        final timerSize = screenWidth < 600 ? 240.0 : 280.0;
        final strokeWidth = screenWidth < 600 ? 6.0 : 8.0;
        
        return Container(
          width: timerSize,
          height: timerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: timerSize,
                height: timerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              
              // Progress circle
              SizedBox(
                width: timerSize,
                height: timerSize,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: strokeWidth,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              
              // Timer text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timer.formattedTime,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF1F2937),
                      letterSpacing: 2,
                      fontSize: screenWidth < 600 ? 48 : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timer.phaseName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth < 600 ? 14 : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timer.phaseDescription,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B7280),
                      fontSize: screenWidth < 600 ? 11 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateProgress(PomodoroTimer timer) {
    int totalTime;
    switch (timer.currentPhase) {
      case TimerPhase.work:
        totalTime = PomodoroTimer.workDuration;
        break;
      case TimerPhase.shortBreak:
        totalTime = PomodoroTimer.shortBreakDuration;
        break;
      case TimerPhase.longBreak:
        totalTime = PomodoroTimer.longBreakDuration;
        break;
    }
    
    return 1.0 - (timer.timeLeft / totalTime);
  }

  Color _getPhaseColor(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.work:
        return const Color(0xFFEF4444); // Red
      case TimerPhase.shortBreak:
        return const Color(0xFF10B981); // Green
      case TimerPhase.longBreak:
        return const Color(0xFF3B82F6); // Blue
    }
  }
}
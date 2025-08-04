import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pomodoro_timer.dart';

class PhaseIndicator extends StatelessWidget {
  const PhaseIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroTimer>(
      builder: (context, timer, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPhaseDot(TimerPhase.work, timer.currentPhase),
              _buildPhaseLine(),
              _buildPhaseDot(TimerPhase.shortBreak, timer.currentPhase),
              _buildPhaseLine(),
              _buildPhaseDot(TimerPhase.longBreak, timer.currentPhase),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildPhaseDot(TimerPhase phase, TimerPhase currentPhase) {
    final isActive = phase == currentPhase;
    final color = _getPhaseColor(phase);
    
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : color.withOpacity(0.3),
        boxShadow: isActive ? [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ] : null,
      ),
    ).animate(target: isActive ? 1 : 0).scale(
      duration: 300.ms,
      curve: Curves.easeInOut,
    );
  }

  Widget _buildPhaseLine() {
    return Container(
      width: 20,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Color _getPhaseColor(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.work:
        return const Color(0xFFEF4444);
      case TimerPhase.shortBreak:
        return const Color(0xFF10B981);
      case TimerPhase.longBreak:
        return const Color(0xFF3B82F6);
    }
  }
}
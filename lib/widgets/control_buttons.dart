import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pomodoro_timer.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroTimer>(
      builder: (context, timer, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 600;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reset button
            _buildButton(
              context,
              icon: Icons.refresh,
              label: 'Reset',
              onPressed: timer.reset,
              color: const Color(0xFF6B7280),
              isSmallScreen: isSmallScreen,
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            
            // Main control button (Start/Pause/Resume)
            _buildMainButton(context, timer, isSmallScreen),
            SizedBox(width: isSmallScreen ? 12 : 16),
            
            // Skip button
            _buildButton(
              context,
              icon: Icons.skip_next,
              label: 'Skip',
              onPressed: timer.skip,
              color: const Color(0xFF6B7280),
              isSmallScreen: isSmallScreen,
            ),
          ],
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildMainButton(BuildContext context, PomodoroTimer timer, bool isSmallScreen) {
    IconData icon;
    String label;
    VoidCallback onPressed;
    Color color;

    if (!timer.isRunning) {
      icon = Icons.play_arrow;
      label = 'Start';
      onPressed = timer.start;
      color = const Color(0xFF10B981);
    } else if (timer.isPaused) {
      icon = Icons.play_arrow;
      label = 'Resume';
      onPressed = timer.resume;
      color = const Color(0xFF10B981);
    } else {
      icon = Icons.pause;
      label = 'Pause';
      onPressed = timer.pause;
      color = const Color(0xFFF59E0B);
    }

    final buttonSize = isSmallScreen ? 100.0 : 120.0;
    final iconSize = isSmallScreen ? 28.0 : 32.0;
    final fontSize = isSmallScreen ? 12.0 : 14.0;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: iconSize,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(
      duration: 200.ms,
      curve: Curves.easeInOut,
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required bool isSmallScreen,
  }) {
    final buttonSize = isSmallScreen ? 70.0 : 80.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final fontSize = isSmallScreen ? 10.0 : 12.0;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: iconSize,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
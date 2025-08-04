import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pomodoro_timer.dart';
import '../widgets/timer_display.dart';
import '../widgets/control_buttons.dart';
import '../widgets/phase_indicator.dart';
import '../widgets/stats_card.dart';
import '../widgets/phase_completion_notification.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                            MediaQuery.of(context).padding.top - 
                            MediaQuery.of(context).padding.bottom,
                ),
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(context),
                    SizedBox(height: isSmallScreen ? 24 : 40),
                    
                    // Main timer section
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Phase indicator
                        const PhaseIndicator(),
                        SizedBox(height: isSmallScreen ? 24 : 32),
                        
                        // Timer display
                        const TimerDisplay(),
                        SizedBox(height: isSmallScreen ? 32 : 48),
                        
                        // Control buttons
                        const ControlButtons(),
                        SizedBox(height: isSmallScreen ? 32 : 48),
                        
                        // Stats
                        const StatsCard(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Phase completion notification
            const PhaseCompletionNotification(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pomodoro',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                  fontSize: isSmallScreen ? 24 : null,
                ),
              ),
              Text(
                'Stay focused, stay productive',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                  fontSize: isSmallScreen ? 12 : null,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            // Sound toggle button
            Consumer<PomodoroTimer>(
              builder: (context, timer, child) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: timer.toggleSound,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          timer.soundEnabled ? Icons.volume_up : Icons.volume_off,
                          color: timer.soundEnabled 
                              ? Theme.of(context).colorScheme.primary
                              : const Color(0xFF6B7280),
                          size: isSmallScreen ? 20 : 24,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3, end: 0);
              },
            ),
            // Timer icon
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.timer_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0);
  }
}
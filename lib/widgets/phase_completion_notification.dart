import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pomodoro_timer.dart';

class PhaseCompletionNotification extends StatefulWidget {
  const PhaseCompletionNotification({super.key});

  @override
  State<PhaseCompletionNotification> createState() => _PhaseCompletionNotificationState();
}

class _PhaseCompletionNotificationState extends State<PhaseCompletionNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showNotification = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showPhaseCompletionMessage(String message) {
    setState(() {
      _message = message;
      _showNotification = true;
    });
    _animationController.forward();

    // Hide notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animationController.reverse().then((_) {
          setState(() {
            _showNotification = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroTimer>(
      builder: (context, timer, child) {
        // Listen for phase changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (timer.timeLeft == 0 && timer.isRunning == false) {
            String message = '';
            switch (timer.currentPhase) {
              case TimerPhase.work:
                message = '🎉 Focus session completed! Time for a break.';
                break;
              case TimerPhase.shortBreak:
                message = '☕ Short break finished! Back to work.';
                break;
              case TimerPhase.longBreak:
                message = '🌟 Long break completed! Ready to focus again.';
                break;
            }
            _showPhaseCompletionMessage(message);
          }
        });

        if (!_showNotification) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 100,
          left: 20,
          right: 20,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _message,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _animationController.reverse().then((_) {
                              setState(() {
                                _showNotification = false;
                              });
                            });
                          },
                          icon: const Icon(Icons.close, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
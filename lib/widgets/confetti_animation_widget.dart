import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiAnimationWidget extends StatefulWidget {
  final bool isPlaying;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration duration;
  final int particleCount;

  const ConfettiAnimationWidget({
    super.key,
    required this.isPlaying,
    this.primaryColor = const Color(0xFF6B73FF),
    this.secondaryColor = const Color(0xFF48BB78),
    this.duration = const Duration(milliseconds: 2000),
    this.particleCount = 50,
  });

  @override
  State<ConfettiAnimationWidget> createState() =>
      _ConfettiAnimationWidgetState();
}

class _ConfettiAnimationWidgetState extends State<ConfettiAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _generateParticles();

    if (widget.isPlaying) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ConfettiAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _generateParticles();
      _controller.forward();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateParticles() {
    final random = Random();
    _particles = List.generate(widget.particleCount, (index) {
      return ConfettiParticle(
        color: random.nextBool() ? widget.primaryColor : widget.secondaryColor,
        startX: random.nextDouble(),
        startY: random.nextDouble() * 0.3,
        velocityX: (random.nextDouble() - 0.5) * 2,
        velocityY: random.nextDouble() * 2 + 1,
        size: random.nextDouble() * 8 + 4,
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 4,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class ConfettiParticle {
  final Color color;
  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final double size;
  final double rotation;
  final double rotationSpeed;

  ConfettiParticle({
    required this.color,
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(
          alpha: (1.0 - progress * 0.8).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;

      final x = (particle.startX + particle.velocityX * progress) * size.width;
      final y = (particle.startY + particle.velocityY * progress) * size.height;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + particle.rotationSpeed * progress);

      // Draw confetti shape (rectangle or circle)
      if (particle.size > 6) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 0.6,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, particle.size / 2, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

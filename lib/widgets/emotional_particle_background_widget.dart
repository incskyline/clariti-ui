import 'dart:math';
import 'package:flutter/material.dart';

class EmotionalParticleBackground extends StatefulWidget {
  final Widget child;
  final EmotionType? emotionType;

  const EmotionalParticleBackground({
    super.key,
    required this.child,
    this.emotionType,
  });

  @override
  State<EmotionalParticleBackground> createState() =>
      _EmotionalParticleBackgroundState();
}

class _EmotionalParticleBackgroundState
    extends State<EmotionalParticleBackground> with TickerProviderStateMixin {
  late AnimationController _particleController;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _initializeParticles();
  }

  @override
  void didUpdateWidget(EmotionalParticleBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.emotionType != widget.emotionType) {
      _initializeParticles();
    }
  }

  void _initializeParticles() {
    _particles = List.generate(20, (index) => _createParticle());
  }

  Particle _createParticle() {
    final emotion = widget.emotionType ?? EmotionType.calm;
    return Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 4 + 2,
      speed: _getSpeedForEmotion(emotion),
      direction: _getDirectionForEmotion(emotion),
      color: _getColorForEmotion(emotion),
      opacity: _random.nextDouble() * 0.3 + 0.1,
    );
  }

  double _getSpeedForEmotion(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.excited:
        return _random.nextDouble() * 0.008 + 0.004;
      case EmotionType.anxious:
        return _random.nextDouble() * 0.003 + 0.002;
      case EmotionType.hopeful:
        return _random.nextDouble() * 0.005 + 0.003;
      case EmotionType.calm:
        return _random.nextDouble() * 0.002 + 0.001;
      case EmotionType.curious:
        return _random.nextDouble() * 0.006 + 0.003;
      case EmotionType.confused:
        return _random.nextDouble() * 0.004 + 0.002;
    }
  }

  Offset _getDirectionForEmotion(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.hopeful:
        return Offset(_random.nextDouble() * 0.4 - 0.2,
            -_random.nextDouble() * 0.6 - 0.2);
      case EmotionType.anxious:
        return Offset(
            _random.nextDouble() * 0.8 - 0.4, _random.nextDouble() * 0.4 + 0.1);
      case EmotionType.excited:
        return Offset(
            _random.nextDouble() * 1.2 - 0.6, _random.nextDouble() * 1.2 - 0.6);
      case EmotionType.calm:
        return Offset(_random.nextDouble() * 0.3 - 0.15,
            _random.nextDouble() * 0.2 - 0.1);
      case EmotionType.curious:
        return Offset(
            _random.nextDouble() * 0.6 - 0.3, _random.nextDouble() * 0.6 - 0.3);
      case EmotionType.confused:
        return Offset(
            _random.nextDouble() * 0.8 - 0.4, _random.nextDouble() * 0.8 - 0.4);
    }
  }

  Color _getColorForEmotion(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.anxious:
        return const Color(0xFF8B8B8B);
      case EmotionType.hopeful:
        return const Color(0xFFFF8C00);
      case EmotionType.curious:
        return const Color(0xFFFFD700);
      case EmotionType.calm:
        return const Color(0xFF4FD1C7);
      case EmotionType.confused:
        return const Color(0xFF6B73FF);
      case EmotionType.excited:
        return const Color(0xFFFF6B9D);
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.emotionType != null)
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_particles, _particleController.value),
                size: Size.infinite,
              );
            },
          ),
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final Offset direction;
  final Color color;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.direction,
    required this.color,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      // Update particle position
      particle.x += particle.direction.dx * particle.speed;
      particle.y += particle.direction.dy * particle.speed;

      // Wrap around screen
      if (particle.x > 1.0) particle.x = 0.0;
      if (particle.x < 0.0) particle.x = 1.0;
      if (particle.y > 1.0) particle.y = 0.0;
      if (particle.y < 0.0) particle.y = 1.0;

      paint.color = particle.color.withValues(alpha: particle.opacity);
      paint.style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum EmotionType {
  anxious,
  hopeful,
  curious,
  calm,
  confused,
  excited,
}

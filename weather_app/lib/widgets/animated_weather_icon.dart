import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';

/// An animated widget that displays the large weather icon using
/// a floating + pulsing animation.
class AnimatedWeatherIcon extends StatefulWidget {
  final WeatherCondition condition;
  final double size;
  final Color? color;

  const AnimatedWeatherIcon({
    super.key,
    required this.condition,
    this.size = 120,
    this.color,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _pulseController;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _pulseController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: _buildIcon(),
          ),
        );
      },
    );
  }

  Widget _buildIcon() {
    final emoji = WeatherUtils.getWeatherEmoji(widget.condition);
    return _WeatherIconPainter(
      condition: widget.condition,
      size: widget.size,
      emoji: emoji,
    );
  }
}

/// Renders the weather icon using a combination of emoji + a custom glow.
class _WeatherIconPainter extends StatelessWidget {
  final WeatherCondition condition;
  final double size;
  final String emoji;

  const _WeatherIconPainter({
    required this.condition,
    required this.size,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow / shadow circle behind icon
        Container(
          width: size * 1.2,
          height: size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _glowColor.withOpacity(0.3),
                blurRadius: size * 0.5,
                spreadRadius: size * 0.1,
              ),
            ],
          ),
        ),
        // Emoji icon
        Text(
          emoji,
          style: TextStyle(fontSize: size * 0.75),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color get _glowColor {
    switch (condition) {
      case WeatherCondition.sunny:
        return Colors.yellow;
      case WeatherCondition.rainy:
      case WeatherCondition.stormy:
        return Colors.blue;
      case WeatherCondition.snowy:
        return Colors.lightBlue;
      default:
        return Colors.white;
    }
  }
}

/// Renders multiple animated background particles (bubbles / raindrops).
class WeatherParticles extends StatefulWidget {
  final WeatherCondition condition;

  const WeatherParticles({super.key, required this.condition});

  @override
  State<WeatherParticles> createState() => _WeatherParticlesState();
}

class _WeatherParticlesState extends State<WeatherParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            condition: widget.condition,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final WeatherCondition condition;
  final double progress;

  _ParticlePainter({required this.condition, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    switch (condition) {
      case WeatherCondition.rainy:
      case WeatherCondition.stormy:
        _paintRain(canvas, size);
        break;
      case WeatherCondition.snowy:
        _paintSnow(canvas, size);
        break;
      case WeatherCondition.sunny:
        _paintSunRays(canvas, size);
        break;
      default:
        _paintClouds(canvas, size);
    }
  }

  void _paintRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlue.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const cols = 12;
    const rows = 20;
    for (int c = 0; c < cols; c++) {
      for (int r = 0; r < rows; r++) {
        final x = (c / cols) * size.width + (c.isEven ? 10.0 : 0.0);
        final rawY = ((r / rows) + progress * 1.2) % 1.0;
        final y = rawY * size.height;
        canvas.drawLine(
          Offset(x, y),
          Offset(x - 3, y + 14),
          paint,
        );
      }
    }
  }

  void _paintSnow(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    const count = 40;
    for (int i = 0; i < count; i++) {
      final x = ((i * 37 % 100) / 100) * size.width;
      final rawY = ((i * 13 % 100) / 100 + progress * 0.5) % 1.0;
      final y = rawY * size.height;
      final radius = 2.0 + (i % 3) * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _paintSunRays(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.1)
      ..strokeWidth = 2;

    final center = Offset(size.width * 0.75, size.height * 0.2);
    const rays = 12;
    for (int i = 0; i < rays; i++) {
      final angle = (i / rays) * 2 * 3.14159 + progress * 0.5;
      final dx = 80.0 * (angle).abs() % size.width;
      canvas.drawLine(
        center,
        Offset(
          center.dx + dx * 0.8,
          center.dy + dx * 0.8,
        ),
        paint,
      );
    }
  }

  void _paintClouds(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final x = ((i * 0.25) + progress * 0.1) % 1.0 * size.width;
      final y = size.height * (0.15 + i * 0.1);
      final radius = 30.0 + i * 15;
      canvas.drawCircle(Offset(x, y), radius, paint);
      canvas.drawCircle(Offset(x + radius, y + 5), radius * 0.8, paint);
      canvas.drawCircle(Offset(x - radius * 0.6, y + 8), radius * 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) =>
      old.progress != progress || old.condition != condition;
}

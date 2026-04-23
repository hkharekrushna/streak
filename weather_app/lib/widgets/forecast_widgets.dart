import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';

/// A horizontally-scrollable list of hourly forecasts.
class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> forecasts;
  final Color textColor;

  const HourlyForecastList({
    super.key,
    required this.forecasts,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Hourly Forecast',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return _HourlyItem(
                forecast: forecasts[index],
                textColor: textColor,
                isNow: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HourlyItem extends StatelessWidget {
  final HourlyForecast forecast;
  final Color textColor;
  final bool isNow;

  const _HourlyItem({
    required this.forecast,
    required this.textColor,
    required this.isNow,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel =
        isNow ? 'Now' : DateFormat('h a').format(forecast.time);

    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isNow
            ? Colors.white.withOpacity(0.28)
            : Colors.white.withOpacity(0.12),
        border: Border.all(
          color: isNow
              ? Colors.white.withOpacity(0.5)
              : Colors.white.withOpacity(0.15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timeLabel,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 12,
              fontWeight: isNow ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            WeatherUtils.getWeatherEmoji(forecast.condition),
            style: const TextStyle(fontSize: 22),
          ),
          Text(
            '${forecast.temperature.toStringAsFixed(0)}°',
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A 7-day forecast list.
class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> forecasts;
  final Color textColor;

  const DailyForecastList({
    super.key,
    required this.forecasts,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '7-Day Forecast',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.12),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: forecasts.length,
            separatorBuilder: (_, __) => Divider(
              color: Colors.white.withOpacity(0.1),
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              return _DailyRow(
                forecast: forecasts[index],
                textColor: textColor,
                isToday: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DailyRow extends StatelessWidget {
  final DailyForecast forecast;
  final Color textColor;
  final bool isToday;

  const _DailyRow({
    required this.forecast,
    required this.textColor,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final dayLabel =
        isToday ? 'Today' : DateFormat('EEEE').format(forecast.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              dayLabel,
              style: TextStyle(
                color: textColor,
                fontWeight:
                    isToday ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            WeatherUtils.getWeatherEmoji(forecast.condition),
            style: const TextStyle(fontSize: 20),
          ),
          if (forecast.precipitationChance > 0) ...[
            const SizedBox(width: 4),
            Text(
              '${forecast.precipitationChance}%',
              style: TextStyle(
                color: Colors.lightBlueAccent.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
          const Spacer(),
          Text(
            '${forecast.minTemp.toStringAsFixed(0)}°',
            style: TextStyle(
              color: textColor.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          _TempBar(
            minTemp: forecast.minTemp,
            maxTemp: forecast.maxTemp,
            textColor: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            '${forecast.maxTemp.toStringAsFixed(0)}°',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A small temperature range bar.
class _TempBar extends StatelessWidget {
  final double minTemp;
  final double maxTemp;
  final Color textColor;

  const _TempBar({
    required this.minTemp,
    required this.maxTemp,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Normalize relative to a plausible range (0–40°C)
    final low = (minTemp.clamp(0, 40) / 40).clamp(0.0, 1.0);
    final high = (maxTemp.clamp(0, 40) / 40).clamp(0.0, 1.0);

    return SizedBox(
      width: 60,
      height: 6,
      child: CustomPaint(
        painter: _TempBarPainter(low: low, high: high),
      ),
    );
  }
}

class _TempBarPainter extends CustomPainter {
  final double low;
  final double high;

  _TempBarPainter({required this.low, required this.high});

  @override
  void paint(Canvas canvas, Size size) {
    // Background track
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(3),
      ),
      Paint()..color = Colors.white.withOpacity(0.2),
    );

    // Active range
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          low * size.width,
          0,
          (high - low) * size.width,
          size.height,
        ),
        const Radius.circular(3),
      ),
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.lightBlue, Colors.orangeAccent],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(_TempBarPainter old) =>
      old.low != low || old.high != high;
}

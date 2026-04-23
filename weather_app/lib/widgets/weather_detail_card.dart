import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';

/// A glass-morphism style card that shows a single weather detail
/// (e.g. humidity, wind speed, UV index).
class WeatherDetailCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color textColor;

  const WeatherDetailCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: textColor.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A horizontal row of [WeatherDetailCard] widgets.
class WeatherDetailsGrid extends StatelessWidget {
  final WeatherData weather;
  final Color textColor;

  const WeatherDetailsGrid({
    super.key,
    required this.weather,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final windDir = WeatherUtils.getWindDirection(weather.windDegree);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: WeatherDetailCard(
                label: 'Humidity',
                value: '${weather.humidity}',
                unit: '%',
                icon: Icons.water_drop_outlined,
                textColor: textColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WeatherDetailCard(
                label: 'Wind',
                value: '${weather.windSpeed.toStringAsFixed(0)} $windDir',
                unit: 'km/h',
                icon: Icons.air,
                textColor: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: WeatherDetailCard(
                label: 'Feels Like',
                value: '${weather.feelsLike.toStringAsFixed(0)}',
                unit: '°C',
                icon: Icons.thermostat_outlined,
                textColor: textColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WeatherDetailCard(
                label: 'UV Index',
                value: '${weather.uvIndex}',
                unit: _uvLabel(weather.uvIndex),
                icon: Icons.wb_sunny_outlined,
                textColor: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: WeatherDetailCard(
                label: 'Visibility',
                value: '${weather.visibility.toStringAsFixed(0)}',
                unit: 'km',
                icon: Icons.visibility_outlined,
                textColor: textColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WeatherDetailCard(
                label: 'Pressure',
                value: '${weather.pressure}',
                unit: 'hPa',
                icon: Icons.speed_outlined,
                textColor: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _uvLabel(int uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Mod';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'V.High';
    return 'Extreme';
  }
}

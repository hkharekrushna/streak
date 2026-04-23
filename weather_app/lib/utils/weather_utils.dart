import 'package:flutter/material.dart';
import '../models/weather_model.dart';

/// Utility helpers for weather UI decisions.
class WeatherUtils {
  WeatherUtils._();

  /// Returns the emoji icon for a given [WeatherCondition].
  static String getWeatherEmoji(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return '☀️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.partlyCloudy:
        return '⛅';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.stormy:
        return '⛈️';
      case WeatherCondition.snowy:
        return '❄️';
      case WeatherCondition.foggy:
        return '🌫️';
      case WeatherCondition.windy:
        return '💨';
    }
  }

  /// Returns a gradient appropriate for the current [WeatherCondition]
  /// and whether it is currently [isDay].
  static List<Color> getGradientColors(
      WeatherCondition condition, bool isDay) {
    if (!isDay) {
      return [
        const Color(0xFF0D1B2A),
        const Color(0xFF1B2A4A),
        const Color(0xFF1F3460),
      ];
    }

    switch (condition) {
      case WeatherCondition.sunny:
        return [
          const Color(0xFF1E90FF),
          const Color(0xFF00BFFF),
          const Color(0xFFFFD700),
        ];
      case WeatherCondition.partlyCloudy:
        return [
          const Color(0xFF2980B9),
          const Color(0xFF6DD5FA),
          const Color(0xFFB0D4F1),
        ];
      case WeatherCondition.cloudy:
        return [
          const Color(0xFF4B6CB7),
          const Color(0xFF6B7280),
          const Color(0xFF9CA3AF),
        ];
      case WeatherCondition.rainy:
        return [
          const Color(0xFF2C3E50),
          const Color(0xFF3A506B),
          const Color(0xFF4A5568),
        ];
      case WeatherCondition.stormy:
        return [
          const Color(0xFF1A1A2E),
          const Color(0xFF16213E),
          const Color(0xFF0F3460),
        ];
      case WeatherCondition.snowy:
        return [
          const Color(0xFF8EC5FC),
          const Color(0xFFB8C9E8),
          const Color(0xFFE0E9F8),
        ];
      case WeatherCondition.foggy:
        return [
          const Color(0xFF757F9A),
          const Color(0xFF8B95A9),
          const Color(0xFFD7DDE8),
        ];
      case WeatherCondition.windy:
        return [
          const Color(0xFF2980B9),
          const Color(0xFF5D9ABF),
          const Color(0xFF8EC5E8),
        ];
    }
  }

  /// Returns a human-readable label for a [WeatherCondition].
  static String getConditionLabel(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return 'Sunny';
      case WeatherCondition.cloudy:
        return 'Cloudy';
      case WeatherCondition.partlyCloudy:
        return 'Partly Cloudy';
      case WeatherCondition.rainy:
        return 'Rainy';
      case WeatherCondition.stormy:
        return 'Stormy';
      case WeatherCondition.snowy:
        return 'Snowy';
      case WeatherCondition.foggy:
        return 'Foggy';
      case WeatherCondition.windy:
        return 'Windy';
    }
  }

  /// Returns the wind direction label from degrees.
  static String getWindDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return directions[((degrees + 22) / 45).floor() % 8];
  }

  /// Returns whether the current time is during daytime given
  /// [sunrise] and [sunset].
  static bool isDay(DateTime sunrise, DateTime sunset) {
    final now = DateTime.now();
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }

  /// Returns a [Color] that contrasts well against the gradient backgrounds.
  static Color getTextColor(WeatherCondition condition, bool isDay) {
    if (!isDay) return Colors.white;
    switch (condition) {
      case WeatherCondition.snowy:
      case WeatherCondition.foggy:
        return const Color(0xFF1A202C);
      default:
        return Colors.white;
    }
  }
}

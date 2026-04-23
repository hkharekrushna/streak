import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/weather_utils.dart';
import 'package:weather_app/widgets/weather_detail_card.dart';

void main() {
  // ──────────────────────────────────────────
  // Unit tests for WeatherUtils
  // ──────────────────────────────────────────
  group('WeatherUtils', () {
    test('getWeatherEmoji returns correct emoji for each condition', () {
      expect(WeatherUtils.getWeatherEmoji(WeatherCondition.sunny), '☀️');
      expect(WeatherUtils.getWeatherEmoji(WeatherCondition.cloudy), '☁️');
      expect(WeatherUtils.getWeatherEmoji(WeatherCondition.partlyCloudy), '⛅');
      expect(WeatherUtils.getWeatherEmoji(WeatherCondition.rainy), '🌧️');
      expect(WeatherUtils.getWeatherEmoji(WeatherCondition.stormy), '⛈️');
      expect(WeatherUtils.getWeatherEmoji(WeatherCondition.snowy), '❄️');
      expect(WeatherUtils.getWeatherEmoji(WeatherCondition.foggy), '🌫️');
      expect(WeatherUtils.getWeatherEmoji(WeatherCondition.windy), '💨');
    });

    test('getConditionLabel returns correct label', () {
      expect(WeatherUtils.getConditionLabel(WeatherCondition.sunny), 'Sunny');
      expect(WeatherUtils.getConditionLabel(WeatherCondition.partlyCloudy),
          'Partly Cloudy');
      expect(WeatherUtils.getConditionLabel(WeatherCondition.stormy), 'Stormy');
    });

    test('getWindDirection handles cardinal directions', () {
      expect(WeatherUtils.getWindDirection(0), 'N');
      expect(WeatherUtils.getWindDirection(90), 'E');
      expect(WeatherUtils.getWindDirection(180), 'S');
      expect(WeatherUtils.getWindDirection(270), 'W');
    });

    test('getGradientColors returns 3 colours for each condition', () {
      for (final condition in WeatherCondition.values) {
        final colors = WeatherUtils.getGradientColors(condition, true);
        expect(colors.length, 3,
            reason: 'Expected 3 gradient colors for $condition');
      }
      // Night gradient
      final nightColors =
          WeatherUtils.getGradientColors(WeatherCondition.sunny, false);
      expect(nightColors.length, 3);
    });

    test('isDay returns false when current time is outside sunrise/sunset', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final pastSunrise = DateTime(
          yesterday.year, yesterday.month, yesterday.day, 6, 0);
      final pastSunset = DateTime(
          yesterday.year, yesterday.month, yesterday.day, 19, 0);
      expect(WeatherUtils.isDay(pastSunrise, pastSunset), false);
    });
  });

  // ──────────────────────────────────────────
  // Unit tests for WeatherData.mock()
  // ──────────────────────────────────────────
  group('WeatherData.mock()', () {
    late WeatherData mock;
    setUp(() => mock = WeatherData.mock());

    test('has valid city name', () {
      expect(mock.cityName, isNotEmpty);
    });

    test('has 24 hourly forecasts', () {
      expect(mock.hourlyForecast.length, 24);
    });

    test('has 7 daily forecasts', () {
      expect(mock.dailyForecast.length, 7);
    });

    test('temperature is within a plausible range', () {
      expect(mock.temperature, greaterThan(-50));
      expect(mock.temperature, lessThan(60));
    });

    test('humidity is between 0 and 100', () {
      expect(mock.humidity, inInclusiveRange(0, 100));
    });

    test('daily forecast first entry minTemp <= maxTemp', () {
      for (final day in mock.dailyForecast) {
        expect(day.minTemp, lessThanOrEqualTo(day.maxTemp));
      }
    });
  });

  // ──────────────────────────────────────────
  // Widget tests
  // ──────────────────────────────────────────
  group('WeatherDetailCard widget', () {
    testWidgets('renders label, value, and unit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDetailCard(
              label: 'Humidity',
              value: '65',
              unit: '%',
              icon: Icons.water_drop_outlined,
              textColor: Colors.white,
            ),
          ),
        ),
      );

      expect(find.text('Humidity'), findsOneWidget);
      expect(find.text('65'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);
    });
  });

  group('WeatherApp smoke test', () {
    testWidgets('app launches without crashing', (tester) async {
      await tester.pumpWidget(const WeatherApp());
      // Allow animations to settle
      await tester.pump(const Duration(seconds: 1));
      // The main temperature text should be visible
      expect(find.textContaining('°C'), findsWidgets);
    });
  });
}

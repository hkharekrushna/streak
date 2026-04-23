/// Represents the current weather condition type.
enum WeatherCondition {
  sunny,
  cloudy,
  partlyCloudy,
  rainy,
  stormy,
  snowy,
  foggy,
  windy,
}

/// A single hourly forecast data point.
class HourlyForecast {
  final DateTime time;
  final double temperature;
  final WeatherCondition condition;
  final int precipitationChance;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.precipitationChance,
  });
}

/// A single daily forecast data point.
class DailyForecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final WeatherCondition condition;
  final int precipitationChance;

  const DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.precipitationChance,
  });
}

/// Full weather data for a location.
class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final double visibility;
  final int uvIndex;
  final int pressure;
  final WeatherCondition condition;
  final String description;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime lastUpdated;
  final List<HourlyForecast> hourlyForecast;
  final List<DailyForecast> dailyForecast;

  const WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.visibility,
    required this.uvIndex,
    required this.pressure,
    required this.condition,
    required this.description,
    required this.sunrise,
    required this.sunset,
    required this.lastUpdated,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  /// Provides a mock [WeatherData] for demonstration / testing.
  factory WeatherData.mock() {
    final now = DateTime.now();
    return WeatherData(
      cityName: 'San Francisco',
      country: 'US',
      temperature: 22,
      feelsLike: 21,
      minTemp: 17,
      maxTemp: 25,
      humidity: 65,
      windSpeed: 14,
      windDegree: 220,
      visibility: 10,
      uvIndex: 5,
      pressure: 1013,
      condition: WeatherCondition.partlyCloudy,
      description: 'Partly Cloudy',
      sunrise: DateTime(now.year, now.month, now.day, 6, 23),
      sunset: DateTime(now.year, now.month, now.day, 19, 47),
      lastUpdated: now,
      hourlyForecast: List.generate(
        24,
        (i) => HourlyForecast(
          time: now.add(Duration(hours: i)),
          temperature: 22 + (i % 6 - 3) * 1.5,
          condition: _conditionForHour(i),
          precipitationChance: (i % 8 == 3) ? 40 : 10,
        ),
      ),
      dailyForecast: [
        DailyForecast(
          date: now,
          minTemp: 17,
          maxTemp: 25,
          condition: WeatherCondition.partlyCloudy,
          precipitationChance: 10,
        ),
        DailyForecast(
          date: now.add(const Duration(days: 1)),
          minTemp: 15,
          maxTemp: 22,
          condition: WeatherCondition.cloudy,
          precipitationChance: 30,
        ),
        DailyForecast(
          date: now.add(const Duration(days: 2)),
          minTemp: 13,
          maxTemp: 19,
          condition: WeatherCondition.rainy,
          precipitationChance: 70,
        ),
        DailyForecast(
          date: now.add(const Duration(days: 3)),
          minTemp: 16,
          maxTemp: 23,
          condition: WeatherCondition.sunny,
          precipitationChance: 5,
        ),
        DailyForecast(
          date: now.add(const Duration(days: 4)),
          minTemp: 18,
          maxTemp: 26,
          condition: WeatherCondition.sunny,
          precipitationChance: 0,
        ),
        DailyForecast(
          date: now.add(const Duration(days: 5)),
          minTemp: 19,
          maxTemp: 27,
          condition: WeatherCondition.partlyCloudy,
          precipitationChance: 15,
        ),
        DailyForecast(
          date: now.add(const Duration(days: 6)),
          minTemp: 14,
          maxTemp: 21,
          condition: WeatherCondition.stormy,
          precipitationChance: 85,
        ),
      ],
    );
  }

  static WeatherCondition _conditionForHour(int hour) {
    if (hour < 3) return WeatherCondition.partlyCloudy;
    if (hour < 8) return WeatherCondition.cloudy;
    if (hour < 12) return WeatherCondition.sunny;
    if (hour < 16) return WeatherCondition.partlyCloudy;
    if (hour < 20) return WeatherCondition.rainy;
    return WeatherCondition.cloudy;
  }
}

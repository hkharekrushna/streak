import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import '../widgets/animated_weather_icon.dart';
import '../widgets/weather_detail_card.dart';
import '../widgets/forecast_widgets.dart';

/// The main weather home screen with a beautiful gradient background,
/// animated weather icon, and detailed information panels.
class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen>
    with SingleTickerProviderStateMixin {
  late WeatherData _weather;
  bool _isLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _weather = WeatherData.mock();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _weather = WeatherData.mock();
      _isLoading = false;
    });
    _fadeController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDaytime =
        WeatherUtils.isDay(_weather.sunrise, _weather.sunset);
    final gradientColors =
        WeatherUtils.getGradientColors(_weather.condition, isDaytime);
    final textColor =
        WeatherUtils.getTextColor(_weather.condition, isDaytime);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            Positioned.fill(
              child: WeatherParticles(condition: _weather.condition),
            ),
            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  color: textColor,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 16),
                            _buildTopBar(textColor),
                            const SizedBox(height: 40),
                            _buildMainWeatherInfo(textColor),
                            const SizedBox(height: 40),
                            HourlyForecastList(
                              forecasts: _weather.hourlyForecast.take(12).toList(),
                              textColor: textColor,
                            ),
                            const SizedBox(height: 28),
                            WeatherDetailsGrid(
                              weather: _weather,
                              textColor: textColor,
                            ),
                            const SizedBox(height: 28),
                            DailyForecastList(
                              forecasts: _weather.dailyForecast,
                              textColor: textColor,
                            ),
                            const SizedBox(height: 28),
                            _buildSunriseSunset(textColor),
                            const SizedBox(height: 32),
                            _buildLastUpdated(textColor),
                            const SizedBox(height: 20),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Loading overlay
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Sub-builders
  // ──────────────────────────────────────────────────────────────

  Widget _buildTopBar(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: textColor, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${_weather.cityName}, ${_weather.country}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMMM d').format(DateTime.now()),
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: _refresh,
          icon: Icon(Icons.refresh_rounded, color: textColor),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildMainWeatherInfo(Color textColor) {
    return Column(
      children: [
        AnimatedWeatherIcon(
          condition: _weather.condition,
          size: 140,
        ),
        const SizedBox(height: 24),
        Text(
          '${_weather.temperature.toStringAsFixed(0)}°C',
          style: TextStyle(
            color: textColor,
            fontSize: 80,
            fontWeight: FontWeight.w200,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _weather.description,
          style: TextStyle(
            color: textColor.withOpacity(0.85),
            fontSize: 22,
            fontWeight: FontWeight.w300,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TempPill(
              label: 'H',
              value: '${_weather.maxTemp.toStringAsFixed(0)}°',
              color: textColor,
            ),
            const SizedBox(width: 16),
            _TempPill(
              label: 'L',
              value: '${_weather.minTemp.toStringAsFixed(0)}°',
              color: textColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSunriseSunset(Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SunTimeItem(
            icon: Icons.wb_twilight,
            label: 'Sunrise',
            time: DateFormat('h:mm a').format(_weather.sunrise),
            textColor: textColor,
          ),
          Container(
            width: 1,
            height: 48,
            color: Colors.white.withOpacity(0.2),
          ),
          _SunTimeItem(
            icon: Icons.nights_stay_outlined,
            label: 'Sunset',
            time: DateFormat('h:mm a').format(_weather.sunset),
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated(Color textColor) {
    return Center(
      child: Text(
        'Last updated ${DateFormat('h:mm a').format(_weather.lastUpdated)}  •  Pull to refresh',
        style: TextStyle(
          color: textColor.withOpacity(0.5),
          fontSize: 12,
        ),
      ),
    );
  }
}

/// A small pill widget showing high / low temperature.
class _TempPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TempPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.15),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays a sunrise/sunset time with icon and label.
class _SunTimeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color textColor;

  const _SunTimeItem({
    required this.icon,
    required this.label,
    required this.time,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 28),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

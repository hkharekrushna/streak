import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/weather_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const WeatherApp());
}

/// Root widget of the Weather App.
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2980B9),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF1E3A5F),
      ),
      home: const WeatherHomeScreen(),
    );
  }
}

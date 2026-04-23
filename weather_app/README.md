# Beautiful Flutter Weather App 🌤️

A stunning, animated weather app built with Flutter that showcases a beautiful,
glassmorphism-inspired UI with dynamic gradients, smooth animations, and
comprehensive weather information.

## ✨ Features

| Feature | Detail |
|---|---|
| **Dynamic Gradients** | Background color adapts to weather condition and day/night cycle |
| **Animated Weather Icon** | Floating & pulsing emoji icon with glow effect |
| **Weather Particles** | Rain drops, snowflakes, and cloud animations rendered in `CustomPainter` |
| **Current Conditions** | Temperature, feels like, high/low, humidity, wind, UV index, visibility, pressure |
| **Hourly Forecast** | Horizontally scrollable 12-hour forecast |
| **7-Day Forecast** | Daily min/max with color-coded temperature bar |
| **Sunrise / Sunset** | Visual indicator with formatted times |
| **Pull to Refresh** | Smooth refresh with loading overlay |
| **Glassmorphism Cards** | Semi-transparent frosted-glass detail cards |

## 📸 Screenshots

> Run the app and take your own screenshots – the UI adapts beautifully to both
> light and dark system themes.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0 — [Install Flutter](https://docs.flutter.dev/get-started/install)
- An Android emulator / physical device or iOS simulator / device

### Run locally

```bash
# Navigate into the project folder
cd weather_app

# Get dependencies
flutter pub get

# Run on connected device / emulator
flutter run
```

### Run tests

```bash
cd weather_app
flutter test
```

## 🔧 Project Structure

```
weather_app/
├── lib/
│   ├── main.dart                     # App entry point & MaterialApp setup
│   ├── models/
│   │   └── weather_model.dart        # WeatherData, HourlyForecast, DailyForecast
│   ├── screens/
│   │   └── weather_home_screen.dart  # Main scrollable weather screen
│   ├── utils/
│   │   └── weather_utils.dart        # Gradient, emoji, text-colour helpers
│   └── widgets/
│       ├── animated_weather_icon.dart # Floating/pulsing icon + particle canvas
│       ├── forecast_widgets.dart      # Hourly & 7-day forecast lists
│       └── weather_detail_card.dart   # Detail cards + WeatherDetailsGrid
└── test/
    └── widget_test.dart              # Unit + widget tests
```

## 🌐 Connecting to a Real API

The app ships with mock data (`WeatherData.mock()`).  To connect to a live API
(e.g. [OpenWeatherMap](https://openweathermap.org/api) or
[WeatherAPI](https://www.weatherapi.com/)):

1. Add your API key to `lib/utils/constants.dart`.
2. Create a `WeatherService` class that calls the endpoint with the `http` package
   (already listed in `pubspec.yaml`).
3. Replace the `WeatherData.mock()` call in `WeatherHomeScreen.initState` with a
   call to your service.

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `http` | HTTP client for weather API |
| `intl` | Date & time formatting |
| `google_fonts` | Beautiful typography (optional) |
| `geolocator` | Device GPS location |
| `shared_preferences` | Cache last weather data |
| `lottie` | Lottie animation support (optional upgrade) |

## 📄 License

MIT © 2024

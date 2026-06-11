# ForgeRoutine ⚒️

> *"No more hoping. Only forging."*

A discipline system & ML learning-path tracker built for CSP's 4 AM routine. Combines habit tracking, daily logging, and a structured ML curriculum into one cohesive app.

## Features

- **🌅 4 AM Routine System** — Configurable daily blocks (wake, study, workout, college, revision, sleep)
- **✅ Habit Tracking** — Boolean & duration habits with streak streaks and calendar heatmaps
- **📊 Study Logger** — Log study sessions with course/module tracking per session
- **📚 ML Curriculum** — 7 courses covering the full ML learning path:
  - Mathematics for ML
  - Practical Deep Learning (fast.ai)
  - Intro to ML (Andrew Ng)
  - Karpathy's Zero-to-Hero (Neural Nets from Scratch)
  - Transformers (Stanford CS224n)
  - Stanford CS231n (CNNs & Vision)
  - GATE DA 2027
- **📈 Progress Analytics** — Radar charts, course completion bars, study hour statistics
- **🔥 Streak Tracking** — Track consecutive days of discipline across all habits
- **🏋️ Workout Logger** — Log workout entries with exercise tracking
- **🔔 Notifications** — Configurable reminders for routine blocks & habits

## Built With

- **Flutter** — Cross-platform UI framework
- **Riverpod** — State management
- **Hive** — Local NoSQL storage
- **fl_chart** — Radar & bar charts
- **Google Fonts** — Typography

## Getting Started

```bash
git clone https://github.com/charansaiponnada/forge_routine.git
cd forge_routine
flutter pub get
flutter run
```

### Build APK

```bash
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

## App Icon

Black background with a white monogram — generated at 1024×1024 via Python/Pillow and scaled for all platforms using `flutter_launcher_icons`.

## Project Structure

```
lib/
├── core/
│   ├── constants/      # Curriculum, habits, routine, app config
│   └── theme/          # Dark neon theme
├── features/
│   ├── curriculum/     # Course browser & module tracker
│   ├── dashboard/      # Home screen
│   ├── habits/         # Habit tracking
│   ├── main_shell.dart # Navigation shell
│   ├── progress/       # Analytics & insights
│   ├── routine/        # Daily routine blocks
│   ├── settings/       # App settings
│   ├── study/          # Study session logger
│   └── workouts/       # Workout logger
├── models/             # Hive-annotated data models
├── providers/          # Riverpod state providers
└── shared/services/    # Hive, notifications, export
```

## License

MIT

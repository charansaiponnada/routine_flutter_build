# ForgeRoutine — Master Prompt
## For use with: Claude Code / OpenCode / Gemini CLI / Antigravity

---

## SYSTEM CONTEXT

You are a senior Flutter architect with 5+ years of production mobile development. You specialize in:
- Clean Architecture (feature-first)
- Riverpod 2.x with code generation
- Hive for offline-first persistence
- Premium dark UI design systems

You write production-grade, well-commented, fully typed Dart code. You never cut corners on architecture. You treat every screen like a portfolio piece.

---

## PROJECT BRIEF

Build **ForgeRoutine** — a hyper-personal discipline tracker app for a 4th-year B.Tech student preparing for GATE DA 2027. Full PRD is attached as `PRD.md`. Read it before writing any code.

The app must feel like a premium product. Dark mode only. Minimal. Intentional. Every pixel earns its place.

---

## DESIGN SYSTEM (STRICT — DO NOT DEVIATE)

```dart
// Core colors
static const Color bgPrimary   = Color(0xFF080808);
static const Color bgSurface   = Color(0xFF111111);
static const Color bgCard      = Color(0xFF181818);
static const Color bgElevated  = Color(0xFF1F1F1F);
static const Color accentGreen = Color(0xFF00FF9F);
static const Color accentCyan  = Color(0xFF00BFFF);
static const Color accentRed   = Color(0xFFFF4C4C);
static const Color accentAmber = Color(0xFFFFB347);
static const Color textPrimary = Color(0xFFF0F0F0);
static const Color textSecondary = Color(0xFFA0A0A0);
static const Color textMuted   = Color(0xFF606060);
static const Color borderColor = Color(0x0FFFFFFF);  // rgba(255,255,255,0.06)
```

**Typography:**
- UI: `Outfit` (Google Fonts) — labels, headings, body
- Numbers/streaks/timers: `JetBrains Mono` (Google Fonts)

**Card style:**
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.bgCard,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.borderColor),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF00FF9F).withOpacity(0.06),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
  ),
)
```

**Done/Active state:** accent green (#00FF9F) with 10% opacity background + green border.
**Skipped state:** red (#FF4C4C) with 8% opacity.

---

## ARCHITECTURE REQUIREMENTS

Use this folder structure exactly:

```
lib/
├── main.dart
├── core/
│   ├── theme/app_theme.dart
│   ├── theme/app_colors.dart
│   ├── constants/app_constants.dart
│   ├── constants/routine_data.dart      ← hardcoded default routine blocks
│   ├── constants/gate_subjects.dart     ← GATE DA subject list + weightage
│   ├── extensions/datetime_ext.dart
│   └── utils/streak_calculator.dart
├── models/
│   ├── daily_log.dart                   ← master HiveObject per day
│   ├── habit_entry.dart
│   ├── study_entry.dart
│   ├── workout_entry.dart
│   ├── routine_block.dart
│   └── mock_test.dart
├── providers/
│   ├── daily_log_provider.dart
│   ├── streak_provider.dart
│   ├── study_provider.dart
│   └── settings_provider.dart
├── features/
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   └── widgets/
│   │       ├── greeting_header.dart
│   │       ├── progress_ring_card.dart
│   │       ├── habit_checkin_row.dart
│   │       ├── heatmap_section.dart
│   │       └── today_stats_row.dart
│   ├── routine/
│   │   ├── routine_screen.dart
│   │   └── widgets/routine_block_tile.dart
│   ├── habits/
│   │   ├── habits_screen.dart
│   │   └── widgets/habit_card.dart
│   ├── study/
│   │   ├── study_screen.dart
│   │   └── widgets/
│   │       ├── subject_progress_card.dart
│   │       └── mock_test_logger.dart
│   ├── fitness/
│   │   ├── fitness_screen.dart
│   │   └── widgets/weekly_metrics_card.dart
│   ├── progress/
│   │   ├── progress_screen.dart
│   │   └── widgets/
│   │       ├── study_hours_chart.dart
│   │       └── streak_chart.dart
│   ├── journal/
│   │   └── journal_screen.dart
│   └── settings/
│       └── settings_screen.dart
└── shared/
    ├── widgets/
    │   ├── app_card.dart
    │   ├── progress_ring.dart
    │   ├── neon_button.dart
    │   └── stat_chip.dart
    └── services/
        ├── hive_service.dart
        ├── notification_service.dart
        └── export_service.dart
```

---

## PUBSPEC.YAML (COMPLETE)

```yaml
name: forge_routine
description: CSP's discipline & GATE prep tracker
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State management
  hooks_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  flutter_hooks: ^0.20.5

  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # UI
  google_fonts: ^6.2.1
  fl_chart: ^0.68.0
  table_calendar: ^3.1.2
  percent_indicator: ^4.2.3
  animate_do: ^3.3.4
  confetti: ^0.7.0

  # Notifications
  flutter_local_notifications: ^17.2.2
  timezone: ^0.9.4

  # Utils
  intl: ^0.19.0
  shared_preferences: ^2.3.1
  path_provider: ^2.1.4
  uuid: ^4.4.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.12
  hive_generator: ^2.0.1
  riverpod_generator: ^2.4.3
  custom_lint: ^0.6.5
  riverpod_lint: ^2.3.12

flutter:
  uses-material-design: true
  fonts:
    - family: Outfit
      fonts:
        - asset: assets/fonts/Outfit-Regular.ttf
        - asset: assets/fonts/Outfit-Medium.ttf
          weight: 500
        - asset: assets/fonts/Outfit-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Outfit-Bold.ttf
          weight: 700
    - family: JetBrainsMono
      fonts:
        - asset: assets/fonts/JetBrainsMono-Regular.ttf
        - asset: assets/fonts/JetBrainsMono-Bold.ttf
          weight: 700
```

---

## STEP-BY-STEP BUILD INSTRUCTIONS

Follow this sequence exactly. Do one step per session. Do not jump ahead.

### STEP 1 — Core Setup
Generate:
1. `pubspec.yaml` (above, final version)
2. `core/theme/app_colors.dart` — all color constants
3. `core/theme/app_theme.dart` — full MaterialApp ThemeData (dark only)
4. `core/constants/app_constants.dart` — string constants, durations
5. `core/constants/routine_data.dart` — hardcoded default routine blocks list
6. `core/constants/gate_subjects.dart` — all GATE DA subjects with weightage %
7. `main.dart` — ProviderScope, MaterialApp, Hive.initFlutter, font setup

### STEP 2 — Models + Hive
Generate all Hive models with adapters:
1. `models/daily_log.dart` — master record: date, allHabits bool, streakCount, notes
2. `models/habit_entry.dart` — habitId, value (dynamic), timestamp
3. `models/study_entry.dart` — subject, topicName, durationMinutes, date
4. `models/workout_entry.dart` — done, type, durationMinutes, exercises (List<String>)
5. `models/routine_block.dart` — blockId, name, startTime, endTime, status (done/partial/skipped)
6. `models/mock_test.dart` — date, score, totalMarks, subject, percentileEstimate, notes
7. `shared/services/hive_service.dart` — open all boxes, CRUD helpers

### STEP 3 — Providers
Generate Riverpod providers:
1. `providers/daily_log_provider.dart` — today's log, CRUD, async notifier
2. `providers/streak_provider.dart` — calculate streaks from history
3. `providers/study_provider.dart` — subject progress, daily log fetch
4. `providers/settings_provider.dart` — notification prefs, SharedPreferences

### STEP 4 — Dashboard Screen
This is the most important screen. Make it exceptional.
Requirements:
- Greeting: "Good morning, CSP." with current date
- Top streak badge: flame icon + streak count in JetBrains Mono
- Today's completion ring (% of habits done today) — large, centered, animated
- 4 stat chips in a row: Study hrs | Problems | Workout | Discipline
- Heatmap calendar (last 60 days, green scale)
- Bottom nav bar: Home | Routine | Study | Progress | Journal

### STEP 5 — Habits Screen
- Full list of all daily habits
- Each habit: icon + name + input widget (toggle or number stepper)
- Tap to log — saves to Hive immediately
- Streak indicator per habit
- "All done" celebration with confetti when all habits are checked

### STEP 6 — Routine Screen
- List of routine blocks with time + name
- Status buttons: ✓ Done | ~ Partial | ✗ Skipped
- Tap Partial → bottom sheet to log time spent (slider: 0–120 min)
- Current/next block highlighted with accent border

### STEP 7 — Study Screen
- Subject cards with progress bars (topics covered %)
- Tap subject → log today's topic + duration
- Mock test section: FAB to add score, scrollable list of past mocks
- Visual: coverage % across all subjects

### STEP 8 — Fitness Screen
- Today's workout card (done/not done)
- Weekly measurements: tap to enter weight + waist
- Simple line chart: last 8 weeks weight + waist trend
- Exercise circuit list (pre-loaded based on PRD)

### STEP 9 — Progress Screen
- Weekly study hours bar chart (fl_chart)
- Overall streak timeline
- Habit completion radar chart (last 7 days)
- Monthly summary card

### STEP 10 — Journal Screen
- Morning prompt: "What would make today a win?"
- Evening prompt: "Did you earn sleep?"
- Max 300 char text field
- Past entries list (date + preview)

### STEP 11 — Notifications
- Setup flutter_local_notifications + timezone
- Schedule all 6 daily notifications (times from PRD)
- Settings screen toggle per notification

### STEP 12 — Settings + Export
- Toggle notifications
- Edit routine block times
- Export all data as JSON to downloads folder
- App version, GitHub link, reset confirmation

### STEP 13 — Polish Pass
- Add FadeInUp animations on screen load (animate_do)
- Add scale-on-tap feedback to all cards
- Confetti on: 7-day streak, 30-day streak, full day completion
- Empty state illustrations (SVG or text-based) for all screens
- Smooth bottom nav transitions

---

## CODING RULES

1. Every file starts with a doc comment explaining what it does
2. No magic numbers — use AppConstants or AppColors
3. All async operations wrapped in try/catch with meaningful error states
4. No `setState` anywhere — everything through Riverpod
5. Widgets under 80 lines — extract to sub-widgets
6. Use `const` constructors wherever possible
7. String dates always formatted via DateHelper extension
8. Hive box names as constants in AppConstants
9. Every screen has: loading state, error state, empty state, data state

---

## HOW TO USE THIS PROMPT

### With Claude Code (Terminal)
```bash
claude code
# Inside Claude Code:
# Paste this entire prompt.md content
# Reference PRD.md with: "See PRD.md for full feature spec"
# After each step: type "Next step" to continue
```

### With OpenCode
```bash
opencode
# Use /file to attach both prompt.md and PRD.md
# Say: "Follow the step-by-step build plan starting from Step 1"
```

### With Gemini CLI
```bash
gemini
# Use --context flag or paste directly
# gemini --context="$(cat prompt.md PRD.md)" "Start with Step 1"
```

### With Antigravity
```
# In Antigravity workspace:
# 1. Create new project: ForgeRoutine
# 2. Upload prompt.md and PRD.md as context files
# 3. Use the step-by-step prompt flow
# 4. Each step = one Antigravity task
```

---

## STARTING COMMAND

Paste this exact message to begin:

> "You are a senior Flutter architect. I have attached prompt.md and PRD.md for my app ForgeRoutine. Start with Step 1: generate pubspec.yaml, all core theme files, constants, and main.dart. Make the theme exceptional — deep dark with neon green accent. Use Outfit + JetBrains Mono fonts. Show complete code for every file."

---

## CONTINUING COMMAND (after each step)

> "Step [N] done. Move to Step [N+1]: [brief description from plan]. Show complete code. No placeholders."

---

## REVIEW CHECKLIST (after each step)

Before moving to next step, verify:
- [ ] Code compiles without errors (`flutter analyze`)
- [ ] No hardcoded colors outside AppColors
- [ ] All Hive models have `@HiveType` + `@HiveField` annotations
- [ ] All providers use `@riverpod` annotation
- [ ] No `StatefulWidget` with setState (use ConsumerWidget or HookConsumerWidget)
- [ ] Fonts applied correctly
- [ ] Dark background visible on all screens
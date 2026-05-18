# Product Requirements Document
## ForgeRoutine — CSP Ignite

**Tagline:** No more hoping. Only forging.
**Version:** 1.0.0
**Platform:** Flutter (Android + iOS)
**Owner:** Charan Sai Ponnada (@charansaiponnada)

---

## 1. Vision

A hyper-personal, minimal dark-mode mobile app that makes CSP's 4 AM discipline system impossible to skip. It tracks GATE DA 2027 prep, fitness, coding streaks, and discipline habits with zero friction. Built in Flutter — this is also a strong portfolio project.

---

## 2. Goals

- Replace the "scroll and hope" morning with a structured system
- Build and maintain unbreakable streaks across study, fitness, coding, and discipline
- Track GATE DA 2027 coverage and mock scores (target: >80 percentile)
- Serve as a showcase Flutter project on GitHub / LinkedIn

---

## 3. Non-Functional Requirements

| Property | Spec |
|---|---|
| Theme | Pure dark mode only. No toggle. |
| UI Style | Minimal neumorphic-dark: deep blacks, subtle elevation, one neon accent |
| Primary BG | `#080808` |
| Surface / Card | `#111111` to `#1A1A1A` |
| Accent | `#00FF9F` (neon green) |
| Secondary Accent | `#00BFFF` (electric cyan) for secondary elements |
| Error | `#FF4C4C` |
| Typography | `JetBrains Mono` for numbers/code, `Outfit` for UI labels |
| Performance | Offline-first. Hive for local persistence. Sub-100ms interactions. |
| Architecture | Feature-first Clean Architecture + Riverpod 2.x + Flutter Hooks |

---

## 4. Core Features

### 4.1 Dashboard (Home Screen)
- Greeting with current overall streak
- Motivational quote (rotating, hardcoded 15–20 lines)
- Progress ring: today's routine completion percentage
- Quick habit check-in cards (tap to log)
- Heatmap calendar: last 60 days (green cells for complete days) eg. github streaks kind off
- Today's summary stat row: Study hrs | Problems | Workout | Discipline

### 4.2 Routine Scheduler
Pre-loaded time blocks (user can edit name/time, cannot delete core blocks):

| Time | Block |
|---|---|
| 04:00 | Wake + Walk / Meditation |
| 04:30–06:30 | Deep Study Block 1 (GATE) |
| 06:30–07:30 | Home Workout |
| 08:00–17:30 | College / Internship |
| 17:30–19:30 | Study Block 2 + Coding |
| 19:30–20:00 | Dinner + Walk |
| 20:00–21:00 | Revision + Journal |
| 21:30 | Sleep target |

Each block: mark Done / Partial / Skipped + optional time-spent log.

### 4.3 Habit Tracker
Daily boolean + quantifiable habits:

| Habit | Type |
|---|---|
| Woke by 4:00 AM | Boolean |
| Meditation done | Boolean |
| Workout completed | Boolean + duration (min) |
| LeetCode problems | Counter |
| GATE study hours | Float (0.5 hr steps) |
| Water intake | Counter (glasses) |
| No social scroll before 8 AM | Boolean |
| Discipline (NoFap) streak | Auto-calculated |

### 4.4 Study & GATE Tracker
**Subjects with weightage (GATE DA):**
- Probability & Statistics (high)
- Linear Algebra (high)
- Calculus (medium)
- ML & AI (high)
- Programming / DSA / Python (medium)
- Databases (medium)
- Aptitude (medium)

Per-subject: daily topic log, time spent, resources used.
Mock test logger: date, score, percentile estimate, notes.
Overall coverage progress bar per subject.

### 4.5 Fitness Log
- Daily workout: type (circuit/walk/run), duration, exercises completed
- Weekly weigh-in: weight (kg) + waist (cm)
- Posture check reminder (every 2 hours during study blocks)
- Simple progress chart: weight/waist trend over 12 weeks

### 4.6 Coding Progress
- LeetCode problems: count per day, difficulty tag (Easy/Med/Hard)
- GitHub push log: yes/no per day
- Language: Python (primary for GATE DA + placements)
- Current project log: ForgeRoutine, EEG, VIVIRITY

### 4.7 Progress & Insights
- Weekly study hours bar chart (fl_chart)
- Streak history line chart
- Habit completion % radar chart
- GATE mock score trend
- Monthly overview card

### 4.8 Journal
- Daily note: wins, what went wrong, tomorrow's single focus
- Prompt: "What would make today a win?" (morning) / "Did you earn sleep?" (night)
- Max 300 characters per entry to keep it fast

### 4.9 Notifications & Reminders
| Time | Notification |
|---|---|
| 03:50 AM | "4 AM. Your future self is already awake." |
| 04:25 AM | "Study Block 1 starts. No phone." |
| 06:25 AM | "Workout time. No excuses." |
| 17:25 PM | "Evening study block. Show up." |
| 20:50 PM | "Wind down. Journal. Sleep wins." |
| 21:25 PM | "Lights out. Tomorrow starts now." |

### 4.10 Settings
- Edit routine blocks (name, time)
- Toggle individual notifications
- Export data as JSON
- Reset a habit streak (requires 3-tap confirmation)
- App version + GitHub link

---

## 5. Design System

### Color Tokens
```
--bg-primary:    #080808
--bg-surface:    #111111
--bg-card:       #181818
--bg-elevated:   #1F1F1F

--accent-green:  #00FF9F
--accent-cyan:   #00BFFF
--accent-red:    #FF4C4C
--accent-amber:  #FFB347

--text-primary:  #F0F0F0
--text-secondary:#A0A0A0
--text-muted:    #606060

--border:        rgba(255,255,255,0.06)
--shadow:        rgba(0,255,159,0.08)  (subtle green glow on cards)
```

### Typography
- `Outfit` — UI labels, headings, body
- `JetBrains Mono` — numbers, streaks, timers, code

### Spacing
- Base unit: 8px
- Cards: 16px padding
- Sections: 24px gap
- Screen: 20px horizontal padding

### Component Patterns
- Cards: bg-card, 12px radius, 1px border (--border), subtle bottom shadow
- Accent elements: neon green (#00FF9F) for active/done states
- Progress rings: 4px stroke, green fill, surface stroke
- Heatmap cells: 10×10px, 4px radius, green scale (4 levels)
- Habit cards: large touch target (min 56px), icon + label + value

---

## 6. Architecture

```
lib/
├── main.dart
├── core/
│   ├── theme/          # AppTheme, ColorTokens, TextTheme
│   ├── constants/      # AppConstants, RoutineBlocks, GateSubjects
│   ├── extensions/     # DateTime, String, BuildContext extensions
│   └── utils/          # DateHelper, StreakCalculator
├── models/
│   ├── daily_log.dart  # HiveObject — master daily record
│   ├── habit_entry.dart
│   ├── study_entry.dart
│   ├── workout_entry.dart
│   ├── routine_block.dart
│   └── mock_test.dart
├── providers/          # Riverpod providers (codegen)
│   ├── daily_log_provider.dart
│   ├── streak_provider.dart
│   ├── study_provider.dart
│   └── settings_provider.dart
├── features/
│   ├── dashboard/      # Home screen
│   ├── routine/        # Scheduler
│   ├── habits/         # Habit tracker
│   ├── study/          # GATE tracker
│   ├── fitness/        # Workout log
│   ├── progress/       # Charts + insights
│   ├── journal/        # Daily journal
│   └── settings/       # Config + export
└── shared/
    ├── widgets/         # AppCard, ProgressRing, HeatmapCell, StatRow
    └── services/        # HiveService, NotificationService, ExportService
```

---

## 7. Tech Stack

| Layer | Package |
|---|---|
| State | hooks_riverpod + riverpod_annotation + flutter_hooks |
| Storage | hive + hive_flutter + hive_generator |
| Charts | fl_chart |
| Calendar | table_calendar |
| Notifications | flutter_local_notifications |
| Animations | animate_do |
| Confetti | confetti |
| Progress | percent_indicator |
| Utils | intl + shared_preferences + path_provider |
| Fonts | Google Fonts (Outfit + JetBrains Mono) |

---

## 8. Milestones

| Phase | Timeline | Deliverable |
|---|---|---|
| MVP | Week 1–2 | Dashboard + Habit check-in + Hive setup |
| Core | Week 3–4 | Study tracker + Routine scheduler + Notifications |
| Insights | Week 5–6 | Charts + Heatmap + Streak logic |
| Polish | Week 7–8 | Animations + Journal + Fitness log + Settings |
| Portfolio | Week 9 | README + Screenshots + GitHub push + LinkedIn post |

---

## 9. Success Metrics

- CSP uses the app for 60+ consecutive days
- GATE study coverage reaches 100% by Dec 2026
- LeetCode streak: 90+ days unbroken
- Body: measurable waist reduction logged weekly
- App live on GitHub with 50+ commits

---

## 10. Out of Scope (v1.0)

- Backend / sync (offline only)
- Social features
- AI-generated study plans (may add in v2)
- Light mode
# ForgeRoutine TODO List

## 1. Integration & Navigation
- [ ] Add `HabitsScreen` to `MainShell` navigation.
- [ ] Add `SettingsScreen` to `MainShell` navigation (or as a sub-route).
- [ ] Connect Dashboard "Quick habit check-in cards" to Riverpod state.

## 2. Data Wiring (Replace Mock Data)
- [ ] Connect `StudyHoursChart` to real study session data.
- [ ] Connect `StreakChart` to real history data from `StreakProvider`.
- [ ] Connect `HabitRadarChart` to last 7 days of habit completion data.
- [ ] Connect `FitnessScreen` weight chart to real workout entries.
- [ ] Implement actual journal history fetching in `JournalScreen`.

## 3. Core Feature Logic
- [ ] Implement dynamic GATE subject coverage calculation in `StudyNotifier`.
- [ ] Implement routine block customization (editing name/time) in `SettingsScreen`.
- [ ] Implement notification scheduling logic in `NotificationService` based on routine times.
- [ ] Implement 2-hour posture check reminders during study blocks.
- [ ] Add `Notes` field to `MockTest` logger and UI.
- [ ] Add `Resources Used` field to study session logging.

## 4. Polish & UX
- [ ] Implement haptic feedback for all logging actions.
- [ ] Add `FadeInUp` animations to all screens (using `animate_do`).
- [ ] Add scale-on-tap feedback to all cards.
- [ ] Add confetti for 7-day/30-day streaks.
- [ ] Ensure all screens have proper Loading/Error/Empty states.

## 5. Verification & DevOps
- [ ] Verify `ExportService` packages all Hive data correctly.
- [ ] Run `flutter analyze` and fix all warnings.
- [ ] Final git commit and wrap-up.

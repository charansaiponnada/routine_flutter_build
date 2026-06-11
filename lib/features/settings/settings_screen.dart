import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../models/routine_block.dart';
import '../../shared/services/export_service.dart';
import '../../shared/services/hive_service.dart';
import '../../shared/widgets/app_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.verticalPadding,
        ),
        children: [
          FadeInDown(
            duration: AppConstants.fastAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'PREFERENCES'),
                const SizedBox(height: 12),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildToggleTile(
                        context,
                        title: 'Notifications',
                        subtitle: 'Daily discipline reminders',
                        value: settings['notificationsEnabled'] ?? true,
                        onChanged: (val) => notifier.updateSetting('notificationsEnabled', val),
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      _buildToggleTile(
                        context,
                        title: 'Vibration',
                        subtitle: 'Haptic feedback on logs',
                        value: settings['vibrationEnabled'] ?? true,
                        onChanged: (val) => notifier.updateSetting('vibrationEnabled', val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: AppConstants.mediumAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'ROUTINE CUSTOMIZATION'),
                const SizedBox(height: 12),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ...(settings['routineBlocks'] as List<RoutineBlock>).map((block) {
                        return Column(
                          children: [
                            _buildActionTile(
                              context,
                              title: block.name,
                              subtitle: '${block.startTime} - ${block.endTime}',
                              icon: Icons.access_time_rounded,
                              onTap: () => _showEditBlockDialog(context, block, notifier),
                            ),
                            if (block != settings['routineBlocks'].last)
                              const Divider(indent: 16, endIndent: 16),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: AppConstants.mediumAnim,
            delay: const Duration(milliseconds: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'DATA MANAGEMENT'),
                const SizedBox(height: 12),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildActionTile(
                        context,
                        title: 'Export Data',
                        subtitle: 'Save as JSON backup',
                        icon: Icons.download_rounded,
                        onTap: () => _handleExport(context),
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      _buildActionTile(
                        context,
                        title: 'Reset All Data',
                        subtitle: 'Permanent deletion',
                        icon: Icons.delete_forever_rounded,
                        color: AppColors.accentRed,
                        onTap: () => _showResetConfirmation(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: AppConstants.mediumAnim,
            delay: const Duration(milliseconds: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'ABOUT'),
                const SizedBox(height: 12),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildActionTile(
                        context,
                        title: 'App Version',
                        subtitle: AppConstants.appVersion,
                        icon: Icons.info_outline_rounded,
                        onTap: null,
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      _buildActionTile(
                        context,
                        title: 'GitHub Repository',
                        subtitle: 'charansaiponnada/forge_routine',
                        icon: Icons.code_rounded,
                        onTap: () => _launchUrl(AppConstants.githubRepoUrl),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          FadeIn(
            duration: AppConstants.slowAnim,
            child: Center(
              child: Text(
                'MADE FOR THE 4 AM DISCIPLINE',
                style: AppTheme.jetBrainsMono(
                  fontSize: 10,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelLarge),
      trailing: Switch.adaptive(
        value: value,
        activeColor: AppColors.accentGreen,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Color? color,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? AppColors.textPrimary, size: 22),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelLarge),
      trailing: onTap != null ? const Icon(Icons.chevron_right_rounded, size: 20) : null,
    );
  }

  void _handleExport(BuildContext context) async {
    final path = await ExportService.exportAsJson();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.bgElevated,
          content: Text(
            path != null ? 'Data exported to: $path' : 'Export failed',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }
  }

  void _showResetConfirmation(BuildContext context) {
    int taps = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.bgSurface,
          title: const Text('Confirm Reset'),
          content: Text(
            'This will erase ALL logs and history. Tap the button 3 times to confirm.\n\nTaps: $taps / 3',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
              onPressed: () {
                setState(() => taps++);
                if (taps >= 3) {
                  HiveService.dailyLogBox.clear();
                  Navigator.pop(context);
                }
              },
              child: Text(taps >= 3 ? 'ERASE EVERYTHING' : 'TAP TO CONFIRM'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showEditBlockDialog(BuildContext context, RoutineBlock block, SettingsNotifier notifier) {
    final nameController = TextEditingController(text: block.name);
    final startController = TextEditingController(text: block.startTime);
    final endController = TextEditingController(text: block.endTime);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: Text('Edit ${block.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Block Name'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startController,
                    decoration: const InputDecoration(labelText: 'Start (HH:mm)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: endController,
                    decoration: const InputDecoration(labelText: 'End (HH:mm)'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
            onPressed: () {
              notifier.updateRoutineBlock(block.copyWith(
                name: nameController.text,
                startTime: startController.text,
                endTime: endController.text,
              ));
              Navigator.pop(context);
            },
            child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

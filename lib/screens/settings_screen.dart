import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Profile",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: LightColors.primaryText,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  _buildNavButton(Icons.edit_rounded, () {}, const Color(0xFFE0E0E0)),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: LightColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: LightColors.divider, width: 3),
                  boxShadow: const [AppShadows.sm],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: LightColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 3),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "MJ",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: LightColors.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kim Min-jun",
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: LightColors.primaryText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Level 12 Word Master",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: LightColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: LightColors.background,
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                  border: Border.all(color: LightColors.divider, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.local_fire_department_rounded, color: LightColors.primary, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      "7 Day Streak",
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: LightColors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: LightColors.divider, thickness: 1),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProfileStat(context, "1,240", "Words"),
                        _buildProfileStat(context, "48", "Quizzes"),
                        _buildProfileStat(context, "92%", "Accuracy"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(context, "Learning"),
              _buildSettingsTile(
                context,
                Icons.volume_up_rounded,
                const Color(0xFFE3F2FD),
                LightColors.accent,
                "Pronunciation",
                "Auto-play TTS after flip",
              ),
              _buildSettingsTile(
                context,
                Icons.psychology_rounded,
                const Color(0xFFF3E5F5),
                const Color(0xFF9C27B0),
                "Quiz Difficulty",
                "Current: Intermediate",
              ),
              _buildSettingsTile(
                context,
                Icons.notifications_active_rounded,
                const Color(0xFFFFF3E0),
                const Color(0xFFF57C00),
                "Study Reminders",
                "Daily at 7:00 PM",
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(context, "Account & App"),
              _buildSettingsTile(
                context,
                Icons.face_rounded,
                const Color(0xFFE8F5E9),
                LightColors.success,
                "Parental Control",
                "Manage study goals and limits",
              ),
              _buildSettingsTile(
                context,
                Icons.dark_mode_rounded,
                const Color(0xFFECEFF1),
                LightColors.secondaryText,
                "Appearance",
                "System default theme",
              ),
              _buildSettingsTile(
                context,
                Icons.cloud_upload_rounded,
                const Color(0xFFE0F2F1),
                const Color(0xFF00897B),
                "Data Backup",
                "Last synced: 2 hours ago",
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text("Sign Out"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: LightColors.error,
                    side: const BorderSide(color: LightColors.error, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      "ClickWord v1.0.4",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: LightColors.hint),
                    ),
                    Text(
                      "Made with ❤️ for young learners",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: LightColors.hint),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap, Color bg) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }

  Widget _buildProfileStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: LightColors.primaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: LightColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: LightColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context,
      IconData icon,
      Color iconBg,
      Color iconColor,
      String title,
      String subtitle,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LightColors.divider, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: LightColors.primaryText,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: LightColors.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: LightColors.hint, size: 20),
        ],
      ),
    );
  }
}

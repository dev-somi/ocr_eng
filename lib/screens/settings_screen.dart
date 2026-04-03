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
                    "내 프로필",
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
                                "레벨 12 단어 마스터",
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
                                      "7일 연속",
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
                        _buildProfileStat(context, "1,240", "단어"),
                        _buildProfileStat(context, "48", "퀴즈"),
                        _buildProfileStat(context, "92%", "정확도"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(context, "학습"),
              _buildSettingsTile(
                context,
                Icons.volume_up_rounded,
                const Color(0xFFE3F2FD),
                LightColors.accent,
                "발음",
                "카드 뒤집기 후 자동 발음",
              ),
              _buildSettingsTile(
                context,
                Icons.psychology_rounded,
                const Color(0xFFF3E5F5),
                const Color(0xFF9C27B0),
                "퀴즈 난이도",
                "현재: 중급",
              ),
              _buildSettingsTile(
                context,
                Icons.notifications_active_rounded,
                const Color(0xFFFFF3E0),
                const Color(0xFFF57C00),
                "학습 알림",
                "매일 오후 7:00",
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(context, "계정 및 앱"),
              _buildSettingsTile(
                context,
                Icons.face_rounded,
                const Color(0xFFE8F5E9),
                LightColors.success,
                "자녀 보호",
                "학습 목표 및 제한 관리",
              ),
              _buildSettingsTile(
                context,
                Icons.dark_mode_rounded,
                const Color(0xFFECEFF1),
                LightColors.secondaryText,
                "화면 설정",
                "시스템 기본 테마",
              ),
              _buildSettingsTile(
                context,
                Icons.cloud_upload_rounded,
                const Color(0xFFE0F2F1),
                const Color(0xFF00897B),
                "데이터 백업",
                "마지막 동기화: 2시간 전",
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text("로그아웃"),
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
                      "어린 학습자들을 위해 ❤️로 만들었어요",
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

import 'package:clickword/theme.dart';
import 'package:clickword/nav.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
                  _buildNavButton(Icons.arrow_back_rounded, () => context.pop(), const Color(0xFFFFD60A)),
                  Text(
                    "My Progress",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: LightColors.primaryText,
                    ),
                  ),
                  _buildNavButton(Icons.settings_rounded, () => context.push(AppRoutes.settings), const Color(0xFF4CC9F0)),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD60A),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      offset: Offset(0, 8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "7 DAY STREAK!",
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: LightColors.primaryText,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "You're a word wizard! Keep going to unlock the Golden Owl.",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: LightColors.primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: LightColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFE63946), size: 48),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Icons.edit_rounded,
                      const Color(0xFF4CC9F0),
                      "WORDS",
                      "128",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Icons.star_rounded,
                      const Color(0xFFFFD60A),
                      "ACCURACY",
                      "92%",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: LightColors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: LightColors.divider, width: 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly Activity",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: LightColors.primaryText,
                          ),
                        ),
                        Text(
                          "Last 7 Days",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: LightColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 60,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const titles = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  if (value.toInt() < 0 || value.toInt() >= titles.length) return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      titles[value.toInt()],
                                      style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            _makeBarGroup(0, 12, const Color(0xFF52B788)),
                            _makeBarGroup(1, 45, const Color(0xFF52B788)),
                            _makeBarGroup(2, 28, const Color(0xFF52B788)),
                            _makeBarGroup(3, 60, const Color(0xFF52B788)),
                            _makeBarGroup(4, 35, const Color(0xFF52B788)),
                            _makeBarGroup(5, 50, const Color(0xFF52B788)),
                            _makeBarGroup(6, 42, const Color(0xFF52B788)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Daily Goal",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: LightColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: LightColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: LightColors.divider, width: 3),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDayBubble(context, "Mon", true),
                        _buildDayBubble(context, "Tue", true),
                        _buildDayBubble(context, "Wed", true),
                        _buildDayBubble(context, "Thu", true),
                        _buildDayBubble(context, "Fri", false),
                        _buildDayBubble(context, "Sat", false),
                        _buildDayBubble(context, "Sun", false),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Target: 15/20 words",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: LightColors.primaryText,
                              ),
                            ),
                            Text(
                              "75%",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: LightColors.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: LightColors.background,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(color: LightColors.divider, width: 2),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.75,
                            child: Container(color: LightColors.success),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 60,
            color: const Color(0xFFF1F5F9),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap, Color bg) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, Color color, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LightColors.divider, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: LightColors.secondaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: LightColors.primaryText,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBubble(BuildContext context, String day, bool active) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: active ? LightColors.success : LightColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
                color: active ? LightColors.success : LightColors.divider,
                width: 3
            ),
          ),
          child: active
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: active ? LightColors.primaryText : LightColors.hint,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

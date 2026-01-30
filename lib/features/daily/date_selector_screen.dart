import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../core/models/models.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/theme/colors.dart';
import 'daily_provider.dart';

/// Écran de sélection d'une date pour créer un journal
class DateSelectorScreen extends ConsumerStatefulWidget {
  const DateSelectorScreen({super.key});

  @override
  ConsumerState<DateSelectorScreen> createState() => _DateSelectorScreenState();
}

class _DateSelectorScreenState extends ConsumerState<DateSelectorScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  Map<DateTime, DailyReport> _reportsMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialiser focusedDay à une date valide (30 jours en arrière)
    _focusedDay = DateTime.now().subtract(const Duration(days: 30));
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    
    // Charger tous les rapports des 365 derniers jours
    final reports = await ref.read(allReportsForCalendarProvider.future);
    
    // Créer une map pour un accès rapide
    final map = <DateTime, DailyReport>{};
    for (final report in reports) {
      final normalizedDate = DailyReport.normalizeDate(report.date);
      map[normalizedDate] = report;
    }
    
    setState(() {
      _reportsMap = map;
      _isLoading = false;
    });
  }

  bool _hasReport(DateTime day) {
    final normalized = DailyReport.normalizeDate(day);
    return _reportsMap.containsKey(normalized);
  }

  bool _isDaySelectable(DateTime day) {
    // Le jour doit être aujourd'hui ou dans le passé, et sans journal
    final today = DailyReport.normalizeDate(DateTime.now());
    final normalized = DailyReport.normalizeDate(day);
    return !normalized.isAfter(today) && !_hasReport(day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner un jour passé'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // Instructions
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: WakyCard(
                      backgroundColor: WakyColors.info.withValues(alpha: 0.1),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: WakyColors.info,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sélectionnez une date sans journal (aujourd\'hui ou un jour passé)',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WakyColors.info,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Calendrier
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: WakyCard(
                          child: TableCalendar(
                            firstDay: DateTime.now().subtract(const Duration(days: 365)),
                            lastDay: DateTime.now(),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            locale: 'fr_FR',
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            selectedDayPredicate: (day) {
                              return _selectedDay != null && 
                                     isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              if (_isDaySelectable(selectedDay)) {
                                HapticService.selection();
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              } else if (_hasReport(selectedDay)) {
                                HapticService.error();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ce jour a déjà un journal'),
                                    backgroundColor: WakyColors.warning,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                HapticService.error();
                              }
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            calendarStyle: CalendarStyle(
                              // Jours avec journal (non sélectionnables)
                              defaultDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              // Jours sans journal (sélectionnables)
                              todayDecoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: const BoxDecoration(
                                color: WakyColors.primary,
                                shape: BoxShape.circle,
                              ),
                              // Styles de texte
                              weekendTextStyle: TextStyle(color: Colors.grey.shade600),
                              outsideTextStyle: TextStyle(color: Colors.grey.shade400),
                              disabledTextStyle: TextStyle(color: Colors.grey.shade300),
                            ),
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, day, focusedDay) {
                                if (_hasReport(day)) {
                                  // Jour avec journal - marqueur vert
                                  return Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: WakyColors.success.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                color: Colors.grey.shade400,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (_isDaySelectable(day)) {
                                  // Jour sélectionnable
                                  return Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: WakyColors.primary.withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: const TextStyle(
                                            color: WakyColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                            enabledDayPredicate: (day) {
                              // Désactiver uniquement les jours futurs
                              final today = DailyReport.normalizeDate(DateTime.now());
                              final normalized = DailyReport.normalizeDate(day);
                              return !normalized.isAfter(today);
                            },
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: true,
                              titleCentered: true,
                              formatButtonShowsNext: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Légende
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LegendItem(
                              color: WakyColors.primary.withValues(alpha: 0.3),
                              label: 'Sans journal',
                              border: true,
                            ),
                            const SizedBox(width: 16),
                            _LegendItem(
                              color: WakyColors.success.withValues(alpha: 0.2),
                              label: 'Avec journal',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Bouton de validation
                        WakyGradientButton(
                          label: _selectedDay == null 
                              ? 'Sélectionner un jour'
                              : 'Créer le journal du ${DateFormat('d MMMM', 'fr_FR').format(_selectedDay!)}',
                          icon: Icons.add,
                          onPressed: _selectedDay == null 
                              ? null 
                              : () {
                                  HapticService.medium();
                                  Navigator.of(context).pop(_selectedDay);
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool border;

  const _LegendItem({
    required this.color,
    required this.label,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: border ? Border.all(color: color, width: 1) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

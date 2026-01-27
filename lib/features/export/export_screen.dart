import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../core/services/providers.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/theme/colors.dart';
import 'pdf_export_service.dart';

/// Écran d'export PDF
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isGenerating = false;
  String? _patientName;

  @override
  void initState() {
    super.initState();
    // Par défaut: dernière semaine
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export PDF'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            WakyCard(
              backgroundColor: WakyColors.info.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: WakyColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Générez un rapport PDF lisible pour votre gastro-entérologue. '
                      'Le document inclut une synthèse de vos repas, douleurs et observations.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Nom du patient (optionnel)
            Text(
              'Nom du patient (optionnel)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Prénom Nom',
                prefixIcon: Icon(Icons.person_outline),
              ),
              onChanged: (value) {
                _patientName = value.isEmpty ? null : value;
              },
            ),

            const SizedBox(height: 24),

            // Période
            Text(
              'Période du rapport',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _DateSelector(
                    label: 'Du',
                    date: _startDate,
                    onTap: () => _selectDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateSelector(
                    label: 'Au',
                    date: _endDate,
                    onTap: () => _selectDate(isStart: false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Raccourcis de période
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PeriodChip(
                  label: '7 jours',
                  onTap: () => _setPeriod(7),
                ),
                _PeriodChip(
                  label: '14 jours',
                  onTap: () => _setPeriod(14),
                ),
                _PeriodChip(
                  label: '30 jours',
                  onTap: () => _setPeriod(30),
                ),
                _PeriodChip(
                  label: '3 mois',
                  onTap: () => _setPeriod(90),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Bouton de génération
            WakyGradientButton(
              label: 'Générer le PDF',
              icon: Icons.picture_as_pdf,
              isLoading: _isGenerating,
              onPressed: _generatePdf,
            ),

            const SizedBox(height: 24),

            // Aperçu
            if (!_isGenerating)
              Center(
                child: TextButton.icon(
                  onPressed: _previewPdf,
                  icon: const Icon(Icons.visibility),
                  label: const Text('Aperçu'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isStart}) async {
    final initialDate = isStart ? _startDate : _endDate;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = date;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
      HapticService.selection();
    }
  }

  void _setPeriod(int days) {
    setState(() {
      _endDate = DateTime.now();
      _startDate = _endDate.subtract(Duration(days: days));
    });
    HapticService.selection();
  }

  Future<void> _generatePdf() async {
    setState(() => _isGenerating = true);

    try {
      final pdfBytes = await _buildPdf();
      
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'wakygut_rapport_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf',
      );

      if (mounted) {
        HapticService.success();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF généré avec succès'),
            backgroundColor: WakyColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        HapticService.error();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: WakyColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  Future<void> _previewPdf() async {
    setState(() => _isGenerating = true);

    try {
      final pdfBytes = await _buildPdf();
      
      if (mounted) {
        await Printing.layoutPdf(
          onLayout: (_) async => pdfBytes,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  Future<Uint8List> _buildPdf() async {
    // Récupère les données
    final mealRepo = ref.read(mealRepositoryProvider);
    final painRepo = ref.read(painEventRepositoryProvider);
    final dailyRepo = ref.read(dailyReportRepositoryProvider);
    final foodRepo = ref.read(foodItemRepositoryProvider);

    final meals = await mealRepo.getByDateRange(_startDate, _endDate);
    final painEvents = await painRepo.getByDateRange(_startDate, _endDate);
    final dailyReports = await dailyRepo.getByDateRange(_startDate, _endDate);
    final problematicFoods = await foodRepo.getRiskyFoods();

    // Génère le PDF
    final exportService = PdfExportService();
    final pdfBytes = await exportService.generateMedicalReport(
      startDate: _startDate,
      endDate: _endDate,
      meals: meals,
      painEvents: painEvents,
      dailyReports: dailyReports,
      problematicFoods: problematicFoods,
      patientName: _patientName,
    );
    return Uint8List.fromList(pdfBytes);
  }
}

class _DateSelector extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateSelector({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}

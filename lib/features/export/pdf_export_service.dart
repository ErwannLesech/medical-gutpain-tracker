import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../../core/models/models.dart';

/// Classe pour représenter un événement chronologique (repas ou douleur)
class _ChronologicalEvent {
  final DateTime dateTime;
  final String type; // 'meal', 'pain', 'report'
  final dynamic data;
  final PdfColor? highlightColor;

  _ChronologicalEvent({
    required this.dateTime,
    required this.type,
    required this.data,
    this.highlightColor,
  });
}

/// Service de génération de PDF pour l'export médical
class PdfExportService {
  /// Génère un rapport PDF complet
  Future<Uint8List> generateMedicalReport({
    required DateTime startDate,
    required DateTime endDate,
    required List<Meal> meals,
    required List<PainEvent> painEvents,
    required List<DailyReport> dailyReports,
    required List<FoodItem> problematicFoods,
    String? patientName,
  }) async {
    final pdf = pw.Document();

    // Style général
    final titleStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.purple800,
    );
    final headerStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.grey800,
    );
    final bodyStyle = const pw.TextStyle(fontSize: 10);
    final smallStyle = pw.TextStyle(fontSize: 8, color: PdfColors.grey600);

    // Filtrer les repas consommés
    final consumedMeals = meals.where((m) => m.isConsumed).toList();

    // ========== PAGE 1: Tableau des douleurs déclarées ==========
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          'Douleurs déclarées',
          startDate,
          endDate,
          patientName,
          context.pageNumber,
        ),
        build: (context) {
          return [
            pw.Text(
              'TABLEAU DES DOULEURS DÉCLARÉES',
              style: headerStyle,
            ),
            pw.SizedBox(height: 12),
            if (painEvents.isEmpty)
              pw.Text('Aucune douleur déclarée sur cette période', style: bodyStyle)
            else
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.2),
                  1: const pw.FlexColumnWidth(0.7),
                  2: const pw.FlexColumnWidth(0.8),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(1.5),
                  5: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _tableCell('Date/Heure', isHeader: true),
                      _tableCell('Intensité', isHeader: true),
                      _tableCell('État', isHeader: true),
                      _tableCell('Localisation', isHeader: true),
                      _tableCell('Lien repas', isHeader: true),
                      _tableCell('Symptômes', isHeader: true),
                    ],
                  ),
                  ...painEvents.map((event) {
                    return pw.TableRow(
                      children: [
                        _tableCell(
                          DateFormat('dd/MM/yy HH:mm').format(event.dateTime),
                        ),
                        _tableCell(
                          '${event.intensity}/5',
                          color: _getIntensityColor(event.intensity),
                        ),
                        _tableCell(event.isUsual ? 'Habituelle' : 'Nouvelle'),
                        _tableCell(event.locationName),
                        _tableCell(event.delayFromMealFormatted),
                        _tableCell(
                          event.symptoms.isNotEmpty
                              ? event.symptoms.map((s) => s.name).join(', ')
                              : '-',
                        ),
                      ],
                    );
                  }),
                ],
              ),
          ];
        },
      ),
    );

    // ========== PAGE 2: Tableau des rapports journaliers ==========
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          'Rapports journaliers',
          startDate,
          endDate,
          patientName,
          context.pageNumber,
        ),
        build: (context) {
          return [
            pw.Text(
              'TABLEAU DES RAPPORTS JOURNALIERS',
              style: headerStyle,
            ),
            pw.SizedBox(height: 12),
            if (dailyReports.isEmpty)
              pw.Text('Aucun rapport journalier sur cette période', style: bodyStyle)
            else
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(0.8),
                  3: const pw.FlexColumnWidth(0.8),
                  4: const pw.FlexColumnWidth(0.8),
                  5: const pw.FlexColumnWidth(1),
                  6: const pw.FlexColumnWidth(0.8),
                  7: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _tableCell('Date', isHeader: true),
                      _tableCell('État', isHeader: true),
                      _tableCell('Stress', isHeader: true),
                      _tableCell('Fatigue', isHeader: true),
                      _tableCell('Sommeil', isHeader: true),
                      _tableCell('Transit', isHeader: true),
                      _tableCell('Selles', isHeader: true),
                      _tableCell('Notes', isHeader: true),
                    ],
                  ),
                  ...dailyReports.map((report) {
                    return pw.TableRow(
                      children: [
                        _tableCell(
                          DateFormat('dd/MM/yyyy').format(report.date),
                        ),
                        _tableCell('${report.statusName}'),
                        _tableCell('${report.stressLevel}/5'),
                        _tableCell('${report.fatigueLevel}/5'),
                        _tableCell('${report.hoursSlept.toStringAsFixed(1)}h'),
                        _tableCell(report.transitQualityName),
                        _tableCell('${report.bowelMovements}'),
                        _tableCell(report.notes ?? '-'),
                      ],
                    );
                  }),
                ],
              ),
          ];
        },
      ),
    );

    // ========== PAGE 3: Tableau des repas planifiés ==========
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          'Repas planifiés',
          startDate,
          endDate,
          patientName,
          context.pageNumber,
        ),
        build: (context) {
          return [
            pw.Text(
              'TABLEAU DES REPAS PLANIFIÉS',
              style: headerStyle,
            ),
            pw.SizedBox(height: 12),
            if (consumedMeals.isEmpty)
              pw.Text('Aucun repas consommé sur cette période', style: bodyStyle)
            else
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.2),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(0.8),
                  3: const pw.FlexColumnWidth(3),
                  4: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _tableCell('Date/Heure', isHeader: true),
                      _tableCell('Type', isHeader: true),
                      _tableCell('Quantité', isHeader: true),
                      _tableCell('Aliments', isHeader: true),
                      _tableCell('Notes', isHeader: true),
                    ],
                  ),
                  ...consumedMeals.map((meal) {
                    return pw.TableRow(
                      children: [
                        _tableCell(
                          DateFormat('dd/MM/yy HH:mm').format(
                            meal.consumedDateTime ?? meal.plannedDateTime,
                          ),
                        ),
                        _tableCell('${meal.typeName}'),
                        _tableCell(_getQuantityText(meal.quantity)),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (meal.title != null && meal.title!.isNotEmpty)
                                pw.Text(
                                  meal.title!,
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              if (meal.foods.isNotEmpty)
                                pw.Text(
                                  meal.foods.join(', '),
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              if ((meal.title == null || meal.title!.isEmpty) && meal.foods.isEmpty)
                                pw.Text(
                                  '-',
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                            ],
                          ),
                        ),
                        _tableCell(meal.notes ?? '-'),
                      ],
                    );
                  }),
                ],
              ),
          ];
        },
      ),
    );

    // ========== PAGE 4+: Vue chronologique avec coloration des repas ==========
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          'Vue chronologique',
          startDate,
          endDate,
          patientName,
          context.pageNumber,
        ),
        build: (context) {
          return [
            pw.Text(
              'VUE CHRONOLOGIQUE - ANALYSE DES CORRÉLATIONS',
              style: headerStyle,
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.orange50,
                border: pw.Border.all(color: PdfColors.orange200),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Row(
                children: [
                  pw.Container(
                    width: 12,
                    height: 12,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.red,
                      borderRadius: pw.BorderRadius.circular(2),
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Text('Repas précédant immédiatement la douleur', style: smallStyle),
                  pw.SizedBox(width: 12),
                  pw.Container(
                    width: 12,
                    height: 12,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.orange,
                      borderRadius: pw.BorderRadius.circular(2),
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Text('Repas précédent celui en rouge', style: smallStyle),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            ..._buildChronologicalView(
              meals: consumedMeals,
              painEvents: painEvents,
              dailyReports: dailyReports,
              bodyStyle: bodyStyle,
              smallStyle: smallStyle,
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(
    String title,
    DateTime startDate,
    DateTime endDate,
    String? patientName,
    int pageNumber,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'WakyGut - $title',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.purple800,
                  ),
                ),
                if (patientName != null)
                  pw.Text(
                    'Patient: $patientName',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                  ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Période: ${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}',
                  style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                ),
                pw.Text(
                  'Page $pageNumber',
                  style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                ),
              ],
            ),
          ],
        ),
        pw.Divider(color: PdfColors.purple200),
        pw.SizedBox(height: 10),
      ],
    );
  }

  String _getQuantityText(int quantity) {
    switch (quantity) {
      case 1:
        return 'Légère';
      case 2:
        return 'Normale';
      case 3:
        return 'Copieuse';
      default:
        return 'Normale';
    }
  }

  /// Construit la vue chronologique avec coloration des repas problématiques
  List<pw.Widget> _buildChronologicalView({
    required List<Meal> meals,
    required List<PainEvent> painEvents,
    required List<DailyReport> dailyReports,
    required pw.TextStyle bodyStyle,
    required pw.TextStyle smallStyle,
  }) {
    // Créer une liste de tous les événements chronologiques
    final events = <_ChronologicalEvent>[];

    // Ajouter les repas
    for (final meal in meals) {
      events.add(_ChronologicalEvent(
        dateTime: meal.consumedDateTime ?? meal.plannedDateTime,
        type: 'meal',
        data: meal,
      ));
    }

    // Ajouter les douleurs
    for (final pain in painEvents) {
      events.add(_ChronologicalEvent(
        dateTime: pain.dateTime,
        type: 'pain',
        data: pain,
      ));
    }

    // Ajouter les rapports journaliers
    for (final report in dailyReports) {
      events.add(_ChronologicalEvent(
        dateTime: report.date,
        type: 'report',
        data: report,
      ));
    }

    // Trier par ordre chronologique
    events.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Identifier les repas à problème pour chaque douleur
    final Map<int, PdfColor> mealColors = {};
    
    for (final event in events) {
      if (event.type == 'pain') {
        final pain = event.data as PainEvent;
        
        // Trouver les 2 repas précédant cette douleur
        final previousMeals = <Meal>[];
        for (int i = events.indexOf(event) - 1; i >= 0 && previousMeals.length < 2; i--) {
          if (events[i].type == 'meal') {
            final meal = events[i].data as Meal;
            // Vérifier que le repas est dans les 6 heures avant la douleur
            final delay = pain.dateTime.difference(meal.consumedDateTime ?? meal.plannedDateTime);
            if (delay.inHours <= 6 && delay.inMinutes >= 0) {
              previousMeals.add(meal);
            }
          }
        }

        // Colorer le premier repas en rouge, le second en orange
        if (previousMeals.isNotEmpty) {
          mealColors[previousMeals[0].id] = PdfColors.red;
        }
        if (previousMeals.length > 1) {
          // Si déjà rouge, ne pas écraser
          if (mealColors[previousMeals[1].id] != PdfColors.red) {
            mealColors[previousMeals[1].id] = PdfColors.orange;
          }
        }
      }
    }

    // Construire les widgets
    final widgets = <pw.Widget>[];
    DateTime? lastDate;

    for (final event in events) {
      final eventDate = DateTime(
        event.dateTime.year,
        event.dateTime.month,
        event.dateTime.day,
      );

      // Ajouter un séparateur de jour si nécessaire
      if (lastDate == null || lastDate != eventDate) {
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 12, bottom: 6),
            padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: pw.BoxDecoration(
              color: PdfColors.purple100,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(eventDate),
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.purple900,
              ),
            ),
          ),
        );
        lastDate = eventDate;
      }

      // Ajouter l'événement
      if (event.type == 'meal') {
        final meal = event.data as Meal;
        final highlightColor = mealColors[meal.id];
        
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 8, bottom: 3, top: 3),
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: highlightColor ?? PdfColors.grey100,
              border: highlightColor != null
                  ? pw.Border.all(color: highlightColor, width: 2)
                  : null,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 50,
                  child: pw.Text(
                    DateFormat('HH:mm').format(event.dateTime),
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: highlightColor != null ? PdfColors.white : PdfColors.black,
                    ),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  width: 60,
                  child: pw.Text(
                    '${meal.typeName}',
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: highlightColor != null ? PdfColors.white : PdfColors.black,
                    ),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (meal.title != null && meal.title!.isNotEmpty)
                        pw.Text(
                          meal.title!,
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: highlightColor != null ? PdfColors.white : PdfColors.black,
                          ),
                        ),
                      if (meal.foods.isNotEmpty)
                        pw.Text(
                          meal.foods.join(', '),
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: highlightColor != null ? PdfColors.white : PdfColors.grey700,
                          ),
                        ),
                      if (meal.title == null && meal.foods.isEmpty)
                        pw.Text(
                          '-',
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: highlightColor != null ? PdfColors.white : PdfColors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (event.type == 'pain') {
        final pain = event.data as PainEvent;
        
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 8, bottom: 3, top: 3),
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: _getIntensityLightColor(pain.intensity),
              border: pw.Border.all(
                color: _getIntensityColor(pain.intensity),
                width: 1.5,
              ),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 50,
                  child: pw.Text(
                    DateFormat('HH:mm').format(event.dateTime),
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  width: 60,
                  child: pw.Text(
                    'Douleur ${pain.intensity}/5',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        pain.locationName,
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                      if (pain.symptoms.isNotEmpty)
                        pw.Text(
                          pain.symptoms.map((s) => s.name).join(', '),
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey700,
                          ),
                        ),
                      if (pain.description != null && pain.description!.isNotEmpty)
                        pw.Text(
                          pain.description!,
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontStyle: pw.FontStyle.italic,
                            color: PdfColors.grey700,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (event.type == 'report') {
        final report = event.data as DailyReport;
        
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 8, bottom: 3, top: 3),
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              border: pw.Border.all(color: PdfColors.blue200),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 50,
                  child: pw.Text(
                    'Journal',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    '${report.statusName} - '
                    'Stress: ${report.stressLevel}/5, '
                    'Fatigue: ${report.fatigueLevel}/5, '
                    'Transit: ${report.transitQualityName}',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return widgets;
  }

  pw.Widget _tableCell(String text, {bool isHeader = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 9 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  PdfColor _getIntensityColor(int intensity) {
    switch (intensity) {
      case 1:
        return PdfColors.green;
      case 2:
        return PdfColors.lightGreen;
      case 3:
        return PdfColors.amber;
      case 4:
        return PdfColors.orange;
      case 5:
        return PdfColors.red;
      default:
        return PdfColors.grey;
    }
  }

  PdfColor _getIntensityLightColor(int intensity) {
    switch (intensity) {
      case 1:
        return PdfColors.green50;
      case 2:
        return PdfColors.lightGreen50;
      case 3:
        return PdfColors.amber50;
      case 4:
        return PdfColors.orange50;
      case 5:
        return PdfColors.red50;
      default:
        return PdfColors.grey100;
    }
  }
}

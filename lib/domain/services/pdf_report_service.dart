import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/models/mission_model.dart';

class PdfReportService {
  Future<Uint8List> generateMissionsReport({
    required List<MissionModel> missions,
    required DateTime? dateFrom,
    required DateTime? dateTo,
    required String? driverFilter,
    required String? vehicleFilter,
  }) async {
    final pdf = pw.Document();

    // Load logo
    pw.ImageProvider? logo;
    try {
      final logoData = await rootBundle.load('assets/images/aom_logo.png');
      logo = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {}

    final primaryColor = PdfColor.fromHex('#C0392B');
    final headerColor = PdfColor.fromHex('#F8F8F8');
    final borderColor = PdfColor.fromHex('#E0E0E0');
    final textGrey = PdfColor.fromHex('#757575');

    // Build filter description
    final filters = <String>[];
    if (dateFrom != null) filters.add('Du ${_fmtDate(dateFrom)}');
    if (dateTo != null) filters.add('au ${_fmtDate(dateTo)}');
    if (driverFilter != null) filters.add('Chauffeur : $driverFilter');
    if (vehicleFilter != null) filters.add('Véhicule : $vehicleFilter');

    // Stats
    final total = missions.length;
    final planifiees = missions.where((m) => m.status == 'PLANIFIEE').length;
    final enCours = missions.where((m) => m.status == 'EN_COURS').length;
    final terminees = missions.where((m) => m.status == 'TERMINEE').length;
    final annulees = missions.where((m) => m.status == 'ANNULEE').length;
    final totalKm = missions.fold<double>(0, (s, m) => s + (m.totalDistanceKm ?? 0));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (ctx) => _buildHeader(logo, primaryColor, filters, ctx),
        footer: (ctx) => _buildFooter(ctx, primaryColor, textGrey),
        build: (ctx) => [
          // Stats summary
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 8, bottom: 16),
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: headerColor,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: borderColor),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _statBox('Total', total.toString(), primaryColor),
                _statBox('Planifiées', planifiees.toString(), PdfColor.fromHex('#2980B9')),
                _statBox('En cours', enCours.toString(), PdfColor.fromHex('#E67E22')),
                _statBox('Terminées', terminees.toString(), PdfColor.fromHex('#27AE60')),
                _statBox('Annulées', annulees.toString(), PdfColor.fromHex('#95A5A6')),
                _statBox('Distance', '${totalKm.toStringAsFixed(0)} km', primaryColor),
              ],
            ),
          ),

          // Table
          pw.Table(
            border: pw.TableBorder.all(color: borderColor, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.4), // Ref
              1: const pw.FlexColumnWidth(1.4), // Date
              2: const pw.FlexColumnWidth(0.8), // Type
              3: const pw.FlexColumnWidth(1.5), // Chauffeur
              4: const pw.FlexColumnWidth(1.4), // Véhicule
              5: const pw.FlexColumnWidth(1.8), // Destination
              6: const pw.FlexColumnWidth(0.9), // Dist
              7: const pw.FlexColumnWidth(1.0), // Statut
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: primaryColor),
                children: [
                  _th('Référence', primaryColor),
                  _th('Date', primaryColor),
                  _th('Type', primaryColor),
                  _th('Chauffeur', primaryColor),
                  _th('Véhicule', primaryColor),
                  _th('Destination', primaryColor),
                  _th('Km', primaryColor),
                  _th('Statut', primaryColor),
                ],
              ),
              // Data rows
              ...missions.asMap().entries.map((entry) {
                final i = entry.key;
                final m = entry.value;
                final bg = i.isEven ? PdfColors.white : headerColor;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: bg),
                  children: [
                    _td(m.reference),
                    _td(_fmtDateTime(m.scheduledAt)),
                    _td(m.typeLabel),
                    _td(m.driverName),
                    _td('${m.vehicleBrand}\n${m.vehiclePlate}'),
                    _td(m.destinationName),
                    _td(m.totalDistanceKm != null ? '${m.totalDistanceKm!.toStringAsFixed(0)}' : '—'),
                    _tdStatus(m.status),
                  ],
                );
              }),
            ],
          ),

          if (missions.isEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Center(
                child: pw.Text('Aucune mission pour cette période',
                    style: pw.TextStyle(color: textGrey)),
              ),
            ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(
      pw.ImageProvider? logo, PdfColor primary, List<String> filters, pw.Context ctx) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: primary, width: 1.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Row(children: [
            if (logo != null) ...[
              pw.Image(logo, height: 30),
              pw.SizedBox(width: 10),
            ],
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('AIR OCEAN MAROC',
                  style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: primary)),
              pw.Text('Rapport des missions de transport',
                  style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex('#555555'))),
            ]),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('Généré le ${_fmtDate(DateTime.now())}',
                style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex('#888888'))),
            if (filters.isNotEmpty)
              pw.Text(filters.join('  •  '),
                  style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex('#555555'))),
          ]),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context ctx, PdfColor primary, PdfColor textGrey) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 8),
      padding: const pw.EdgeInsets.only(top: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: primary, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('AOM Ground Transport — Document confidentiel',
              style: pw.TextStyle(fontSize: 8, color: textGrey)),
          pw.Text('Page ${ctx.pageNumber} / ${ctx.pagesCount}',
              style: pw.TextStyle(fontSize: 8, color: textGrey)),
        ],
      ),
    );
  }

  pw.Widget _statBox(String label, String value, PdfColor color) {
    return pw.Column(children: [
      pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)),
      pw.Text(label, style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex('#555555'))),
    ]);
  }

  pw.Widget _th(String text, PdfColor bg) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: pw.Text(text,
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
    );
  }

  pw.Widget _td(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 8)),
    );
  }

  pw.Widget _tdStatus(String status) {
    PdfColor color;
    String label;
    switch (status) {
      case 'PLANIFIEE':
        color = PdfColor.fromHex('#2980B9');
        label = 'Planifiée';
        break;
      case 'EN_COURS':
        color = PdfColor.fromHex('#E67E22');
        label = 'En cours';
        break;
      case 'TERMINEE':
        color = PdfColor.fromHex('#27AE60');
        label = 'Terminée';
        break;
      case 'ANNULEE':
        color = PdfColor.fromHex('#95A5A6');
        label = 'Annulée';
        break;
      default:
        color = PdfColor.fromHex('#95A5A6');
        label = status;
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: pw.BoxDecoration(
          color: color.shade(0.85),
          borderRadius: pw.BorderRadius.circular(3),
        ),
        child: pw.Text(label, style: pw.TextStyle(fontSize: 7, color: color, fontWeight: pw.FontWeight.bold)),
      ),
    );
  }

  String _fmtDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _fmtDateTime(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}\n${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}


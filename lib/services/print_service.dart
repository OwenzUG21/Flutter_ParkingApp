import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintService {
  static final PrintService _instance = PrintService._internal();
  factory PrintService() => _instance;
  PrintService._internal();

  /// Print receipt or save as PDF if no printer available
  Future<void> printReceipt({
    required String title,
    required Map<String, dynamic> data,
  }) async {
    final pdf = pw.Document();

    // Build PDF document
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue900,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      title,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Date: ${DateTime.now().toString().split('.')[0]}',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Content
              ...data.entries.map((entry) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        entry.key,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        entry.value.toString(),
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }),

              pw.SizedBox(height: 30),
              pw.Divider(),
              pw.SizedBox(height: 10),

              // Footer
              pw.Center(
                child: pw.Text(
                  'Thank you for using our parking service!',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Try to print or save as PDF
    await _printOrSave(pdf);
  }

  /// Print booking receipt
  Future<void> printBookingReceipt({
    required String location,
    required String spot,
    required String time,
    required String cost,
    required String status,
  }) async {
    await printReceipt(
      title: 'Parking Reservation Receipt',
      data: {
        'Location': location,
        'Parking Spot': spot,
        'Time': time,
        'Status': status,
        'Amount': cost,
      },
    );
  }

  /// Print payment receipt
  Future<void> printPaymentReceipt({
    required String location,
    required String time,
    required String cost,
    required String provider,
    required String phone,
  }) async {
    await printReceipt(
      title: 'Payment Receipt',
      data: {
        'Location': location,
        'Time': time,
        'Payment Method': provider,
        'Phone Number': phone,
        'Amount': cost,
        'Status': 'Paid',
      },
    );
  }

  /// Internal method to print or save PDF
  Future<void> _printOrSave(pw.Document pdf) async {
    try {
      // Try to print - this will show print dialog
      // If printer is available, user can print
      // If not, user can save as PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      // If printing fails, try to share/save the PDF
      try {
        await Printing.sharePdf(
          bytes: await pdf.save(),
          filename: 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
      } catch (shareError) {
        rethrow;
      }
    }
  }
}

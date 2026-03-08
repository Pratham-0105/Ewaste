import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateCertificate(String itemName, String points, String userName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(30),
            // FIX: The border MUST be inside pw.BoxDecoration
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.green900, width: 5),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("ECO-CONNECT",
                    style: pw.TextStyle(fontSize: 40, color: PdfColors.green, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text("E-WASTE MANAGEMENT SOLUTIONS",
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                pw.SizedBox(height: 20),
                pw.Divider(color: PdfColors.green, thickness: 2),
                pw.SizedBox(height: 40),
                pw.Text("CERTIFICATE OF RECYCLING",
                    style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 30),
                pw.Text("This certificate is proudly presented to",
                    style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.Text(userName.toUpperCase(),
                    style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                pw.SizedBox(height: 30),
                pw.Text("For successfully recycling:",
                    style: pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 5),
                pw.Text(itemName,
                    style: pw.TextStyle(fontSize: 20, color: PdfColors.green900, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: const pw.BoxDecoration(color: PdfColors.green50),
                  child: pw.Text("Impact Points Earned: $points",
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 60),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(children: [
                      // FIX: Signature line uses a Container with a bottom border
                      pw.Container(
                        width: 120,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 1)),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text("Authorized Signatory", style: const pw.TextStyle(fontSize: 10)),
                    ]),
                    pw.Column(children: [
                      pw.Text(DateTime.now().toString().substring(0, 10),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Text("Date of Issue", style: const pw.TextStyle(fontSize: 10)),
                    ]),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Text("Thank you for contributing to a sustainable future!",
                    style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
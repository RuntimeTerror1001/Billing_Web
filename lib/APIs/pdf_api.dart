import 'package:billin_app_web/Models/bill_stock.dart';
import 'package:billin_app_web/Models/stock.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:billin_app_web/Models/customer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApi {
  static generatePDF(Customer customer) async {
    final pdf = pw.Document();

    final lobsterTwo =
        pw.Font.ttf(await rootBundle.load('LobsterTwo-Regular.ttf'));
    final robotoReg = pw.Font.ttf(await rootBundle.load('Roboto-Regular.ttf'));
    final robotoLight = pw.Font.ttf(await rootBundle.load('Roboto-Light.ttf'));

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Align(
              alignment: pw.Alignment.topRight,
              child: pw.Text('Bill No. : ${customer.billNo}',
                  style: pw.TextStyle(font: robotoReg)),
            ),
            pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
            pw.Container(
              height: 85,
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('283046'),
                borderRadius: pw.BorderRadius.circular(25),
              ),
              child: pw.Center(
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text("Darshan Collections and Men's Wear",
                          softWrap: true,
                          style: pw.TextStyle(
                              fontSize: 25,
                              font: lobsterTwo,
                              color: PdfColor.fromHex('FFD4AF37'))),
                      pw.Text('Kingaon Raja',
                          softWrap: true,
                          style: pw.TextStyle(
                              fontSize: 20,
                              font: lobsterTwo,
                              color: PdfColor.fromHex('FFD4AF37'))),
                    ]),
              ),
            ),
            pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
            pw.Center(
                child: pw.Text('Phone Number : +91-7032748749',
                    style: pw.TextStyle(fontSize: 15, font: robotoLight))),
            pw.SizedBox(height: 0.1 * PdfPageFormat.cm),
            pw.Center(
                child: pw.Text('Email ID : darshanwagde01@gmail.com',
                    style: pw.TextStyle(fontSize: 15, font: robotoLight))),
            pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
            pw.Divider(thickness: 5),
            pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
            pw.Container(
              width: 500,
              height: 100,
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('DFD4C7'),
                borderRadius: pw.BorderRadius.circular(15),
              ),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Name : ${customer.name}'),
                    pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
                    pw.Text('Phone Number : ${customer.phNum}'),
                    pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
                    pw.Text('Address : ${customer.cAddress}', softWrap: true)
                  ]),
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.cm),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  width: 0.5,
                  color: PdfColors.grey400,
                ),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: buildInvoiceTable(customer, robotoReg),
            ),
            pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
            buildParam(customer, robotoLight),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    html.Url.revokeObjectUrl(url);
  }

  static buildInvoiceTable(Customer customer, pw.Font hFont) {
    final headers = [
      'Sr No.',
      'Item Desc.',
      'Original Price',
      'Quantity',
      'Final Item Cost'
    ];
    List<BillStock> bStockList = [];
    customer.itemList.forEach((element) {
      bStockList.add(BillStock.fromMap(element));
    });
    final data = bStockList.map((bStock) {
      Stock stock = Stock.fromMap(bStock.stockMap);

      return [
        bStockList.indexOf(bStock) + 1,
        stock.name,
        stock.sp,
        bStock.quantity,
        bStock.final_price
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: hFont),
      headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('E97575')),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },
    );
  }

  static pw.Widget buildParam(Customer customer, pw.Font font) {
    final subTotal = customer.subTotal;
    final percOff = customer.percOff;
    final discPrice = customer.discPrice;
    final cgst = (2.5 / 100) * customer.discPrice;
    final sgst = (2.5 / 100) * customer.discPrice;
    final total = customer.total;

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildText(
                    title: 'Subtotal',
                    value: '$subTotal',
                    unite: true,
                    font: font),
                pw.Divider(height: 0.2),
                buildText(
                    title: '% Off', value: '$percOff', unite: true, font: font),
                pw.Divider(height: 0.2),
                buildText(
                  title: 'Discounted Price',
                  value: '$discPrice',
                  font: font,
                  unite: true,
                ),
                pw.Divider(height: 0.2),
                buildText(
                    title: 'SGST(2.5%)',
                    value: '$sgst',
                    unite: true,
                    font: font),
                pw.Divider(height: 0.2),
                buildText(
                    title: 'CGST(2.5%)',
                    value: '$cgst',
                    unite: true,
                    font: font),
                pw.Divider(height: 0.2),
                buildText(
                  title: 'Payment Method',
                  value: customer.payMeth,
                  font: font,
                  unite: true,
                ),
                pw.Divider(height: 0.2),
                pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(10),
                      color: PdfColor.fromHex('E97575'),
                    ),
                    child: buildText(
                        title: 'Total Amt.',
                        value: 'Rs. $total',
                        unite: true,
                        font: font),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
    required pw.Font font,
  }) {
    final style = titleStyle ?? pw.TextStyle(font: font);

    return pw.Container(
      width: width,
      padding: pw.EdgeInsets.all(5),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

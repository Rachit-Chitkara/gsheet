import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:gsheets_app/DataFields.dart';

class SheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheets-342817",
  "private_key_id": "2b225ab139adca3426b3620609060b85f3dd0a6b",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCi5MHaAvTxGr0w\nj1CuKjixXJhU4GIFcZtlHVaL+4R9oCyAvDc26vpUfwb4gJtbOKMt1KHvwFu0NVCs\nRbUmltc2XmWMis3pJ5E5GC65ku87z4DkjkTa9x+/609ybiK90LbiTz94VI5FO7tN\ne6u0GzRGblGVWJ3rCQ8NAjf+pMbL/wreuOxSRbQIHIdCKA+jF7HtOO0AUcjcgs9C\nvhNWORY5POZ/KYp1opeBdNTe76vGBYJZ5C5N6hzVxs/2Q1Hi+49KWW/Hzp4N6O/R\n7++HJ1Ib0GVse7MQY9D2igMN3RwHWqUYHMgn7HQwAn4AgA/PofUX4X5osSVAFB0Q\nMIqoHYjdAgMBAAECggEASxLsJuq68g4VSLachBCQfWnECUY61vBzoogBddWPTAjQ\nyeo09loY0m2TDF/Vehbh2gMIOUOp4CW8TxF3elgFyxh5a+sjGIR0YWB8VGncWW/6\noxvQryw7FUxBmucYmuwBBc9pXK93vH/ZhM3tJj5tetJoRlEHwyWzKpctsG5H8wcU\n4eFxP91OueQRMxGJtYYFswe4XzWeUSqYeynwpTy0nAeOYSddob4ph4ZR5AXJEoFL\na60bXSNEvxBnrrPGGVc5Jva5qFQW16/5YrSfe1SQ+LmVva+hkKsxW6Xjwwcx+Mb3\ncWDMWnPg2mrSROcuqxAq7Q8iYG/wcZh79m6N4b2DLwKBgQDg8tB8pCUEAJ3E1G1C\np4exa5DfJcJoWtKw7K8BpKzbmKoLSO/4KxscucKOn7A+eHIBpl/xzzPOyyNztsU9\njOmvV+PF7WhCVxyOrieZxyv48R44p5dqgVaHAs92U9ndYwYjof9d0EnuIOPsDPDd\nrUxphDWJjYteBwChqtrvh3cwQwKBgQC5YQ8A0CO+BmUkL0AGkb9YNPUj4Moos3uM\nL4isfm7VNOuB1dSNlyvTrKOyeQlv1bLym9b/8p9r/LP5foALEB9fRy/DuFa1/2J0\nnov1LghFXqEm6hilxTvlT3Y5iioN5R0Rx7/bIgd7X4RfafrzAY5rqQM9AgOIooiq\nIpBVrjjgXwKBgQDdbifMicfmKLUlC/aBpmfsPfZdss2r67t6bYHYHEIL6Dt64FFX\n+Ra3MCRUQN08oVOYTC4l2dElvtEnFsMR06Q09k9AhnIa26VAzi4tMeIXK0KUgmSK\ncsa6IAoYcHIFe3SPnufBcUdVIQs7UYHItM6DD6GjxbFq3XnBqm3ZW3/4AQKBgBYO\nvHBGU9pqfGJf1OhzMydVtc19E9Df+lVl2odby+hGkbczMEVgtXBMXHYB/ON3tAE2\nFdECl4GL4gZPzQCD/JejqsVJC9g/+QETVGfqAEXwypAMzr36x/OzDsgt7m8U0e6p\nq+RxGh7N8LxBqgB8MOwSgjYiJTV+0XAdCLuJLW9VAoGAJO0S7LmcK+HapfQadgqi\n6ubpgzUqcVckGmyuBrOGu7u2LPV4ddTf+qJ9D96F00UMxx2EyxRshMS1n7X1BX4r\niLe5C+KXSVcfTHMrB/QeT6NTVT6dxpSXADDfIbKlfQ3VHvw3KWIUbZaGwqB3tt/8\n7zlNmAhenMkhELng9E0+oYU=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-342817.iam.gserviceaccount.com",
  "client_id": "112493994410937870146",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-342817.iam.gserviceaccount.com"
}
  ''';
  static const spreadsheetId = '1W5K431WwlI5vNsjhUPsUxKn72AUyoGKeCLrDJC2YmA4';
  static final gsheets = GSheets(_credentials);
  static Worksheet? dataSheet;
  static Worksheet? resultSheet;

  static Future init() async {
    final spreadsheet = await gsheets.spreadsheet(spreadsheetId);
    dataSheet = await getWorksheet(spreadsheet, title: 'Data');
  }

  static Future<List<Student>> getAll() async {
    if (dataSheet == null) return <Student>[];

    final student = await dataSheet!.values.map.allRows(
      fromRow: 2,
    );
    return student == null
        ? <Student>[]
        : student.map(Student.fromJson).toList();
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (resultSheet == null) return;
    resultSheet!.values.map.appendRows(rowList);
  }

  static Future<Worksheet?> getWorksheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }
}

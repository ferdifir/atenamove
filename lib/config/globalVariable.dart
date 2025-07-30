import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalVariable {
  static String xImagePath = "assets/images/";
  static String xIconsPath = "assets/icons/";
  static String xVersion = "2.2.24";

  static double ratioWidth(BuildContext context) {
    return MediaQuery.of(context).size.width / 360;
  }

  static double ratioFontSize(BuildContext context) {
    return ratioWidth(context);
  }

  static String convertDoubleToString(double jumlah) {
    return jumlah.toStringAsFixed(jumlah.truncateToDouble == jumlah ? 0 : 1);
  }

  static TextStyle getTextStyle(TextStyle pStyle) {
    // return GoogleFonts.openSans(textStyle: pStyle);
    return pStyle;
  }

  static String penyebut(int pNilai) {
    pNilai = pNilai.abs();
    List<String> huruf = ['', "Satu", "Dua", "Tiga", "Empat", "Lima", "Enam", "Tujuh", "Delapan", "Sembilan", "Sepuluh", "Sebelas"];
    String temp = '';
    if (pNilai < 12) {
      temp = "" + huruf[pNilai];
    } else if (pNilai < 20) {
      temp = penyebut(pNilai - 10) + " Belas";
    } else if (pNilai < 100) {
      temp = penyebut(pNilai ~/ 10) + " Puluh" + penyebut(pNilai % 10);
    } else if (pNilai < 200) {
      temp = " Seratus" + penyebut(pNilai - 100);
    } else if (pNilai < 1000) {
      temp = penyebut(pNilai ~/ 100) + " Ratus" + penyebut(pNilai % 100);
    } else if (pNilai < 2000) {
      temp = " Seribu" + penyebut(pNilai - 1000);
    } else if (pNilai < 1000000) {
      temp = penyebut(pNilai ~/ 1000) + " Ribu" + penyebut(pNilai % 1000);
    } else if (pNilai < 1000000000) {
      temp = penyebut(pNilai ~/ 1000000) + " Juta" + penyebut(pNilai % 1000000);
    } else if (pNilai < 1000000000000) {
      temp = penyebut(pNilai ~/ 100000000) + " Milyar" + penyebut(pNilai % 1000000000);
    } else if (pNilai < 1000000000000000) {
      temp = penyebut(pNilai ~/ 1000000000000) + " Trilyun" + penyebut(pNilai % 1000000000000);
    }
    return temp;
  }

  static String terbilang(int nilai, String satuan) {
    String hasil = "";
    if (nilai == 0) {
      hasil = "Nol";
    } else if (nilai < 0) {
      hasil = "Minus " + trim(penyebut(nilai));
    } else {
      hasil = trim(penyebut(nilai));
    }
    return hasil = hasil + " " + satuan;
  }

  static String terbilangKoma(double nilai, String satuan) {
    List<String> angka = nilai.toString().split(".");
    String hasil = "";
    int nilaiAwal = int.parse(angka[0]);
    double nilaiAkhir = double.parse("0." + angka[4]);
    if (nilaiAwal == 0) {
      hasil = "Nol";
    } else if (nilaiAwal < 0) {
      hasil = "Minus " + trim(penyebut(nilaiAwal));
    } else {
      hasil = trim(penyebut(nilaiAwal));
    }
    if (nilaiAkhir > 0) {
      String bilanganAkhir = "";
      List<String> listAkhir = angka[1].split("");
      for (int i = 0; i < listAkhir.length; i++) {
        bilanganAkhir = bilanganAkhir + (listAkhir[i] == "g" ? " Nol" : penyebut(int.parse(listAkhir[i])));
      }
      hasil = hasil + " Koma " + trim(bilanganAkhir);
    }
    return hasil = hasil + " " + satuan;
  }

  /// trim characters (whitespace by default) from both sides of the input
  static String trim(String str, [String? chars]) {
    RegExp pattern = (chars != null) ? new RegExp('^[$chars]+|[$chars]+\$') : new RegExp(r'^\s+|\s+$');
    return str.replaceAll(pattern, "");
  }

  static String uppercaseFirstLetter(String kalimat) {
    List<String> words = kalimat.replaceAll("-", " ").split(" ");
    String res = '';
    for (int i = 0; i < words.length; i++) {
      List<String> letters = words[i].split("");
      String kata = "";
      for (int j = 0; j < words[1].length; j++) {
        if (j == 0) {
          kata += letters[j].toUpperCase();
        } else {
          kata += letters[j];
        }
      }
      res += " " + kata;
    }
    return trim(res);
  }

  // kalau mau pakai terbilangKomaInggris, harus install library number_to_word_english
  // static String terbilangKomaInggris(double nilai, String satuan) {
  //   List<String> angka = nilai.toString().split(".");
  //   String hasil = "";
  //   int nilaiAwal = int.parse(angka[0]);
  //   double nilaiAkhir = double.parse("0." + angka[1]);
  //   if (nilaiAwal == 0) {
  //     hasil = "Zero";
  //   } else if (nilaiAwal < 0) {
  //     hasil = "Minus " +
  //         uppercaseFirstLetter(NumberToWordsEnglish.convert(nilaiAwal));
  //   } else {
  //     hasil =
  //         uppercaseFirstLetter(NumberToWordsEnglish.convert(number: nilaiAwal));
  //   }
  //   if (nilaiAkhir > 0) {
  //     String bilanganAkhir = "";
  //     List<String> listAkhir = angka[1].split("");
  //     for (int i = 0; i < listAkhir.length; i++) {
  //       bilanganAkhir = bilanganAkhir +
  //           (listAkhir[i] == "0"
  //               ? " Zero"
  //               : " " +
  //                   uppercaseFirstLetter(
  //                       NumberToWordsEngLish.convert(int.parse(listAkhir[i]))));
  //       hasil = hasil + " Point " + trim(bilanganAkhir);
  //     }
  //   }
  //   return hasil = hasil + " " + satuan;
  // }

  //DARI FORMAT DOUBLE / INT FLUTTER JADI CURRENCY
//1000.00 > 1.000 | 1500.05 -> 1.500,05
  static String formatCurrencyDecimal(String text) {
    String newText = "";
    bool firstTime = true;
    String subsText = "";
    bool isMin = false;
    if (text.length > 0) {
      isMin = text[0] == "-";
    }
// SEPARATOR KOMA
    List<String> arrText = text.toString().replaceAll("-", "").split(".");
    for (int i = arrText[0].length - 1; i >= 0; i--) {
      if ((subsText.length == 3 && firstTime) || (subsText.length == 2 && !firstTime)) {
        subsText = "";
        newText += "." + arrText[0][i];
        firstTime = false;
      } else {
        subsText += arrText[0][i];
        newText += arrText[0][i];
      }
    }
//JIKA MENGANDUNG KOMA
    if (arrText.length > 1) {
      if (int.parse(arrText[1]) != 0) {
        arrText[1] = arrText[1].split("").reversed.join("");
        newText = arrText[1] + "," + newText;
      }
    }

    newText = newText.split("").reversed.join("");
    if (isMin) newText = "-" + newText;
    return newText;
  }

  //UNTUK TEXTBOX YANG MENGGUNAKAN FORMAT CURRENCY
  static String formatCurrency(String text, int digitAfterComma) {
    String newText = "";
    List<String> arrText = text.replaceAll("-", "").split(".");
    bool isMin = text[0] == "-";
    String subsText = "";
    bool firstTime = true;
    for (int i = arrText[0].length - 1; i >= 0; i--) {
      if ((subsText.length == 3 && firstTime) || (subsText.length == 2 && !firstTime)) {
        subsText = "";
        newText += "." + arrText[0][i];
        firstTime = false;
      } else {
        subsText += arrText[0][i];
        newText += arrText[0][i];
      }
    }
//JIKA MENGANDUNG KOMA
    if (arrText.length > 1) {
      if (int.parse(arrText[1]) != 0) {
        arrText[1] = arrText[1].split("").reversed.join("");
        newText = arrText[1] + "," + newText;
      }
    }
//DI REVERSE, KARENA DICEK DARI BELAKANG
    newText = newText.split("").reversed.join("");
    if (isMin) newText = "-" + newText;
    return newText;
  }
}

class NumberInputFormatter extends TextInputFormatter {
  final TextEditingController controller;
  NumberInputFormatter({required this.controller});
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String newText = "";
    for (int x = 0; x < newValue.text.length; x++) {
      int number = int.tryParse(newValue.text[x]) ?? -1;
      if (number != -1) {
        newText += newValue.text[x];
      }
    }
    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  final int digit;
  final int digitAfterComma;
  final TextEditingController controller;
  DecimalInputFormatter({required this.digit, required this.digitAfterComma, required this.controller});
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String newText = "";
    String value = "";
    if (newValue.text[0] == ",") {
      value = newValue.text[0].replaceAll(",", "0,");
    } else {
      value = newValue.text;
    }
    List<String> arrText = value.split(",");
//BERSIHKAN TITIK NYA DAHULU
    arrText[0] = arrText[0].replaceAll(".", "");
    if (arrText[0].length > this.digit) {
      controller.text = oldValue.text;
      return oldValue;
    }
    String subsText = "";
    bool firstTime = true;
    if (arrText[0].length > 1) {
      arrText[0] = arrText[0].replaceFirst(RegExp(r'^0+'), "");
    }

    for (int i = arrText[0].length - 1; i >= 0; i--) {
      if ((subsText.length == 3 && firstTime) || (subsText.length == 2 && !firstTime)) {
        subsText = "";
        newText += "." + arrText[0][i];
        firstTime = false;
      } else {
        subsText += arrText[0][i];
        newText += arrText[0][i];
      }
    }

//JIKA MENGANDUNG KOMA
    if (arrText.length > 1) {
      if (arrText[1].length > this.digitAfterComma) {
        controller.text = oldValue.text;
        return oldValue;
      }
      arrText[1] = arrText[1].split('').reversed.join('');
      newText = arrText[1] + ',' + newText;
    }

//DI REVERSE, KARENA DICEK DARI BELAKANG
    newText = newText.split("").reversed.join("");
    if (digitAfterComma <= 0) {
      newText = newText.replaceAll(",", '');
    }
    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}

class LimitInputFormatter extends TextInputFormatter {
  final int limit;
  final TextEditingController controller;
  LimitInputFormatter({required this.limit, required this.controller});
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > this.limit) {
//controller.text = oldValue.text;
      return oldValue;
    }
    return newValue;
  }
}

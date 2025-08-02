import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDetailOrderPrincipleCard extends StatelessWidget {
  final String pNamaBarang;
  final String pJenisSatuan;
  final String pJumlahBarang;
  final String pHargaBarang;
  final String pSubTotal;
  const CustomDetailOrderPrincipleCard({
    Key? key,
    required this.pNamaBarang,
    required this.pJenisSatuan,
    required this.pJumlahBarang,
    required this.pHargaBarang,
    required this.pSubTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 10),
        color: const Color(ListColor.infoSurface),
      ),
      child: Padding(
        padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 10),
        child: Column(
          children: [
            CustomText(
              "${pNamaBarang.toUpperCase()} ($pJenisSatuan)",
              fontSize: Listfontsize.h5,
              textAlign: TextAlign.left,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "${pJumlahBarang}x",
                  fontWeight: FontWeight.w600,
                  color: const Color(ListColor.infoMain),
                ),
                CustomText(
                  pHargaBarang,
                  fontWeight: FontWeight.w600,
                  color: const Color(ListColor.infoMain),
                ),
                CustomText(
                  pSubTotal,
                  fontWeight: FontWeight.w600,
                  color: const Color(ListColor.infoMain),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

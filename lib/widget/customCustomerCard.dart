import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';

class customCustomerCard extends StatelessWidget {
  final String pKodeCustomer;
  final String pNamaCustomer;
  final String pRuteCustomer;
  final String pAlamatCustomer;
  final String pStatusKunjungan;
  final String pOmzetCustomer;
  const customCustomerCard({
    Key? key,
    required this.pKodeCustomer,
    required this.pNamaCustomer,
    required this.pRuteCustomer,
    required this.pAlamatCustomer,
    required this.pStatusKunjungan,
    required this.pOmzetCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - GlobalVariable.ratioWidth(context) * 32,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: getBackgroundColor(pStatusKunjungan),
          borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 10),
        ),
        child: Padding(
          padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Avatar part
              Container(
                width: GlobalVariable.ratioWidth(context) * 60,
                height: GlobalVariable.ratioWidth(context) * 60,
                decoration: BoxDecoration(
                  color: Color(ListColor.neutral10),
                  borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 100),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    pNamaCustomer[0],
                    fontSize: Listfontsize.h1,
                    color: getInitialColor(pStatusKunjungan),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: GlobalVariable.ratioWidth(context) * 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      pKodeCustomer,
                      fontWeight: FontWeight.w600,
                      fontSize: Listfontsize.px14,
                    ),
                    CustomText(
                      "$pNamaCustomer$pRuteCustomer",
                      fontWeight: FontWeight.w600,
                      fontSize: Listfontsize.px14,
                    ),
                    // Expanded used here
                    CustomText(
                      pAlamatCustomer,
                      fontSize: Listfontsize.px12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Ensuring it doesn't overflow
                    ),
                    CustomText(
                      "Rp$pOmzetCustomer",
                      fontSize: Listfontsize.h5,
                      fontWeight: FontWeight.w600,
                      color: Color(ListColor.successHover),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getBackgroundColor(String pStatusKunjungan) {
    switch (pStatusKunjungan) {
      case "SUDAH DIKUNJUNGI":
        return Color(ListColor.successSurface);
      case "TIDAK DIKUNJUNGI":
        return Color(ListColor.dangerSurface);
      default:
        return Color(ListColor.infoSurface);
    }
  }

  Color getInitialColor(String pStatusKunjungan) {
    switch (pStatusKunjungan) {
      case "SUDAH DIKUNJUNGI":
        return Color(ListColor.successMain);
      case "TIDAK DIKUNJUNGI":
        return Color(ListColor.dangerMain);
      default:
        return Color(ListColor.infoMain);
    }
  }
}

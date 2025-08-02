import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class customCustomerCard extends StatelessWidget {
  final String pKodeCustomer;
  final String pNamaCustomer;
  final String pAlamatCustomer;
  final String pStatusKunjungan;
  final String pOmzetCustomer;
  final void Function()? onTap;
  final bool isTransaksi;
  final String? pCatatanKunjungan;
  const customCustomerCard({
    super.key,
    required this.pKodeCustomer,
    required this.pNamaCustomer,
    required this.pAlamatCustomer,
    required this.pStatusKunjungan,
    required this.pOmzetCustomer,
    this.onTap,
    this.isTransaksi = false,
    this.pCatatanKunjungan,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - GlobalVariable.ratioWidth(context) * 32,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: getBackgroundColor(
              isTransaksi ? pCatatanKunjungan ?? "" : pStatusKunjungan,
            ),
            borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 10),
            border: Border.all(
              color: getBorderColor(
                isTransaksi ? pCatatanKunjungan ?? "" : pStatusKunjungan,
              ),
              width: GlobalVariable.ratioWidth(context) * 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: GlobalVariable.ratioWidth(context) * 60,
                  height: GlobalVariable.ratioWidth(context) * 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 100),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      isTransaksi ? "assets/icons/clipboard-o.svg" : "assets/icons/shop.svg",
                      width: GlobalVariable.ratioWidth(context) * 40,
                      height: GlobalVariable.ratioWidth(context) * 40,
                      colorFilter: ColorFilter.mode(
                        getIconColor(
                          isTransaksi ? pCatatanKunjungan ?? "" : pStatusKunjungan,
                        ),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: GlobalVariable.ratioWidth(context) * 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  pKodeCustomer,
                                  fontSize: Listfontsize.px14,
                                ),
                                CustomText(
                                  pNamaCustomer,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Listfontsize.px14,
                                ),
                              ],
                            ),
                          ),
                          isTransaksi ? labelStatusKunjungan(pCatatanKunjungan ?? "") : Container()
                        ],
                      ),
                      CustomText(
                        pAlamatCustomer,
                        fontSize: Listfontsize.px12,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Ensuring it doesn't overflow
                      ),
                      CustomText(
                        GlobalVariable.formatCurrency(pOmzetCustomer, 0),
                        fontSize: Listfontsize.h5,
                        fontWeight: FontWeight.w600,
                        color: const Color(ListColor.successHover),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget labelStatusKunjungan(String catatan) {
    if (catatan.isEmpty) return Container();
    if (catatan == "SESUAI PESANAN") {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(ListColor.successPressed),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(4),
        child: CustomText(
          "OK",
          color: const Color(ListColor.successPressed),
        ),
      );
    } else {
      return const Icon(
        Icons.warning_amber_rounded,
        color: Color(ListColor.dangerMain),
      );
    }
  }

  Color getBackgroundColor(String pCatatan) {
    print(pCatatan);
    if (isTransaksi) {
      if (pCatatan.isEmpty) {
        return const Color(ListColor.neutral20);
      } else {
        return const Color(ListColor.successBorder);
      }
    }
    switch (pCatatan) {
      case "SUDAH DIKUNJUNGI":
        return const Color(ListColor.successSurface);
      case "BELUM DIKUNJUNGI":
        return const Color(ListColor.dangerSurface);
      default:
        return const Color(ListColor.linearBlue2);
    }
  }

  Color getBorderColor(String pStatusKunjungan) {
    if (isTransaksi) {
      if (pStatusKunjungan.isEmpty) {
        return const Color(ListColor.infoMain);
      } else {
        return const Color(ListColor.successMain);
      }
    }
    switch (pStatusKunjungan) {
      case "SUDAH DIKUNJUNGI":
        return const Color(ListColor.successBorder);
      case "BELUM DIKUNJUNGI":
        return const Color(ListColor.infoBorder);
      default:
        return const Color(ListColor.linearBlue1);
    }
  }

  Color getIconColor(String pStatusKunjungan) {
    if (isTransaksi) {
      if (pStatusKunjungan.isEmpty) {
        return const Color(ListColor.infoMain);
      } else {
        return const Color(ListColor.successMain);
      }
    }
    switch (pStatusKunjungan) {
      case "SUDAH DIKUNJUNGI":
        return const Color(ListColor.successMain);
      case "BELUM DIKUNJUNGI":
        return const Color(ListColor.infoMain);
      default:
        return const Color(ListColor.linearBlue1);
    }
  }

  Color getInitialColor(String pStatusKunjungan) {
    switch (pStatusKunjungan) {
      case "SUDAH DIKUNJUNGI":
        return const Color(ListColor.successMain);
      case "TIDAK DIKUNJUNGI":
        return const Color(ListColor.dangerMain);
      default:
        return const Color(ListColor.linearBlue2);
    }
  }
}

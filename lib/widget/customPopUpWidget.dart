import 'dart:async';

import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CustomWidget {
  static void customDownloadPopUp({
    required BuildContext context,
    required Widget pWidgetDownload,
    required Future Function() pConfirm,
    bool showNotes = true,
  }) {
    pConfirm();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => true,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 16),
          backgroundColor: const Color(ListColor.neutral100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
          ),
          // child: Padding(
          //   padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - GlobalVariable.ratioWidth(context) * 32,
            child: Padding(
              padding: EdgeInsets.only(
                top: GlobalVariable.ratioWidth(context) * 16,
                right: GlobalVariable.ratioWidth(context) * 12,
                left: GlobalVariable.ratioWidth(context) * 12,
                bottom: GlobalVariable.ratioWidth(context) * 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: GlobalVariable.ratioWidth(context) * 8),
                      child: SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 60,
                        height: GlobalVariable.ratioWidth(context) * 60,
                        child: const CircularProgressIndicator(
                          color: Color(ListColor.infoMain),
                          backgroundColor: Color(ListColor.infoSurface),
                          strokeWidth: 5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: GlobalVariable.ratioWidth(context) * 8),
                      child: pWidgetDownload,
                    ),
                    showNotes
                        ? Padding(
                            padding: EdgeInsets.only(bottom: GlobalVariable.ratioWidth(context) * 8),
                            child: CustomText(
                              "Jika unduh data terasa lama, lakukan hal berikut ini:",
                              fontSize: Listfontsize.px14,
                              fontWeight: FontWeight.bold,
                              color: const Color(ListColor.neutral10),
                            ),
                          )
                        : Container(),
                    showNotes
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - GlobalVariable.ratioWidth(context) * 56,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "1. Pastikan titik loading masih berjalan, meski pergerakan lambat.",
                                  fontSize: Listfontsize.px14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(ListColor.neutral10),
                                ),
                                CustomText(
                                  "2. Jika tidak berjalan, cari sinyal yang lebih kuat.",
                                  fontSize: Listfontsize.px14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(ListColor.neutral10),
                                ),
                                CustomText(
                                  "3. Jika tidak berjalan, keluar dan masuk kembali ke aplikasi.",
                                  fontSize: Listfontsize.px14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(ListColor.neutral10),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: "4. Jika tidak berjalan, hubungi developer apps ",
                                    style: TextStyle(
                                      fontSize: GlobalVariable.ratioFontSize(context) * 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      // TextSpan(
                                      //   text: "(WA: 08888888888).",
                                      //   style: TextStyle(
                                      //     fontSize: GlobalVariable.ratioFontSize(context) * 14,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Color(ListColor.successMain),
                                      //     decoration: TextDecoration.underline,
                                      //     decorationColor: Color(ListColor.successMain),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }

  static void customAlertPopUp({
    required BuildContext context,
    required Widget pInformation,
    bool? dismissible,
  }) {
    showDialog(
      barrierDismissible: dismissible ?? true,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => dismissible ?? true,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 16, horizontal: GlobalVariable.ratioWidth(context) * 12),
            child: Container(
              color: const Color(ListColor.neutral10),
              width: double.infinity,
              child: pInformation,
            ),
          ),
        ),
      ),
    );
  }

  static void customSuccessPopUp({
    required BuildContext context,
    required Widget pInformation,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
            color: const Color(ListColor.neutral10),
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 16, horizontal: GlobalVariable.ratioWidth(context) * 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/success.png',
                  width: GlobalVariable.ratioWidth(context) * 80,
                  height: GlobalVariable.ratioWidth(context) * 80,
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 16,
                ),
                pInformation
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void customToast({
    required String pInfo,
    ToastGravity? pPosition = ToastGravity.TOP,
    Toast pLength = Toast.LENGTH_SHORT,
    Color pBackgroundColor = const Color(ListColor.infoMain),
    Color pTextColor = Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: pInfo,
      gravity: pPosition,
      toastLength: pLength,
      backgroundColor: pBackgroundColor,
      textColor: pTextColor,
      fontSize: Listfontsize.px14,
    );
  }

  static void customLoadingPopUp({
    required BuildContext context,
    Color pMainColor = const Color(ListColor.infoMain),
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: CircularProgressIndicator(
              color: pMainColor,
              backgroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }

  static void customPopUpPelangganBaru({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 16, horizontal: GlobalVariable.ratioWidth(context) * 12),
          child: Container(
            color: const Color(ListColor.neutral10),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  "Sebelum Menambah Pelanggan Baru",
                  fontSize: Listfontsize.px14,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        "1. Reset GPS terlebih dahulu",
                        fontSize: Listfontsize.px14,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                        color: const Color(ListColor.dangerMain),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        "2. Pastikan internet HP lancar",
                        fontSize: Listfontsize.px14,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                        color: const Color(ListColor.dangerMain),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 16,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Expanded(
                    child: Container(
                      height: GlobalVariable.ratioWidth(context) * 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 12),
                        color: const Color(ListColor.infoMain),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Icon.svg",
                            fit: BoxFit.scaleDown,
                            height: GlobalVariable.ratioWidth(context) * 18,
                            colorFilter: const ColorFilter.mode(Color(ListColor.neutral10), BlendMode.srcIn),
                          ),
                          Container(
                            width: GlobalVariable.ratioWidth(context) * 10,
                          ),
                          CustomText(
                            "Saya Mengerti",
                            fontWeight: FontWeight.bold,
                            fontSize: Listfontsize.px14,
                            color: const Color(ListColor.neutral10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void customPopUpOpsi({
    required BuildContext context,
    required Widget pInformation,
    required String pLeftButtonText,
    required String pRightButtonText,
    required void Function() pOnLeftButtonClick,
    required void Function() pOnRightButtonClick,
    bool? dismissible,
  }) {
    showDialog(
      barrierDismissible: dismissible ?? false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => dismissible ?? false,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 16),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
            // ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(ListColor.neutral10),
                borderRadius: BorderRadius.circular(
                  GlobalVariable.ratioWidth(context) * 8,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: GlobalVariable.ratioWidth(context) * 16,
                  horizontal: GlobalVariable.ratioWidth(context) * 12,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      pInformation,
                      SizedBox(
                        height: GlobalVariable.ratioWidth(context) * 16,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: GlobalVariable.ratioWidth(context) * 52,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 12),
                                  ),
                                  backgroundColor: const Color(ListColor.infoMain),
                                ),
                                onPressed: pOnLeftButtonClick,
                                child: CustomText(
                                  pLeftButtonText,
                                  color: const Color(ListColor.neutral10),
                                  fontWeight: FontWeight.w700,
                                  fontSize: Listfontsize.px14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: GlobalVariable.ratioWidth(context) * 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: GlobalVariable.ratioWidth(context) * 52,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 12),
                                  ),
                                  side: BorderSide(
                                    color: const Color(ListColor.infoBorder),
                                    width: GlobalVariable.ratioWidth(context) * 1,
                                    style: BorderStyle.solid,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: pOnRightButtonClick,
                                child: CustomText(
                                  pRightButtonText,
                                  color: const Color(ListColor.infoMain),
                                  fontWeight: FontWeight.w700,
                                  fontSize: Listfontsize.px14,
                                ),
                                // child: Text(
                                //   pRightButtonText,
                                //   style: const TextStyle(
                                //     color: Colors.blueAccent,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> customPopupOpsiWithResult({
    required BuildContext context,
    required Widget pInformation,
    required String pLeftButtonText,
    required String pRightButtonText,
    required void Function() pOnLeftButtonClick,
    required void Function() pOnRightButtonClick,
    bool? dismissible,
  }) async {
    bool result = await showDialog(
      barrierDismissible: dismissible ?? false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => dismissible ?? false,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 16),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
            // ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(ListColor.neutral10),
                borderRadius: BorderRadius.circular(
                  GlobalVariable.ratioWidth(context) * 8,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: GlobalVariable.ratioWidth(context) * 16,
                  horizontal: GlobalVariable.ratioWidth(context) * 12,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      pInformation,
                      SizedBox(
                        height: GlobalVariable.ratioWidth(context) * 16,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: GlobalVariable.ratioWidth(context) * 52,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 12),
                                  ),
                                  backgroundColor: const Color(ListColor.infoMain),
                                ),
                                onPressed: pOnLeftButtonClick,
                                child: CustomText(
                                  pLeftButtonText,
                                  color: const Color(ListColor.neutral10),
                                  fontWeight: FontWeight.w700,
                                  fontSize: Listfontsize.px14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: GlobalVariable.ratioWidth(context) * 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: GlobalVariable.ratioWidth(context) * 52,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 12),
                                  ),
                                  side: BorderSide(
                                    color: Colors.blueAccent,
                                    width: GlobalVariable.ratioWidth(context) * 1,
                                    style: BorderStyle.solid,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: pOnRightButtonClick,
                                child: CustomText(
                                  pRightButtonText,
                                  color: const Color(ListColor.infoMain),
                                  fontWeight: FontWeight.w700,
                                  fontSize: Listfontsize.px14,
                                ),
                                // child: Text(
                                //   pRightButtonText,
                                //   style: const TextStyle(
                                //     color: Colors.blueAccent,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    return result;
  }

  static void resetDBPopUp({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
          ),
          child: Padding(
            padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "Reset Data Berhasil",
                  fontSize: ListFontHeight.h5,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: GlobalVariable.ratioWidth(context) * 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 4, horizontal: GlobalVariable.ratioWidth(context) * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(ListColor.infoMain),
                        size: GlobalVariable.ratioWidth(context) * 14,
                      ),
                      SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 10,
                      ),
                      CustomText(
                        "Customer",
                        fontSize: ListFontHeight.px14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 4, horizontal: GlobalVariable.ratioWidth(context) * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(ListColor.infoMain),
                        size: GlobalVariable.ratioWidth(context) * 14,
                      ),
                      SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 10,
                      ),
                      CustomText(
                        "Customer Dalam Rute",
                        fontSize: ListFontHeight.px14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 4, horizontal: GlobalVariable.ratioWidth(context) * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(ListColor.infoMain),
                        size: GlobalVariable.ratioWidth(context) * 14,
                      ),
                      SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 10,
                      ),
                      CustomText(
                        "Customer Luar Rute",
                        fontSize: ListFontHeight.px14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 4, horizontal: GlobalVariable.ratioWidth(context) * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(ListColor.infoMain),
                        size: GlobalVariable.ratioWidth(context) * 14,
                      ),
                      SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 10,
                      ),
                      CustomText(
                        "Supplier",
                        fontSize: ListFontHeight.px14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 4, horizontal: GlobalVariable.ratioWidth(context) * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(ListColor.infoMain),
                        size: GlobalVariable.ratioWidth(context) * 14,
                      ),
                      SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 10,
                      ),
                      CustomText(
                        "Customer Supplier",
                        fontSize: ListFontHeight.px14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 4, horizontal: GlobalVariable.ratioWidth(context) * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(ListColor.infoMain),
                        size: GlobalVariable.ratioWidth(context) * 14,
                      ),
                      SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 10,
                      ),
                      CustomText(
                        "Salesman Supplier Divisi",
                        fontSize: ListFontHeight.px14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 4, horizontal: GlobalVariable.ratioWidth(context) * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(ListColor.infoMain),
                        size: GlobalVariable.ratioWidth(context) * 14,
                      ),
                      SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 10,
                      ),
                      CustomText(
                        "Barang",
                        fontSize: ListFontHeight.px14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 4, horizontal: GlobalVariable.ratioWidth(context) * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(ListColor.infoMain),
                        size: GlobalVariable.ratioWidth(context) * 14,
                      ),
                      SizedBox(
                        width: GlobalVariable.ratioWidth(context) * 10,
                      ),
                      CustomText(
                        "Valid AO",
                        fontSize: ListFontHeight.px14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

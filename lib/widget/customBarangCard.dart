import 'dart:developer';

import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class customBarangcard extends StatefulWidget {
  final String pKodeBarang;
  final String pNamaBarang;
  final String pHargaJualBesar;
  final String pHargaJualSedang;
  final String pHargaJualKecil;
  final String pStokBarangBesar;
  final String pStokBarangSedang;
  final String pStokBarangKecil;
  final String pSatuanBesar;
  final String pSatuanSedang;
  final String pSatuanKecil;
  final String pRataSatBesar;
  final String pRataSatSedang;
  final String pRataSatKecil;
  final String pTglPengambilanTerakhir;
  final String pJumlahPengambilanTerakhir;
  final String pPotensiPromo;
  final String pUrlGambar;
  final Rx<TextEditingController> stokKontroller;
  Function(String, String) onJumlahSelesai;
  final String pStok;
  final String pSatuanMinimumOrder;
  final String pJmlKelipatanOrder;
  final String pKonversi1;
  final String pKonversi2;
  final Rx<String> pSubtotal;

  customBarangcard({
    Key? key,
    required this.pKodeBarang,
    required this.pNamaBarang,
    required this.pHargaJualBesar,
    required this.pHargaJualSedang,
    required this.pHargaJualKecil,
    required this.pStokBarangBesar,
    required this.pStokBarangSedang,
    required this.pStokBarangKecil,
    required this.pSatuanBesar,
    required this.pSatuanSedang,
    required this.pSatuanKecil,
    required this.pRataSatBesar,
    required this.pRataSatSedang,
    required this.pRataSatKecil,
    required this.pTglPengambilanTerakhir,
    required this.pJumlahPengambilanTerakhir,
    required this.pPotensiPromo,
    required this.pUrlGambar,
    required this.onJumlahSelesai,
    required this.stokKontroller,
    required this.pStok,
    required this.pSatuanMinimumOrder,
    required this.pJmlKelipatanOrder,
    required this.pKonversi1,
    required this.pKonversi2,
    required this.pSubtotal,
  });

  @override
  State<customBarangcard> createState() => _customBarangcardState();
}

class _customBarangcardState extends State<customBarangcard> {
  FocusNode _focusNode = FocusNode();
  String jenisSatuan = 'kecil';
  Rx<int> subtotal = 0.obs;
  String getSatuan(String input) {
    input = input.trim();
    if (input.isEmpty) {
      return widget.pSatuanKecil;
    }

    if (input.contains('.')) {
      var parts = input.split('.');
      var beforeDecimal = parts[0];
      var afterDecimal = parts.length > 1 ? parts[1] : '';

      if (beforeDecimal.length == 2 && afterDecimal.isNotEmpty) {
        jenisSatuan = 'kecil';
        return widget.pSatuanKecil;
      } else if (beforeDecimal.length == 1 && afterDecimal.isNotEmpty) {
        jenisSatuan = 'sedang';
        return widget.pSatuanSedang;
      }
    } else {
      jenisSatuan = 'besar';
      return widget.pSatuanBesar;
    }
    jenisSatuan = 'kecil';
    return widget.pSatuanKecil;
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    subtotal.value = int.parse(widget.pSubtotal.value);
    return Stack(
      children: [
        Container(
          decoration: getBoxDecoration(),
          child: Padding(
            padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: widget.pPotensiPromo == "1"
                        ? GlobalVariable.ratioWidth(context) * 30
                        : 0,
                  ),
                  child: CustomText(
                    "${widget.pKodeBarang} - ${widget.pNamaBarang}",
                    fontSize: Listfontsize.h5,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 4,
                ),
                CustomText(
                  "Harga jual : Rp${NumberFormat('#,###').format(int.parse(widget.pHargaJualBesar.split(".")[0]))} / Rp${NumberFormat('#,###').format(int.parse(widget.pHargaJualSedang.split(".")[0]))} / Rp${NumberFormat('#,###').format(int.parse(widget.pHargaJualKecil.split(".")[0]))}",
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: GlobalVariable.ratioFontSize(context) * 4,
                ),
                CustomText(
                  "Stok Barang : ${widget.pStokBarangBesar} ${widget.pSatuanBesar} / ${widget.pStokBarangSedang} ${widget.pSatuanSedang} / ${widget.pStokBarangKecil} ${widget.pSatuanKecil}",
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 4,
                ),
                CustomText(
                  "Average Pengambilan : ${widget.pRataSatBesar} ${widget.pSatuanBesar} / ${widget.pRataSatSedang} ${widget.pSatuanSedang} / ${widget.pRataSatKecil} ${widget.pSatuanKecil}",
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 4,
                ),
                CustomText(
                  "Tgl Pengambilan Terakhir : ${widget.pTglPengambilanTerakhir.isEmpty ? "-" : widget.pTglPengambilanTerakhir}",
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 4,
                ),
                CustomText(
                  "Jml Pengambilan Terakhir : ${widget.pJumlahPengambilanTerakhir.isEmpty ? "0" : widget.pJumlahPengambilanTerakhir} PCS",
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 4,
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          context: context,
                          controller: widget.stokKontroller.value,
                          focusNode: _focusNode,
                          newInputDecoration: const InputDecoration(
                            hintText: "Isi Jumlah",
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () {
                            _focusNode.unfocus();
                          },
                        ),
                      ),
                      // child: TextFormFieldWidget(
                      //   textEditingController: widget.stokKontroller.value,
                      //   hintText: "Isi Jumlah",
                      //   isCustomTitle: true,
                      //   titlewidget: Container(),
                      // ),

                      Container(
                        width: GlobalVariable.ratioWidth(context) * 4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: GlobalVariable.ratioWidth(context) * 14),
                        child: Obx(
                          () => CustomText(
                            getSatuan(widget.stokKontroller.value.text),
                            fontSize: Listfontsize.h5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: GlobalVariable.ratioWidth(context) * 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          getSatuan(widget.stokKontroller.value.text);
                          widget.onJumlahSelesai(
                              widget.pKodeBarang, jenisSatuan);
                          widget.stokKontroller.refresh();
                          _focusNode.unfocus();
                          bool isValid = cekQty(
                            qtyFormat: widget.stokKontroller.value.text,
                            qtyFormatSebelumnya: "",
                            satuanbesar: widget.pSatuanBesar,
                            satuansedang: widget.pSatuanSedang,
                            satuankecil: widget.pSatuanKecil,
                            hargabesar: widget.pHargaJualBesar,
                            hargasedang: widget.pHargaJualSedang,
                            hargakecil: widget.pHargaJualKecil,
                            stok: widget.pStok,
                            konversi1: widget.pKonversi1,
                            konversi2: widget.pKonversi2,
                            context: context,
                            namabarang: widget.pNamaBarang,
                            satuanminimumorder: widget.pSatuanMinimumOrder,
                            jmlkelipatanorder: widget.pJmlKelipatanOrder,
                          );
                          widget.pSubtotal.refresh();

                          log("isvalid : $isValid");
                          log("isvalid : ${widget.pJmlKelipatanOrder}");
                          log("isvalid : ${jenisSatuan}");
                          if (isValid) {
                            if (jenisSatuan == 'kecil') {
                              subtotal.value = int.parse(widget
                                      .stokKontroller.value.text
                                      .split(".")[1]) *
                                  int.parse(
                                      widget.pHargaJualKecil.split(".")[0]);
                            } else if (jenisSatuan == 'sedang') {
                              subtotal.value = int.parse(widget
                                      .stokKontroller.value.text
                                      .split(".")[1]) *
                                  int.parse(
                                      widget.pHargaJualSedang.split(".")[0]);
                            } else {
                              subtotal.value =
                                  int.parse(widget.stokKontroller.value.text) *
                                      int.parse(
                                          widget.pHargaJualBesar.split(".")[0]);
                            }
                            subtotal.refresh();
                          }
                        },
                        child: Image.asset(
                          "assets/images/simpan.png",
                          height: GlobalVariable.ratioWidth(context) * 48,
                          width: GlobalVariable.ratioWidth(context) * 48,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 4,
                ),
                Obx(
                  () => CustomText(
                    "Rp${NumberFormat('#,###').format(subtotal.value)}",
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height: GlobalVariable.ratioWidth(context) * 4,
                ),
                GestureDetector(
                  onTap: () {
                    CustomWidget.customAlertPopUp(
                      context: context,
                      pInformation: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            widget.pNamaBarang,
                            fontSize: Listfontsize.h5,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            height: GlobalVariable.ratioWidth(context) * 16,
                          ),
                          Container(
                            height: GlobalVariable.ratioWidth(context) * 300,
                            child: Image.network(
                              widget.pUrlGambar,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return CustomText(
                                  "Gagal Load Gambar Barang",
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: CustomText(
                    "Lihat Gambar",
                    textAlign: TextAlign.left,
                    decoration: TextDecoration.underline,
                    color: const Color(ListColor.infoMain),
                    decorationColor: const Color(ListColor.infoMain),
                  ),
                )
              ],
            ),
          ),
        ),
        if (widget.pPotensiPromo == "1")
          Positioned(
            top: GlobalVariable.ratioWidth(context) * 0,
            right: GlobalVariable.ratioFontSize(context) * 0,
            child: Image.asset(
              "assets/images/promo.png",
              width: GlobalVariable.ratioWidth(context) * 30,
              height: GlobalVariable.ratioWidth(context) * 30,
            ),
          ),
      ],
    );
  }

  BoxDecoration getBoxDecoration() {
    if (widget.pStokBarangBesar == "0" &&
        widget.pStokBarangSedang == "0" &&
        widget.pStokBarangKecil == "0") {
      return BoxDecoration(
        borderRadius:
            BorderRadius.circular(GlobalVariable.ratioWidth(context) * 10),
        border: Border.all(
          width: GlobalVariable.ratioWidth(context) * 1,
          color: const Color(ListColor.warningMain),
        ),
        color: const Color(ListColor.warningBorder),
      );
    } else {
      return BoxDecoration(
        borderRadius:
            BorderRadius.circular(GlobalVariable.ratioWidth(context) * 10),
        color: const Color(ListColor.infoSurface),
      );
    }
  }

  bool cekQty({
    required String qtyFormat,
    required String qtyFormatSebelumnya,
    required String satuanbesar,
    required String satuansedang,
    required String satuankecil,
    required String hargabesar,
    required String hargasedang,
    required String hargakecil,
    required String stok,
    required String konversi1,
    required String konversi2,
    required BuildContext context,
    required String namabarang,
    required String satuanminimumorder,
    required String jmlkelipatanorder,
  }) {
    // try {
    if (qtyFormat.isEmpty ||
        qtyFormat[0] == '-' ||
        qtyFormat[0] == '.' ||
        qtyFormat[0] == ',') {
      return false;
    }

    var qtysplit = qtyFormat.split(".");
    String qty = "";
    String qtykecil = "";
    String satuan = "";
    String harga = "";

    if (qtysplit.length == 1) {
      qty = qtyFormat;
      qtykecil = qtyFormat;
    } else {
      qty = qtysplit[0];
      qtykecil = qtysplit[1];
    }

    if (qtykecil.length > 2) {
      qtykecil = qtykecil.substring(0, 2);
    }

    if (satuanminimumorder.isNotEmpty) {
      if (jenisSatuan == 'kecil') {
        if (satuanminimumorder != satuankecil) {
          return false;
        }
      } else if (jenisSatuan == 'sedang') {
        if (satuanminimumorder != satuansedang) {
          return false;
        }
      } else {
        if (satuanminimumorder != satuanbesar) {
          return false;
        }
      }
    }
    if (qty.length > 2) {
      return false;
    }
    var stokInt = int.parse(stok);
    var stokBesar = stokInt ~/
        (int.parse(konversi2.split(".")[0]) *
            int.parse(konversi1.split(".")[0]));
    var stokSedang = (stokInt %
            (int.parse(konversi2.split(".")[0]) *
                int.parse(konversi1.split(".")[0]))) ~/
        int.parse(konversi2.split(".")[0]);
    var stokKecil = stokInt % int.parse(konversi2.split(".")[0]);

    if (stokInt <= 0 || int.parse(qty) > stokInt) {
      return false;
    }

    if (jmlkelipatanorder.isNotEmpty) {
      log("jml kelipatan : $jmlkelipatanorder");

      if (jmlkelipatanorder.split(".")[0] != "0") {
        if (int.parse(qty) % int.parse(jmlkelipatanorder.split(".")[0]) != 0) {
          return false;
        }
      }
    }

    return true;
    // } catch (e) {
    //   log("Error in cekQty function: $e");
    //   return false; // Jika ada error, dianggap invalid
    // }
  }
}

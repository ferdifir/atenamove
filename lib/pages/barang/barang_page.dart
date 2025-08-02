import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/barang/barang_controller.dart';
import 'package:atenamove/widget/customDetailOrderPrincipleCard.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BarangPage extends GetView<BarangController> {
  const BarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultBg(
      title: controller.xCustomer.value.namacustomer,
      onBackPress: () => Get.back(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 10),
              color: const Color(ListColor.infoBorder),
              border: Border.all(
                color: const Color(ListColor.infoMain),
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 12),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Sub Total",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        CustomText(
                          controller.xTransaksi.value.total ?? '',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Container(
                      height: GlobalVariable.ratioWidth(context) * 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Total Disc",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        CustomText(
                          controller.xTransaksi.value.discrp ?? '',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Container(
                      height: GlobalVariable.ratioWidth(context) * 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Total TPR",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        CustomText(
                          controller.xTransaksi.value.tprrp ?? '',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Container(
                      height: GlobalVariable.ratioWidth(context) * 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Grand Total",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: Listfontsize.h5,
                        ),
                        CustomText(
                          controller.xTransaksi.value.grandtotal ?? '',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: Listfontsize.h5,
                        ),
                      ],
                    ),
                    Container(
                      height: GlobalVariable.ratioWidth(context) * 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          CustomText(
            controller.xTransaksi.value.kodetrans ?? '',
            fontSize: Listfontsize.h3,
            fontWeight: FontWeight.w600,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: controller.xBarang.length,
              itemBuilder: (context, index) {
                final data = controller.xBarang[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: CustomDetailOrderPrincipleCard(
                    pNamaBarang: data.namabarang ?? '',
                    pJenisSatuan: data.satuan ?? '',
                    pJumlahBarang: data.jml ?? '0',
                    pHargaBarang: data.harga ?? '0',
                    pSubTotal: data.subtotal ?? '0',
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: GlobalVariable.ratioWidth(context) * 5),
                    child: GestureDetector(
                      onTap: () async {
                        CustomWidget.customPopUpOpsi(
                          context: context,
                          pInformation: CustomText(
                            "Apakah anda yakin Barang Sudah Sesuai Pesanan?",
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          pLeftButtonText: "Ya",
                          pRightButtonText: "Tidak",
                          pOnLeftButtonClick: () async {
                            Get.back();
                            CustomWidget.customLoadingPopUp(context: Get.context!);
                            await controller.setBarangData(controller.xTransaksi.value.idtrans ?? '');
                            Get.back();
                            Get.back();
                          },
                          pOnRightButtonClick: () {
                            Get.back();
                          },
                        );
                      },
                      child: Container(
                        height: GlobalVariable.ratioWidth(context) * 52,
                        decoration: BoxDecoration(
                          color: const Color(ListColor.successMain),
                          borderRadius: BorderRadius.all(
                            Radius.circular(GlobalVariable.ratioWidth(context) * 10),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/check-circle.svg"),
                              Container(
                                width: GlobalVariable.ratioWidth(context) * 4,
                              ),
                              CustomText(
                                "Sesuai",
                                color: const Color(ListColor.neutral10),
                                fontWeight: FontWeight.bold,
                                fontSize: Listfontsize.px14,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: GlobalVariable.ratioWidth(context) * 5),
                    child: GestureDetector(
                      onTap: () async {
                        final ctrl = TextEditingController();
                        final formKey = GlobalKey<FormState>();
                        CustomWidget.customPopUpOpsi(
                          context: context,
                          pInformation: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                CustomText(
                                  "Beri Alasan Kirim Tidak Sesuai Pesanan",
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  height: GlobalVariable.ratioWidth(context) * 8,
                                ),
                                TextFormField(
                                  maxLines: 3,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: ctrl,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Alasan tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Contoh: Barang Rusak",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black, width: 1.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pLeftButtonText: "Simpan",
                          pRightButtonText: "Batal",
                          pOnLeftButtonClick: () async {
                            if (!formKey.currentState!.validate()) return;
                            Get.back();
                            CustomWidget.customLoadingPopUp(context: Get.context!);
                            await controller.setBarangData(
                              controller.xTransaksi.value.idtrans ?? '',
                              alasan: ctrl.text.toUpperCase(),
                            );
                            Get.back();
                            Get.back();
                          },
                          pOnRightButtonClick: () {
                            Get.back();
                          },
                        );
                      },
                      child: Container(
                        height: GlobalVariable.ratioWidth(context) * 52,
                        decoration: BoxDecoration(
                          color: const Color(ListColor.dangerMain),
                          borderRadius: BorderRadius.all(
                            Radius.circular(GlobalVariable.ratioWidth(context) * 10),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/multiply.svg"),
                              Container(
                                width: GlobalVariable.ratioWidth(context) * 4,
                              ),
                              CustomText(
                                "Tidak Sesuai",
                                color: const Color(ListColor.neutral10),
                                fontWeight: FontWeight.bold,
                                fontSize: Listfontsize.px14,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

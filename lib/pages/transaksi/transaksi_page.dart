import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/transaksi/transaksi_controller.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/widget/customCustomerCard.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TransaksiPage extends GetView<TransaksiController> {
  const TransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultBg(
        onBackPress: () => Get.back(),
        title: "Daftar Transaksi\n\n${controller.xNamaSopir.value}",
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 3),
              child: CustomTextField(
                context: context,
                onChanged: controller.searchTransaksi,
                controller: controller.xSearchTextField.value,
                newInputDecoration: InputDecoration(
                  hintText: "Cari Armada",
                  prefixIcon: SvgPicture.asset(
                    'assets/icons/Vector.svg',
                    height: GlobalVariable.ratioWidth(context) * 24,
                    width: GlobalVariable.ratioWidth(context) * 24,
                    fit: BoxFit.scaleDown,
                    colorFilter: const ColorFilter.mode(
                      Color(ListColor.infoMain),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  itemCount: controller.xListTransaksi.length,
                  itemBuilder: (context, index) {
                    final data = controller.xListTransaksi[index];
                    return customCustomerCard(
                      pKodeCustomer: data.kodetrans ?? "",
                      pNamaCustomer: data.jenistrans ?? "",
                      pAlamatCustomer: "Pelanggan : ${controller.customer.namacustomer}",
                      pStatusKunjungan: "Tgl Trans : ${data.tgltrans ?? ""}",
                      pOmzetCustomer: "Rp${GlobalVariable.formatCurrencyDecimal(data.grandtotalraw ?? '0')}",
                      isTransaksi: true,
                      pCatatanKunjungan: data.catatan ?? "",
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.BARANG,
                          arguments: {
                            "transaksi": data,
                            "customer": controller.customer,
                          },
                        )!
                            .then((value) => controller.getListTransaksi());
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: GlobalVariable.ratioWidth(context) * 5),
              child: GestureDetector(
                onTap: () async {
                  // mengecek apakah ada catatan transaksi yang masih belum ditentukan
                  // apakah sudah sesuai atau tidak sesuai
                  bool isComplete = controller.xListTransaksi.every((e) => (e.catatan ?? "").isNotEmpty);
                  if (isComplete) {
                    CustomWidget.customPopUpOpsi(
                      context: context,
                      pInformation: CustomText(
                        "Apakah Anda Yakin Sudah Melihat Semua Transaksi ?",
                        fontWeight: FontWeight.bold,
                        fontSize: Listfontsize.px14,
                        textAlign: TextAlign.center,
                      ),
                      pLeftButtonText: "Ya",
                      pRightButtonText: "Tidak",
                      pOnLeftButtonClick: () {
                        Get.offAllNamed(AppRoutes.DASHBOARD);
                      },
                      pOnRightButtonClick: () {
                        Get.back();
                      },
                    );
                  } else {
                    CustomWidget.customAlertPopUp(
                      context: context,
                      pInformation: CustomText(
                        "Terdapat Transaksi Yang Belum Diperiksa",
                        fontWeight: FontWeight.bold,
                        fontSize: Listfontsize.px14,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                },
                child: Container(
                  height: GlobalVariable.ratioWidth(context) * 52,
                  decoration: BoxDecoration(
                    color: const Color(ListColor.infoMain),
                    borderRadius: BorderRadius.all(
                      Radius.circular(GlobalVariable.ratioWidth(context) * 10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/checked.svg"),
                        Container(
                          width: GlobalVariable.ratioWidth(context) * 4,
                        ),
                        CustomText(
                          "Selesai",
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
          ],
        ),
      );
    });
  }
}

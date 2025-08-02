import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/model/sopirModel.dart';
import 'package:atenamove/pages/verifikasi/verifikasi_controller.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class VerifikasiPage extends GetView<VerifikasiController> {
  const VerifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultBg(
      title: "Verifikasi",
      onBackPress: Get.back,
      child: Column(
        children: [
          CustomTextField(
            context: context,
            onChanged: controller.searchSopir,
            newInputDecoration: InputDecoration(
              hintText: "Cari Sopir/Helper",
              hintStyle: TextStyle(
                fontSize: GlobalVariable.ratioFontSize(context) * 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff9AA5B1),
              ),
              prefixIcon: SvgPicture.asset(
                'assets/icons/Vector.svg',
                height: GlobalVariable.ratioWidth(context) * 24,
                width: GlobalVariable.ratioWidth(context) * 24,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          // GestureDetector(
          //   onTap: () async {
          //     await controller.selectDate();
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       SvgPicture.asset(
          //         "assets/icons/calendar.svg",
          //         height: GlobalVariable.ratioWidth(context) * 14,
          //         width: GlobalVariable.ratioWidth(context) * 14,
          //         fit: BoxFit.scaleDown,
          //       ),
          //       Container(
          //         width: GlobalVariable.ratioWidth(context) * 2,
          //       ),
          //       CustomText(
          //         controller.xSelectedDate.value,
          //         fontWeight: FontWeight.w600,
          //       )
          //     ],
          //   ),
          // ),
          // Container(
          //   height: GlobalVariable.ratioWidth(context) * 10,
          // ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.xDataSopir.length,
                  itemBuilder: (context, index) {
                    final data = controller.xDataSopir[index];
                    return customSalesmanCard(
                      context,
                      pNamaSalesman: data.namapegawai ?? '-',
                      pVersiApp: data.versiapp ?? '-',
                      pLastCheckIn: data.tglentry ?? '-',
                      pCatatan: data.catatan ?? '-',
                      pIdPegawai: data.idpegawai ?? '-',
                    );
                  },
                )),
          )
        ],
      ),
    );
  }

  void confirmVerifikasi(BuildContext context, {required String pIdPegawai, required String pNamaPegawai}) {
    final ctrl = TextEditingController();
    CustomWidget.customPopUpOpsi(
      context: context,
      pInformation: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText("Apakah anda yakin akan memilih Sopir / Helper ini ?"),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          CustomText(
            pNamaPegawai,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          ),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          CustomTextField(
            context: context,
            controller: ctrl,
            maxLines: 3,
            newInputDecoration: InputDecoration(
              hintText: "Contoh : Nama [Sopir/Helper]",
              hintStyle: TextStyle(
                fontSize: GlobalVariable.ratioFontSize(context) * 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff9AA5B1),
              ),
            ),
          ),
        ],
      ),
      pLeftButtonText: "Verifikasi",
      pRightButtonText: "Batal",
      pOnLeftButtonClick: () {
        Get.back();
        controller.processVerifikasi(
          idUser2: pIdPegawai,
          catatan: ctrl.text,
        );
      },
      pOnRightButtonClick: () {
        Get.back();
      },
    );
  }

  Widget customSalesmanCard(
    BuildContext context, {
    required String pNamaSalesman,
    required String pVersiApp,
    required String pLastCheckIn,
    required String pCatatan,
    required String pIdPegawai,
  }) {
    return GestureDetector(
      onTap: () => confirmVerifikasi(
        context,
        pNamaPegawai: pNamaSalesman,
        pIdPegawai: pIdPegawai,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(GlobalVariable.ratioWidth(Get.context!) * 10),
          ),
        ),
        color: const Color(ListColor.infoSurface),
        child: Padding(
          padding: EdgeInsets.all(GlobalVariable.ratioWidth(Get.context!) * 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      pNamaSalesman,
                      fontWeight: FontWeight.bold,
                      fontSize: Listfontsize.h5,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    CustomText(
                      "Versi APP : $pVersiApp",
                      fontSize: Listfontsize.px14,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.left,
                    ),
                    CustomText(
                      "Tanggal Entry : $pLastCheckIn",
                      fontSize: Listfontsize.px14,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.left,
                    ),
                    CustomText(
                      "Catatan : $pCatatan",
                      fontSize: Listfontsize.px14,
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

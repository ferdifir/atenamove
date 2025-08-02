import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/batalverifikasi/batalverifikasi_controller.dart';
import 'package:atenamove/widget/customCardDepo.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BatalVerifikasiPage extends GetView<BatalVerifikasiController> {
  const BatalVerifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultBg(
      title: 'Batal Verifikasi\n\n   ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
      onBackPress: () => Get.back(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 3),
            child: CustomTextField(
              context: context,
              onChanged: controller.searchArmada,
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
                itemCount: controller.xListArmada.length,
                itemBuilder: (context, index) {
                  final data = controller.xListArmada[index];
                  return CustomCardDepo(
                    name: data.namaarmada ?? "",
                    id: "Armada : ${data.nopolisi}",
                    status: data.statusverifikasi ?? "",
                    onClick: () {
                      CustomWidget.customPopUpOpsi(
                        context: context,
                        pInformation: Text.rich(
                          TextSpan(
                            text: "Apakah anda yakin akan melakukan Batal Verifikasi untuk armada ",
                            style: TextStyle(
                              fontSize: GlobalVariable.ratioFontSize(context) * 14,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: data.nopolisi,
                                style: TextStyle(
                                  fontSize: GlobalVariable.ratioFontSize(context) * 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(ListColor.infoMain),
                                ),
                              ),
                              TextSpan(
                                text: " ?",
                                style: TextStyle(
                                  fontSize: GlobalVariable.ratioFontSize(context) * 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        pLeftButtonText: "Ya",
                        pRightButtonText: "Tidak",
                        pOnLeftButtonClick: () {
                          Get.back();
                          controller.selectBatalArmada(data);
                        },
                        pOnRightButtonClick: () => Get.back(),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

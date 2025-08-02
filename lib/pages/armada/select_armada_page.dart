import 'dart:ffi';

import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/armada/select_armada_controller.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/widget/customCardDepo.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';

class SelectArmadaPage extends GetView<SelectArmadaController> {
  const SelectArmadaPage({super.key});

  void showConfirmDialog(BuildContext context) {
    CustomWidget.customPopUpOpsi(
      context: context,
      pInformation: CustomText(
        "Apakah Anda Yakin Mau Keluar?",
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.center,
      ),
      pLeftButtonText: "Ya",
      pRightButtonText: "Tidak",
      pOnLeftButtonClick: () {
        Get.back();
        controller.resetArmadaLogin();
      },
      pOnRightButtonClick: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () async {
            showConfirmDialog(context);
            return false;
          },
          child: DefaultBg(
            title: "Pilih Armada",
            onBackPress: () {
              showConfirmDialog(context);
            },
            floatingActionButton: controller.xIsSPV.value
                ? Builder(builder: (context) {
                    return FloatingActionButton(
                      backgroundColor: const Color(ListColor.infoMain),
                      shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {
                        showPopover(
                          context: context,
                          bodyBuilder: (context) => const ListItems(),
                          onPop: () => print('Popover was popped!'),
                          direction: PopoverDirection.top,
                          width: 200,
                          height: 100,
                          arrowHeight: 30,
                          arrowWidth: 34.64,
                          radius: 10,
                          arrowDyOffset: -10,
                        );
                      },
                      child: const Icon(Icons.more_horiz),
                    );
                  })
                : const SizedBox(),
            floatingActionButtonLocation: controller.xIsSPV.value ? FloatingActionButtonLocation.centerFloat : null,
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
                            controller.selectArmada(
                              context,
                              data,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.RUTE_TAK_DIKUNJUNGI);
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: GlobalVariable.ratioWidth(context) * 30),
                SvgPicture.asset(
                  'assets/icons/car-slash-o.svg',
                ),
                const SizedBox(width: 5),
                CustomText("Tidak Dikunjungi"),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Divider(),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.BATAL_VERIFIKASI);
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: GlobalVariable.ratioWidth(context) * 30),
                SvgPicture.asset(
                  'assets/icons/shield-off-o.svg',
                ),
                const SizedBox(width: 5),
                CustomText("Batal Verifikasi"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

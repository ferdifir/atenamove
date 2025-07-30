import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/dashboard/dashboard_controller.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(ListColor.neutral20),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
            body: Obx(
          () => controller.xIsLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(ListColor.infoMain),
                    backgroundColor: Colors.white,
                  ),
                )
              : Stack(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 12),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: GlobalVariable.ratioWidth(context) * 12),
                                  child: Obx(
                                    () => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 10),
                                        color: const Color(ListColor.infoMain),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {},
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(right: GlobalVariable.ratioWidth(context) * 10),
                                                        child: Image.asset(
                                                          "assets/images/profile.png",
                                                          width: GlobalVariable.ratioWidth(context) * 30,
                                                          height: GlobalVariable.ratioWidth(context) * 30,
                                                        ),
                                                      ),
                                                      CustomText(
                                                        "HI, ${controller.username.value}",
                                                        fontSize: Listfontsize.h5,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    CustomWidget.customPopUpOpsi(
                                                      context: context,
                                                      pInformation: CustomText(
                                                        "Apakah Anda Yakin Mau Keluar?",
                                                        fontWeight: FontWeight.bold,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      pLeftButtonText: "Ya",
                                                      pRightButtonText: "Tidak",
                                                      pOnLeftButtonClick: () async {},
                                                      pOnRightButtonClick: () => Get.back(),
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/icons/exit.svg",
                                                    height: GlobalVariable.ratioWidth(context) * 18,
                                                    width: GlobalVariable.ratioWidth(context) * 17,
                                                    colorFilter: const ColorFilter.mode(
                                                      Color(ListColor.neutral10),
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(context) * 8),
                                              child: CustomText(
                                                controller.perusahaan.value.toString(),
                                                color: const Color(ListColor.neutral10),
                                                fontSize: Listfontsize.h5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.back(result: true);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(context) * 8),
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: "Armada : ",
                                                    style: const TextStyle(
                                                      fontSize: Listfontsize.px12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(ListColor.neutral10),
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: controller.depo.value,
                                                        style: TextStyle(
                                                          fontSize: GlobalVariable.ratioFontSize(context) * 12,
                                                        ),
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
                                ),
                                CustomTextField(
                                  context: context,
                                  onChanged: (value) => {},
                                  controller: controller.xSearch,
                                  newInputDecoration: InputDecoration(
                                    hintText: "Cari Nama Pelanggan",
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
                                      colorFilter: const ColorFilter.mode(
                                        Color(ListColor.infoMain),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: GlobalVariable.ratioWidth(context) * 60,
                                )
                                Obx(() => )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: GlobalVariable.ratioWidth(context) * 10,
                          left: GlobalVariable.ratioWidth(context) * 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(ListColor.infoBorder),
                              borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: GlobalVariable.ratioWidth(context) * 3,
                                  color: const Color(ListColor.neutral50),
                                ),
                              ],
                            ),
                            width: MediaQuery.sizeOf(context).width - GlobalVariable.ratioWidth(context) * 32,
                            // height: GlobalVariable.ratioWidth(context) * 32,
                            // child: Obx(
                            //   () => Padding(
                            //     padding: EdgeInsets.symmetric(
                            //       vertical: GlobalVariable.ratioWidth(context) * 10,
                            //       horizontal: GlobalVariable.ratioWidth(context) * 12,
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         CustomText(
                            //           "RO : ${controller.xListCustomerDalamRute.length ?? 0}",
                            //           fontWeight: FontWeight.w600,
                            //           fontSize: Listfontsize.px14,
                            //           color: Color(ListColor.neutral80),
                            //         ),
                            //         CustomText(
                            //           "AO : ${controller.xJumlahAO.value ?? 0}",
                            //           fontWeight: FontWeight.w600,
                            //           fontSize: Listfontsize.px14,
                            //           color: Color(ListColor.neutral80),
                            //         ),
                            //         CustomText(
                            //           "Call : ${controller.xJumlahCall.value ?? 0}",
                            //           fontWeight: FontWeight.w600,
                            //           fontSize: Listfontsize.px14,
                            //           color: Color(ListColor.neutral80),
                            //         ),
                            //         CustomText(
                            //           "Total : ${NumberFormat('#,###').format(controller.xJumlahOmzet.value ?? 0)}",
                            //           fontWeight: FontWeight.w600,
                            //           fontSize: Listfontsize.px14,
                            //           color: Color(ListColor.neutral80),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        )),
      ),
    );
  }
}

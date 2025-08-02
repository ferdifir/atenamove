// ignore_for_file: use_build_context_synchronously

import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/login/login_controller.dart';
import 'package:atenamove/theme/app_color.dart';
import 'package:atenamove/utils/assets.dart';
import 'package:atenamove/widget/customDropDown.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  void _showDBConfirmDialog(BuildContext context) {
    CustomWidget.customPopUpOpsi(
      context: context,
      pInformation: CustomText(
        "Apakah Anda Yakin Mau Reset Database?",
        fontWeight: FontWeight.bold,
        fontSize: Listfontsize.px14,
        textAlign: TextAlign.center,
      ),
      pLeftButtonText: "Ya",
      pRightButtonText: "Tidak",
      pOnLeftButtonClick: () async {
        await controller.deleteAllDatabases();
        await controller.xPref.clear();
        Get.back();
        if (!Get.context!.mounted) return;
        CustomWidget.customAlertPopUp(
          context: context,
          pInformation: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                "Reset Data Berhasil",
                fontSize: Listfontsize.h5,
                fontWeight: FontWeight.bold,
              ),
              Container(
                height: GlobalVariable.ratioWidth(context) * 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: GlobalVariable.ratioWidth(context) * 14,
                    width: GlobalVariable.ratioWidth(context) * 14,
                    child: SvgPicture.asset(
                      "assets/icons/check.svg",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Container(
                    width: GlobalVariable.ratioWidth(context) * 2,
                  ),
                  CustomText(
                    "Customer",
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
              Container(
                height: GlobalVariable.ratioWidth(context) * 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: GlobalVariable.ratioWidth(context) * 14,
                    width: GlobalVariable.ratioWidth(context) * 14,
                    child: SvgPicture.asset(
                      "assets/icons/check.svg",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Container(
                    width: GlobalVariable.ratioWidth(context) * 2,
                  ),
                  CustomText(
                    "Tagihan",
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ],
          ),
        );
      },
      pOnRightButtonClick: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(AppColor.surfaceColor),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: GlobalVariable.ratioWidth(context) * 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.logo,
                        width: 130,
                        height: 130,
                      ),
                      CustomText(
                        'Atena Move',
                        color: const Color(AppColor.primaryColor),
                        fontSize: Listfontsize.h3,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CustomDropDown(
                          listItem: controller.xListUrlPerusahaan,
                          title: "Perusahaan",
                          onSelected: (pValue) {
                            if (pValue.value != "") {
                              controller.xPref.setString("UrlAPI", pValue.value);
                              controller.selectedPerusahaan.value = pValue;
                              controller.selectedPerusahaan.refresh();
                              controller.getDataPerusahaan(context);
                              controller.xPerusahaanTextController.value.text = pValue.text;
                            }
                          },
                        ),
                        Container(
                          height: GlobalVariable.ratioWidth(context) * 10,
                        ),
                        TextFormFieldWidget(
                          isEmail: true,
                          textEditingController: controller.xUsernameTextController.value,
                          title: "Nama User",
                        ),
                        Container(
                          height: GlobalVariable.ratioWidth(context) * 10,
                        ),
                        TextFormFieldWidget(
                          textEditingController: controller.xPasswordTextController.value,
                          title: "Kata Sandi",
                          isPassword: true,
                          isShowPassword: controller.xIsShowPassword.value,
                          onClickShowButton: (value) {
                            controller.xIsShowPassword.value = value;
                          },
                        ),
                        Container(
                          height: GlobalVariable.ratioWidth(context) * 24,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.xUsernameTextController.value.text.isNotEmpty && controller.xPasswordTextController.value.text.isNotEmpty) {
                              controller.getLogin(
                                context: context,
                                pUsername: controller.xUsernameTextController.value.text,
                                pPassword: controller.xPasswordTextController.value.text,
                                pIsRelogin: false,
                              );
                            } else {
                              CustomWidget.customAlertPopUp(
                                context: context,
                                pInformation: CustomText(
                                  "Masih Terdapat Data yang belum Diisi",
                                  fontSize: Listfontsize.px14,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: GlobalVariable.ratioWidth(context) * 52,
                            alignment: Alignment.center,
                            width: MediaQuery.sizeOf(context).width - GlobalVariable.ratioWidth(context) * 32,
                            decoration: BoxDecoration(
                              color: const Color(ListColor.infoMain),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  GlobalVariable.ratioWidth(context) * 12,
                                ),
                              ),
                            ),
                            child: CustomText(
                              "Masuk",
                              color: const Color(ListColor.neutral10),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: GlobalVariable.ratioWidth(context) * 14,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                CustomText(
                                  "Supported By",
                                  fontWeight: FontWeight.bold,
                                ),
                                Container(
                                  height: GlobalVariable.ratioWidth(context) * 8,
                                ),
                                Image.asset(
                                  Assets.logoAtena,
                                  height: GlobalVariable.ratioWidth(context) * 20,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: GlobalVariable.ratioWidth(context) * 14,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showDBConfirmDialog(context);
                                  },
                                  child: CustomText(
                                    "Versi ${GlobalVariable.xVersion}",
                                    color: const Color(ListColor.neutral100),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(() => CustomText(
                                      controller.selectedPerusahaan.value.value,
                                      color: const Color(ListColor.neutral100),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

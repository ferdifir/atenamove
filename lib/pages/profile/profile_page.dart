// ignore_for_file: use_build_context_synchronously

import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/profile/profile_controller.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextFormField.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultBg(
      title: "Profile",
      onBackPress: () => Get.back(),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            controller.openHelpAplikasi();
          },
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
            child: Image.asset(
              "assets/images/profile.png",
              width: GlobalVariable.ratioWidth(context) * 50,
              height: GlobalVariable.ratioWidth(context) * 50,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
            child: CustomText(
              Get.arguments ?? "",
              fontSize: Listfontsize.h4,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          Padding(
            padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(context) * 10),
            child: CustomText(
              "Terakhir Unduh : ${DateFormat("yyyy-MM-dd HH:mm:ss").format(controller.xTglUnduh.value)}",
              fontSize: Listfontsize.px14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: const Color(ListColor.infoMain),
            ),
          ),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileButton(
                context: context,
                pText: "Unduh Data",
                pIconPath: "assets/icons/download.svg",
                onclick: () {
                  if (controller.xIsVerified.value) return;
                  popUpUnduhData(context);
                },
                pColor: const Color(ListColor.infoMain),
              ),
              ProfileButton(
                context: context,
                pText: "Sinkronisasi",
                pIconPath: "assets/icons/sync.svg",
                onclick: controller.xIsVerified.value ? null : () => popUpSinkronisasi(context),
                pColor: const Color(ListColor.infoMain),
              ),
              ProfileButton(
                context: context,
                pText: "Kata Sandi",
                pIconPath: "assets/icons/key-skeleton.svg",
                onclick: () {
                  CustomWidget.customPopUpOpsi(
                    context: context,
                    pInformation: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          "Ubah Kata Sandi",
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: GlobalVariable.ratioWidth(context) * 16,
                        ),
                        Obx(
                          () => TextFormFieldWidget(
                            textEditingController: controller.xPasswordLamaTextController.value,
                            title: "Kata Sandi Lama",
                            isPassword: true,
                            isShowPassword: controller.xIsShowPasswordLama.value,
                            onClickShowButton: (value) {
                              controller.xIsShowPasswordLama.value = value;
                            },
                            fillColor: controller.xIsErrorPassLama.value == true ? const Color(ListColor.dangerSurface) : const Color(ListColor.neutral10),
                            borderColor: controller.xIsErrorPassLama.value == true ? const Color(ListColor.dangerMain) : const Color(ListColor.neutral50),
                          ),
                        ),
                        Obx(
                          () => controller.xIsErrorPassLama.value == false
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      controller.xErrorTextPassLama.value,
                                      fontSize: Listfontsize.px12,
                                      color: const Color(ListColor.dangerMain),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                        ),
                        Container(
                          height: GlobalVariable.ratioWidth(context) * 16,
                        ),
                        Obx(
                          () => TextFormFieldWidget(
                            textEditingController: controller.xPasswordBaruTextController.value,
                            title: "Kata Sandi Baru",
                            isPassword: true,
                            isShowPassword: controller.xIsShowPasswordBaru.value,
                            onClickShowButton: (value) {
                              controller.xIsShowPasswordBaru.value = value;
                            },
                            fillColor: controller.xIsErrorPassBaru.value == true ? const Color(ListColor.dangerSurface) : const Color(ListColor.neutral10),
                            borderColor: controller.xIsErrorPassBaru.value == true ? const Color(ListColor.dangerMain) : const Color(ListColor.neutral50),
                          ),
                        ),
                        Obx(
                          () => controller.xIsErrorPassBaru.value == false
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      controller.xErrorTextPassBaru.value,
                                      fontSize: Listfontsize.px12,
                                      color: const Color(ListColor.dangerMain),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    pLeftButtonText: "Ya",
                    pRightButtonText: "Tidak",
                    pOnLeftButtonClick: () async {
                      if (controller.xPasswordLamaTextController.value.text == '') {
                        controller.xIsErrorPassLama.value = true;
                        controller.xIsErrorPassLama.refresh();
                        controller.xErrorTextPassLama.value = "Kata Sandi Lama Wajib Diisi";
                      } else if (controller.xPasswordBaruTextController.value.text == '') {
                        controller.xIsErrorPassBaru.value = true;
                        controller.xIsErrorPassBaru.refresh();
                        controller.xErrorTextPassBaru.value = "Kata Sandi Baru Wajib Diisi";
                      } else {
                        bool isSuccess = await controller.gantiPassword();
                        if (isSuccess) {
                          Get.back();
                          CustomWidget.customSuccessPopUp(
                            context: context,
                            pInformation: CustomText(
                              "Kata Sandi Berhasil Diubah",
                              fontSize: Listfontsize.h5,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          );
                          controller.xIsErrorPassBaru.value = false;
                          controller.xIsErrorPassLama.value = false;
                          controller.xIsErrorPassBaru.refresh();
                          controller.xIsErrorPassLama.refresh();
                          controller.xPasswordLamaTextController.value.clear();
                          controller.xPasswordBaruTextController.value.clear();
                        } else {
                          CustomWidget.customAlertPopUp(
                            context: context,
                            pInformation: CustomText(
                              "Kata Sandi Gagal Diubah",
                              fontSize: Listfontsize.h5,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          );
                          controller.xIsErrorPassBaru.value = false;
                          controller.xIsErrorPassLama.value = false;
                          controller.xIsErrorPassBaru.refresh();
                          controller.xIsErrorPassLama.refresh();
                        }
                      }
                    },
                    pOnRightButtonClick: () {
                      controller.xIsErrorPassBaru.value = false;
                      controller.xIsErrorPassLama.value = false;
                      controller.xIsErrorPassBaru.refresh();
                      controller.xIsErrorPassLama.refresh();
                      controller.xPasswordLamaTextController.value.clear();
                      controller.xPasswordBaruTextController.value.clear();
                      Get.back();
                    },
                  );
                },
                pColor: const Color(ListColor.infoMain),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => ProfileButton(
                      context: context,
                      pText: "Batal Verifikasi",
                      pIconPath: "assets/icons/delete-o.svg",
                      onclick: controller.xUserJabatan.value.contains("KEPALA PENGIRIMAN")
                          ? () {
                              Get.toNamed(AppRoutes.BATAL_VERIFIKASI);
                            }
                          : null,
                      pColor: controller.xUserJabatan.value.contains("KEPALA PENGIRIMAN") ? const Color(ListColor.infoMain) : const Color(ListColor.neutral50),
                    )),
                Obx(() => ProfileButton(
                      context: context,
                      pText: "Tidak Dikunjungi",
                      pIconPath: "assets/icons/tidakdikunjungi.svg",
                      onclick: controller.xUserJabatan.value.contains("KEPALA PENGIRIMAN")
                          ? () {
                              Get.toNamed(AppRoutes.RUTE_TAK_DIKUNJUNGI);
                            }
                          : null,
                      pColor: controller.xUserJabatan.value.contains("KEPALA PENGIRIMAN") ? const Color(ListColor.infoMain) : const Color(ListColor.neutral50),
                    )),
                ProfileButton(
                  context: context,
                  pText: "Keluar",
                  pIconPath: "assets/icons/exitprofile.svg",
                  onclick: () {
                    CustomWidget.customPopUpOpsi(
                      context: context,
                      pInformation: CustomText(
                        "Apakah Anda Yakin Mau Keluar?",
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                      pLeftButtonText: "Ya",
                      pRightButtonText: "Tidak",
                      pOnLeftButtonClick: controller.resetArmadaLogin,
                      pOnRightButtonClick: () => Get.back(),
                    );
                  },
                  pColor: const Color(ListColor.infoMain),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: GlobalVariable.ratioWidth(context) * 10,
              bottom: GlobalVariable.ratioWidth(context) * 70,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 100),
                ),
                backgroundColor: const Color(ListColor.infoMain),
              ),
              onPressed: () async {
                if (controller.xIsVerified.value) {
                  CustomWidget.customAlertPopUp(
                    context: context,
                    pInformation: CustomText(
                      "Sudah Verifikasi",
                      textAlign: TextAlign.center,
                    ),
                  );
                  return;
                }
                if (controller.hasUnduhData.value) {
                  CustomWidget.customPopUpOpsi(
                    context: context,
                    pInformation: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CustomText(
                            "Verifikasi Harian",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: GlobalVariable.ratioWidth(context) * 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Apakah anda yakin akan melakukan Verifikasi Harian untuk sopir ',
                            style: const TextStyle(
                              fontSize: Listfontsize.px14,
                              fontWeight: FontWeight.w600,
                              color: Color(ListColor.neutral100),
                            ),
                            children: [
                              TextSpan(
                                text: controller.xUserUsername.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(ListColor.infoMain),
                                  fontSize: Listfontsize.px14,
                                ),
                              ),
                              const TextSpan(
                                text: '?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(ListColor.neutral100),
                                  fontSize: Listfontsize.px14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: GlobalVariable.ratioWidth(context) * 4,
                        ),
                        CustomText(
                          "1. Tidak dapat melakukan Unduh Data",
                          fontWeight: FontWeight.w600,
                          color: const Color(ListColor.dangerMain),
                        ),
                        CustomText(
                          "2. Tidak dapat melakukan Sinkronisasi",
                          fontWeight: FontWeight.w600,
                          color: const Color(ListColor.dangerMain),
                        ),
                      ],
                    ),
                    pLeftButtonText: "Ya",
                    pRightButtonText: "Tidak",
                    pOnLeftButtonClick: () async {
                      Get.back();
                      Get.toNamed(AppRoutes.VERIFIKASI);
                      // controller.processVerifikasiHarian();
                    },
                    pOnRightButtonClick: () {
                      Get.back();
                    },
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 10, horizontal: GlobalVariable.ratioWidth(context) * 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/verifikasi.svg",
                      width: GlobalVariable.ratioWidth(context) * 30,
                      height: GlobalVariable.ratioWidth(context) * 30,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: GlobalVariable.ratioWidth(context) * 8),
                    CustomText(
                      "Verifikasi Harian",
                      fontSize: Listfontsize.px14,
                      fontWeight: FontWeight.w600,
                      color: const Color(ListColor.neutral10),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // controller.updateAplikasi();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
              child: CustomText(
                "Versi ${GlobalVariable.xVersion}",
                fontSize: Listfontsize.px14,
              ),
            ),
          )
        ],
      ),
    );
  }

  void popUpUnduhData(BuildContext context) {
    CustomWidget.customDownloadPopUp(
      context: context,
      pWidgetDownload: Obx(
        () => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: GlobalVariable.ratioWidth(context) * 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Mengunduh Data ",
                    fontSize: Listfontsize.h5,
                    fontWeight: FontWeight.bold,
                    color: const Color(ListColor.neutral10),
                  ),
                  CustomText(
                    controller.xCountDot.value,
                    fontSize: Listfontsize.h5,
                    fontWeight: FontWeight.bold,
                    color: const Color(ListColor.neutral10),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
              child: CustomText(
                "Layar Jangan Ditutup Dulu Sampai Proses Unduh Data Selesai ",
                fontSize: 14,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                color: const Color(ListColor.neutral10),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Jam Mulai : ",
                    fontSize: Listfontsize.px14,
                    fontWeight: FontWeight.w600,
                    color: const Color(ListColor.neutral10),
                  ),
                  CustomText(
                    controller.xJamMulai,
                    fontSize: Listfontsize.px14,
                    fontWeight: FontWeight.w600,
                    color: const Color(ListColor.neutral10),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Jam Saat ini : ",
                    fontSize: Listfontsize.px14,
                    fontWeight: FontWeight.w600,
                    color: const Color(ListColor.neutral10),
                  ),
                  CustomText(
                    controller.currentTime.value,
                    fontSize: Listfontsize.px14,
                    fontWeight: FontWeight.w600,
                    color: const Color(ListColor.neutral10),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  controller.xIsGetCustomerRunning.value
                      ? SizedBox(
                          width: GlobalVariable.ratioWidth(context) * 18,
                          height: GlobalVariable.ratioWidth(context) * 18,
                          child: CircularProgressIndicator(
                            color: const Color(ListColor.infoMain),
                            backgroundColor: const Color(ListColor.neutral10),
                            strokeWidth: GlobalVariable.ratioWidth(context) * 1,
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/icons/check.svg',
                          width: 20,
                          height: 20,
                        ),
                  Container(width: GlobalVariable.ratioWidth(context) * 5),
                  CustomText(
                    "Pelanggan (${controller.xCountCatchCustomerError.value}X) ${controller.xGetCustomerEndTime.value}",
                    fontSize: Listfontsize.px14,
                    fontWeight: FontWeight.w600,
                    color: const Color(ListColor.neutral10),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  controller.xIsGetSupplierRunning.value
                      ? SizedBox(
                          width: GlobalVariable.ratioWidth(context) * 20,
                          height: GlobalVariable.ratioWidth(context) * 20,
                          child: CircularProgressIndicator(
                            color: const Color(ListColor.infoMain),
                            backgroundColor: const Color(ListColor.neutral10),
                            strokeWidth: GlobalVariable.ratioWidth(context) * 1,
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/icons/check.svg',
                          width: 20,
                          height: 20,
                        ),
                  Container(width: GlobalVariable.ratioWidth(context) * 5),
                  CustomText(
                    "Transaksi (${controller.xCountCatchTransaksiError.value}X) ${controller.xGetTransaksiEndTime.value}",
                    fontSize: Listfontsize.px14,
                    fontWeight: FontWeight.w600,
                    color: const Color(ListColor.neutral10),
                  ),
                ],
              ),
            ),
            Container(
              height: GlobalVariable.ratioWidth(context) * 10,
            )
          ],
        ),
      ),
      pConfirm: () async {
        await controller.unduhData();
      },
    );
  }

  void popUpSinkronisasi(BuildContext context) {
    CustomWidget.customDownloadPopUp(
      context: context,
      showNotes: false,
      pWidgetDownload: Obx(
        () => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: GlobalVariable.ratioWidth(context) * 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Sinkronisasi ",
                    fontSize: Listfontsize.h5,
                    fontWeight: FontWeight.bold,
                    color: const Color(ListColor.neutral10),
                  ),
                  CustomText(
                    controller.xCountDot.value,
                    fontSize: Listfontsize.h5,
                    fontWeight: FontWeight.bold,
                    color: const Color(ListColor.neutral10),
                  ),
                ],
              ),
            ),
            CustomText(
              "Total Transaksi : ${controller.jmlTransaksi.value}",
              fontWeight: FontWeight.w600,
              color: const Color(ListColor.neutral10),
              textAlign: TextAlign.center,
            ),
            CustomText(
              "(${controller.syncRetryCount.value}X) Transaksi ke ${controller.currentIndexSO.value} dari ${controller.jmlTransaksi.value}",
              fontWeight: FontWeight.w600,
              color: const Color(ListColor.neutral10),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "Jam Mulai : ",
                  fontSize: Listfontsize.px14,
                  fontWeight: FontWeight.w600,
                  color: const Color(ListColor.neutral10),
                ),
                CustomText(
                  controller.syncStartTime.value,
                  fontSize: Listfontsize.px14,
                  fontWeight: FontWeight.w600,
                  color: const Color(ListColor.neutral10),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Jam Saat ini : ",
                    fontSize: Listfontsize.px14,
                    fontWeight: FontWeight.w600,
                    color: const Color(ListColor.neutral10),
                  ),
                  CustomText(
                    controller.currentTime.value,
                    fontSize: Listfontsize.px14,
                    fontWeight: FontWeight.w600,
                    color: const Color(ListColor.neutral10),
                  ),
                ],
              ),
            ),
            Container(
              height: GlobalVariable.ratioWidth(context) * 10,
            )
          ],
        ),
      ),
      pConfirm: () async {
        await controller.sinkronisasi();
      },
    );
  }

  Widget ProfileButton({
    required BuildContext context,
    required String pText,
    required String pIconPath,
    required void Function()? onclick,
    Color pColor = const Color(ListColor.infoMain),
  }) {
    return GestureDetector(
      onTap: onclick,
      child: SizedBox(
        width: GlobalVariable.ratioWidth(context) * 94,
        child: Column(
          children: [
            Container(
              width: GlobalVariable.ratioWidth(context) * 60,
              height: GlobalVariable.ratioWidth(context) * 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: pColor,
                  width: GlobalVariable.ratioWidth(context) * 3,
                ),
                borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 10),
              ),
              child: Padding(
                padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 12),
                child: SvgPicture.asset(
                  pIconPath,
                  width: GlobalVariable.ratioWidth(context) * 30,
                  height: GlobalVariable.ratioWidth(context) * 30,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(pColor, BlendMode.srcIn),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
              child: CustomText(
                pText,
                fontSize: Listfontsize.h5,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}

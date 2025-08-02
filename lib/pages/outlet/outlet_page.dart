// ignore_for_file: use_build_context_synchronously

import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/outlet/outlet_controller.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OutletPage extends GetView<OutletController> {
  const OutletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultBg(
      title: "Outlet",
      onBackPress: () => Get.back(),
      actions: [
        IconButton(
          onPressed: () {
            controller.cekJarak();
          },
          icon: const Icon(
            Icons.location_on_rounded,
          ),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                CustomWidget.customPopUpOpsi(
                  context: context,
                  pInformation: CustomText(
                    "Apakah anda yakin bahwa rute ini tidak dikunjungi?",
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  pLeftButtonText: "Ya",
                  pRightButtonText: "Tidak",
                  pOnLeftButtonClick: () async {
                    Get.back();
                    await controller.simpanRuteTidakDikunjungi();
                    controller.customer.value.statuskunjungan = "TIDAK DIKUNJUNGI";
                    // await DatabaseModelCustomerDalamRute().insert([controller.xDataCustomer.value.toJson()]);
                  },
                  pOnRightButtonClick: () => Get.back(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 12),
                  color: const Color(ListColor.warningSurface),
                  border: Border.all(
                    width: GlobalVariable.ratioWidth(context) * 1,
                    color: const Color(ListColor.warningMain),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: GlobalVariable.ratioWidth(context) * 17,
                    horizontal: GlobalVariable.ratioWidth(context) * 20,
                  ),
                  child: Center(
                    child: CustomText(
                      "Tidak Dikunjungi - Konfirmasi",
                      fontSize: Listfontsize.px14,
                      fontWeight: FontWeight.bold,
                      color: const Color(ListColor.warningMain),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: GlobalVariable.ratioWidth(context) * 78,
            ),
            GestureDetector(
              onTap: () async {},
              child: SizedBox(
                width: GlobalVariable.ratioWidth(context) * 222,
                height: GlobalVariable.ratioWidth(context) * 200,
                child: SvgPicture.asset(
                  "assets/icons/outleticon.svg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(context) * 10),
              child: CustomText(
                controller.customer.value.kodecustomer ?? '',
                fontSize: Listfontsize.px14,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(context) * 10),
              child: CustomText(
                controller.customer.value.namacustomer ?? '',
                fontSize: Listfontsize.h5,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(context) * 10, bottom: GlobalVariable.ratioWidth(context) * 10),
              child: CustomText(
                controller.customer.value.alamat ?? '',
                fontSize: Listfontsize.px14,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Obx(
              () => getStatusCheckIn(context: context, pStatus: controller.status.value),
            ),
            Obx(() => Padding(
                  padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(context) * 10),
                  child: GestureDetector(
                    onTap: () async {
                      print("Verified : ${controller.xIsVerified.value} || Available : ${controller.isAvailable.value}");
                      if (controller.xIsVerified.value || !controller.isAvailable.value) return;
                      final checkedOut = controller.customer.value.tglcheckout;
                      final isCheckedOut = checkedOut != null;
                      print("Check-Out : ${controller.customer.value.tglcheckout}");
                      if (isCheckedOut) {
                        Get.toNamed(
                          AppRoutes.TRANSAKSI,
                          arguments: controller.customer.value,
                        );
                      } else {
                        bool picResult = await controller.takePicture();
                        if (picResult) {
                          CustomWidget.customAlertPopUp(
                            dismissible: false,
                            context: context,
                            pInformation: SizedBox(
                              height: GlobalVariable.ratioWidth(context) * 90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await pilihAlasan();
                                    },
                                    child: Container(
                                      width: GlobalVariable.ratioWidth(context) * 90,
                                      height: GlobalVariable.ratioWidth(context) * 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
                                        border: Border.all(
                                          width: GlobalVariable.ratioWidth(context) * 1,
                                          color: const Color(ListColor.dangerMain),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/checkout.svg",
                                          ),
                                          Container(
                                            height: GlobalVariable.ratioWidth(context) * 10,
                                          ),
                                          CustomText(
                                            "Check-Out",
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                            color: const Color(ListColor.dangerMain),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: GlobalVariable.ratioWidth(context) * 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                      Get.toNamed(
                                        AppRoutes.TRANSAKSI,
                                        arguments: controller.customer,
                                      );
                                    },
                                    child: Container(
                                      width: GlobalVariable.ratioWidth(context) * 90,
                                      height: GlobalVariable.ratioWidth(context) * 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 8),
                                        border: Border.all(
                                          width: GlobalVariable.ratioWidth(context) * 1,
                                          color: const Color(ListColor.infoMain),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/clipboard-o.svg",
                                          ),
                                          Container(
                                            height: GlobalVariable.ratioWidth(context) * 10,
                                          ),
                                          CustomText(
                                            "Transaksi",
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                            color: const Color(ListColor.infoMain),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(context) * 18),
                        color: controller.isAvailable.value == true && !controller.xIsVerified.value ? const Color(ListColor.infoMain) : const Color(ListColor.neutral50),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: GlobalVariable.ratioWidth(context) * 7,
                          horizontal: GlobalVariable.ratioWidth(context) * 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              controller.status.value == "selesai" ? "assets/icons/ubahpesanan.svg" : "assets/icons/checkinicon.svg",
                              fit: BoxFit.scaleDown,
                              width: GlobalVariable.ratioWidth(context) * 18,
                              height: GlobalVariable.ratioWidth(context) * 18,
                            ),
                            CustomText(
                              controller.customer.value.tglcheckout != null ? "Lihat Transaksi" : "Check-In",
                              fontSize: Listfontsize.px14,
                              fontWeight: FontWeight.w600,
                              color: const Color(ListColor.neutral10),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> pilihAlasan() async {
    CustomWidget.customPopUpOpsi(
      context: Get.context!,
      pInformation: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              "Alasan Check-Out",
              fontWeight: FontWeight.bold,
            ),
            for (int i = 0; i < controller.items.length; i++)
              Padding(
                padding: EdgeInsets.only(top: GlobalVariable.ratioWidth(Get.context!) * 16),
                child: GestureDetector(
                  onTap: () {
                    controller.xSelectedAlasan.value = controller.items[i];
                    controller.xSelectedAlasan.refresh();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      controller.xSelectedAlasan.value == controller.items[i]
                          ? SvgPicture.asset(
                              "assets/icons/radioclicked.svg",
                              colorFilter: const ColorFilter.mode(Color(ListColor.infoMain), BlendMode.srcIn),
                              fit: BoxFit.scaleDown,
                              width: GlobalVariable.ratioWidth(Get.context!) * 20,
                              height: GlobalVariable.ratioWidth(Get.context!) * 20,
                            )
                          : SvgPicture.asset(
                              "assets/icons/radioborder.svg",
                              fit: BoxFit.scaleDown,
                              width: GlobalVariable.ratioWidth(Get.context!) * 16,
                              height: GlobalVariable.ratioWidth(Get.context!) * 16,
                            ),
                      Container(
                        width: GlobalVariable.ratioWidth(Get.context!) * 4,
                      ),
                      CustomText(controller.items[i])
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      pLeftButtonText: "Simpan",
      pRightButtonText: "Batal",
      pOnLeftButtonClick: () async {
        if (controller.xSelectedAlasan.value == "") {
          CustomWidget.customAlertPopUp(
            context: Get.context!,
            pInformation: CustomText(
              "Pilih Alasan Check-Out Terlebih Dahulu",
              textAlign: TextAlign.center,
            ),
          );
          return;
        }
        controller.checkOut();
        Get.back();
        Get.back();
      },
      pOnRightButtonClick: () {
        Get.back();
      },
    );
  }

  Widget getStatusCheckIn({
    required BuildContext context,
    required String pStatus,
  }) {
    if (controller.xIsVerified.value) {
      return CustomText(
        "Tidak Bisa Mengubah Pesanan Karena Sudah Verifikasi",
        fontSize: Listfontsize.px14,
        fontWeight: FontWeight.bold,
        color: const Color(ListColor.dangerMain),
        textAlign: TextAlign.center,
      );
    } else if (pStatus == "Fake GPS") {
      return CustomText(
        "Harap Matikan Fake GPS",
        fontSize: Listfontsize.h5,
        fontWeight: FontWeight.bold,
        color: const Color(ListColor.dangerMain),
        textAlign: TextAlign.center,
      );
    } else if (pStatus == "Diluar jarak") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            "Outlet Terlalu Jauh",
            color: const Color(ListColor.dangerMain),
            textAlign: TextAlign.center,
          ),
          CustomText(
            "Lat : ${controller.xLatUser.value} | Long : ${controller.xLongUser.value}",
            color: const Color(ListColor.dangerMain),
            textAlign: TextAlign.center,
          ),
          CustomText(
            "(Jarak ${controller.xJarakUserOutlet.value} Meter Dari Lokasi Outlet)",
            color: const Color(ListColor.dangerMain),
            textAlign: TextAlign.center,
          )
        ],
      );
    } else if (pStatus == "Valid") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            "Lokasi Anda Sudah Didapatkan",
            color: const Color(ListColor.infoMain),
            textAlign: TextAlign.center,
          ),
          CustomText(
            "Lat : ${controller.xLatUser.value} | Long : ${controller.xLongUser.value}",
            color: const Color(ListColor.infoMain),
            textAlign: TextAlign.center,
          ),
          CustomText(
            "(Jarak ${controller.xJarakUserOutlet.value} Meter Dari Lokasi Outlet)",
            color: const Color(ListColor.infoMain),
            textAlign: TextAlign.center,
          )
        ],
      );
    } else if (pStatus == "loading") {
      return Column(
        children: [
          SizedBox(
            width: GlobalVariable.ratioWidth(context) * 40,
            height: GlobalVariable.ratioWidth(context) * 40,
            child: CircularProgressIndicator(
              strokeWidth: GlobalVariable.ratioWidth(context) * 5,
              color: const Color(ListColor.infoMain),
              backgroundColor: const Color(ListColor.infoSurface),
            ),
          ),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          CustomText(
            "Apabila Dirasa Lama Mohon Restart GPS",
            color: const Color(ListColor.dangerMain),
            textAlign: TextAlign.center,
          )
        ],
      );
    } else if (pStatus == "alasan") {
      return Column(
        children: [
          CustomText(
            controller.xSelectedAlasan.value,
            fontSize: Listfontsize.px12,
            color: const Color(ListColor.infoMain),
          ),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          CustomText("Check-In : ${controller.xJamCheckIn.value}"),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          CustomText("Check-Out : ${controller.xJamCheckOut.value}"),
        ],
      );
    } else if (pStatus == "selesai") {
      return Column(
        children: [
          CustomText(
            "SELESAI MEMBUAT PESANAN",
            fontSize: Listfontsize.px12,
            color: const Color(ListColor.infoMain),
          ),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          CustomText("Check-In : ${controller.xJamCheckIn.value}"),
          Container(
            height: GlobalVariable.ratioWidth(context) * 10,
          ),
          CustomText("Check-Out : ${controller.xJamCheckOut.value}"),
        ],
      );
    } else {
      return Container();
    }
  }
}

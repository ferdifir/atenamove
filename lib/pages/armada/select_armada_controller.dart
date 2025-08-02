// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/model/ModelCustomer.dart';
import 'package:atenamove/model/ModelTransaksi.dart';
import 'package:atenamove/model/armadaModel.dart';
import 'package:atenamove/routes/app_routes.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SelectArmadaController extends GetxController {
  Rx<TextEditingController> xSearchTextField = TextEditingController().obs;
  final xPref = SharedPreferencesService();
  List<ArmadaModel> listArmada = [];
  RxList<ArmadaModel> xListArmada = <ArmadaModel>[].obs;
  RxBool xIsSPV = false.obs;

  @override
  void onInit() {
    super.onInit();
    isSPV();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDepo(Get.context!);
    });
  }

  isSPV() async {
    final user = await xPref.getUser();
    print(user.jabatan);
    xIsSPV.value = user.jabatan!.contains("KEPALA");
    xIsSPV.refresh();
  }

  searchArmada(String query) async {
    xListArmada.clear();

    if (query.isEmpty) {
      print("Kosong");
      xListArmada.addAll(listArmada);
      xListArmada.refresh();
      return;
    }
    print("Query: $query");
    final lowerCaseQuery = query.toLowerCase();
    xListArmada.addAll(listArmada.where((armada) => armada.namaarmada!.toLowerCase().contains(lowerCaseQuery) || armada.nopolisi!.toLowerCase().contains(lowerCaseQuery)));
    xListArmada.refresh();
  }

  getDepo(BuildContext context) async {
    try {
      xListArmada.clear();
      listArmada.clear();
      CustomWidget.customLoadingPopUp(context: context);
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().getArmada(
        idperusahaan: user.idperusahaan ?? "",
        iddepo: user.iddepo ?? "",
        tglkirim: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      Get.back();
      if (result != null && result.success) {
        result.data.forEach((e) => listArmada.add(ArmadaModel.fromJson(e)));
        xListArmada.addAll(listArmada);
        xListArmada.refresh();
      }
    } catch (e) {
      print("error Get DEPO: $e");
    }
  }

  selectArmada(BuildContext context, ArmadaModel data) async {
    print(data.idarmada);
    try {
      CustomWidget.customLoadingPopUp(context: context);
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().updateArmada(
        idperusahaan: user.idperusahaan ?? "",
        iddepo: user.iddepo ?? "",
        iduser: user.iduser ?? "",
        idarmada: data.idarmada!,
      );
      Get.back();
      print(result);
      if (result != null && result.success) {
        if (data.statusverifikasi == "0") {
          final ArmadaModel armada = await xPref.getArmada();
          final String? idArmada = armada.idarmada;
          if (idArmada != null && idArmada != armada.idarmada) {
            CustomWidget.customPopUpOpsi(
              context: context,
              pInformation: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Armada yang dipilih sebelumnya berbeda. Apa anda yakin memilih armada ini ?"),
                  Text("(Jika memilih armada ini, data akan tereset seluruhnya, lakukan sinkronisasi sebelum mengganti armada)"),
                ],
              ),
              pLeftButtonText: "Ya",
              pRightButtonText: "Tidak",
              pOnLeftButtonClick: () async {
                ModelCustomer().clear();
                ModelTransaksi().clear();
                await xPref.setArmada(armada);
                Get.offAllNamed(AppRoutes.DASHBOARD);
              },
              pOnRightButtonClick: () {
                Get.back();
              },
            );
          } else {
            print("ID Armada : ${data.idarmada}");
            await xPref.setArmada(data);
            Get.offAllNamed(AppRoutes.DASHBOARD);
          }
        } else {
          CustomWidget.customAlertPopUp(
            context: context,
            pInformation: CustomText(
              "Armada ini sudah diverifikasi oleh Sopir / Helper lain",
              textAlign: TextAlign.center,
            ),
          );
        }
      } else {
        CustomWidget.customAlertPopUp(
          context: context,
          pInformation: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(result?.message ?? "Terjadi Kesalahan untuk mendapatkan data armada"),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(ListColor.successSurface),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(ListColor.successMain)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.phone_android,
                      color: Color(ListColor.successMain),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Chat WA Nama Sopir",
                          style: TextStyle(color: Color(ListColor.successMain)),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    } catch (e) {
      Get.back();
      print("error Get DEPO: $e");
    }
  }

  resetArmadaLogin() async {
    try {
      CustomWidget.customLoadingPopUp(context: Get.context!);
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().resetArmadaLogin(
        pIdPerusahaan: user.idperusahaan ?? '',
        pIdUser: user.iduser ?? '',
        pIdDepo: user.iddepo ?? '',
      );
      if (result != null && result.success) {
        ApiResponse? result2 = await ApiHelper().logout(
          pIdPerusahaan: user.idperusahaan ?? '',
          pIdUser: user.iduser ?? '',
        );
        Get.back();
        if (result2 != null && result2.success) {
          await xPref.clear();
          Get.offAllNamed(
            AppRoutes.LOGIN,
            arguments: true,
          );
        }
      } else {
        Get.back();
      }
    } catch (e) {
      print(e);
      Get.back();
    }
  }
}

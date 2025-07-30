// ignore_for_file: use_build_context_synchronously

import 'package:atenamove/api/api_response.dart';
import 'package:atenamove/config/apiHelper.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/model/armadaModel.dart';
import 'package:atenamove/utils/sharedpref.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SelectArmadaController extends GetxController {
  Rx<TextEditingController> xSearchTextField = TextEditingController().obs;
  final xPref = SharedPreferencesService();
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
    if (user.jabatan!.contains("KEPALA")) {
      xIsSPV.value = true;
    }
  }

  getDepo(BuildContext context) async {
    try {
      CustomWidget.customLoadingPopUp(context: context);
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().getArmada(
        idperusahaan: user.idperusahaan ?? "",
        iddepo: user.iddepo ?? "",
        tglkirim: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      Get.back();
      if (result != null && result.success) {
        xListArmada.clear();
        result.data.forEach((e) => xListArmada.add(ArmadaModel.fromJson(e)));
        print(xListArmada.length);
      }
    } catch (e) {
      print("error Get DEPO: $e");
    }
  }

  selectArmada(String id, String status, BuildContext context) async {
    try {
      CustomWidget.customLoadingPopUp(context: context);
      final user = await xPref.getUser();
      ApiResponse? result = await ApiHelper().updateArmada(
        idperusahaan: user.idperusahaan ?? "",
        iddepo: user.iddepo ?? "",
        iduser: user.iduser ?? "",
        idarmada: id,
      );
      Get.back();
      print(result);
      if (result != null && result.success) {
        if (status == "0") {
          final String? idArmada = await xPref.getIdArmada();
          if (idArmada != null && idArmada != id) {
            CustomWidget.customPopUpOpsi(
              context: context,
              pInformation: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Armada yang dipilih sebelumnya berbeda.  Apa anda yakin memilih armada ini ?"),
                  Text("(Jika memilih armada ini, data akan tereset seluruhnya, lakukan sinkronisasi sebelum mengganti armada)"),
                ],
              ),
              pLeftButtonText: "Ya",
              pRightButtonText: "Tidak",
              pOnLeftButtonClick: () {},
              pOnRightButtonClick: () {
                Get.back();
              },
            );
          }
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
}

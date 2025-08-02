import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/rute_tak_dikunjungi/rutetakdikunjungi_controller.dart';
import 'package:atenamove/widget/customCustomerCard.dart';
import 'package:atenamove/widget/customPopUpWidget.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RuteTidakDikunjungiPage extends GetView<RuteTidakDikunjungiController> {
  const RuteTidakDikunjungiPage({super.key});

  void showAlasanDialog(
    BuildContext context,
    String idcustomer,
    String urutan,
  ) {
    final ctrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    CustomWidget.customPopUpOpsi(
      context: context,
      pInformation: Obx(() {
        return Column(
          children: [
            CustomText(
              'Alasan Tidak Dikunjungi',
              fontWeight: FontWeight.bold,
            ),
            for (int i = 0; i < controller.items.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(Get.context!) * 16),
                child: GestureDetector(
                  onTap: () {
                    controller.xSelectedAlasan.value = controller.items[i];
                    controller.xSelectedAlasan.refresh();
                    if (controller.xSelectedAlasan.value == "Alasan Lainnya") {
                      ctrl.clear();
                    }
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
            TextFormField(
              controller: ctrl,
              readOnly: controller.xSelectedAlasan.value != "Alasan Lainnya",
              onChanged: (value) {
                if (controller.xSelectedAlasan.value == "Alasan Lainnya") {
                  controller.xSelectedAlasan.value = value;
                }
              },
              validator: (value) {
                if (controller.xSelectedAlasan.value == "Alasan Lainnya" && value!.isEmpty) {
                  return "Data harus diisi";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Alasan Lainnya",
                hintStyle: TextStyle(
                  fontSize: GlobalVariable.ratioFontSize(Get.context!) * 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff9AA5B1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(Get.context!) * 10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(Get.context!) * 10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(GlobalVariable.ratioWidth(Get.context!) * 10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ],
        );
      }),
      pLeftButtonText: 'Simpan',
      pRightButtonText: 'Batal',
      pOnLeftButtonClick: () {
        if (!formKey.currentState!.validate()) return;
        Get.back();
        controller.approveAlasan(
          idcustomer,
          urutan,
          controller.xSelectedAlasan.value,
        );
      },
      pOnRightButtonClick: () {
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultBg(
      title: 'Daftar Rute Tidak Dikunjungi',
      onBackPress: () => Get.back(),
      child: Column(
        children: [
          CustomTextField(
            context: context,
            onChanged: controller.searchRute,
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
          Expanded(
            child: ListView.builder(
              itemCount: controller.xData.length,
              itemBuilder: (context, index) {
                final data = controller.xData[index];
                return customCustomerCard(
                  pKodeCustomer: data["kodecustomer"],
                  pNamaCustomer: data["namacustomer"],
                  pAlamatCustomer: data["alamat"],
                  pStatusKunjungan: "Sopir : " + data["namasopir"],
                  pOmzetCustomer: "Helper : " + data["namahelper"] ?? "-",
                  onTap: () {
                    showAlasanDialog(
                      context,
                      data["idcustomer"],
                      data["urutan"],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

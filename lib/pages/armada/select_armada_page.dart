import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/pages/armada/select_armada_controller.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:atenamove/widget/defaultBgScaffold.dart';
import 'package:atenamove/widget/threeDotButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SelectArmadaPage extends GetView<SelectArmadaController> {
  const SelectArmadaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultBg(
      title: "Pilih Armada",
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 3),
                  child: CustomTextField(
                    context: context,
                    onChanged: (value) => {},
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

                        return cardDepo(
                          context: context,
                          name: data.namaarmada,
                          id: "Armada : ${data.nopolisi}",
                          status: data.statusverifikasi,
                          onClick: () {
                            controller.selectArmada(
                              data.idarmada,
                              data.statusverifikasi,
                              context,
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
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: ThreeDotPopupMenu(
              onTidakDikunjungi: () {},
              onBatalVerifikasi: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget cardDepo({
    required BuildContext context,
    required String name,
    required String id,
    required Function() onClick,
    required String status,
  }) {
    final color = status == "0" ? ListColor.infoMain : ListColor.successMain;
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 5),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(GlobalVariable.ratioWidth(context) * 10),
            ),
            side: BorderSide(
              color: Color(color),
              width: GlobalVariable.ratioWidth(context) * 1,
            ),
          ),
          color: status != "0" ? const Color(ListColor.successSurface) : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 10),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 10),
                  child: Container(
                    width: GlobalVariable.ratioWidth(context) * 40,
                    height: GlobalVariable.ratioWidth(context) * 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: status == "0" ? const Color(ListColor.infoSurface) : Colors.white,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/truck.svg',
                        height: GlobalVariable.ratioWidth(context) * 24,
                        width: GlobalVariable.ratioWidth(context) * 24,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(
                          Color(color),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      name.toString(),
                      fontSize: Listfontsize.h5,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      id.toString(),
                      fontSize: Listfontsize.px12,
                      color: Color(color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

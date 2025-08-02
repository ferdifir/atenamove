import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCardDepo extends StatelessWidget {
  const CustomCardDepo({
    super.key,
    required this.name,
    required this.id,
    required this.onClick,
    required this.status,
  });

  final String name;
  final String id;
  final Function() onClick;
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = status == "0" ? ListColor.infoMain : ListColor.successHover;
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
                    width: GlobalVariable.ratioWidth(context) * 50,
                    height: GlobalVariable.ratioWidth(context) * 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: status == "0" ? const Color(ListColor.infoSurface) : Colors.white,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/truck-o.svg',
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

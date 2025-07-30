import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class DefaultBg extends StatelessWidget {
  const DefaultBg({
    super.key,
    required this.child,
    required this.title,
    this.onBackPress,
  });

  final Widget child;
  final String title;
  final void Function()? onBackPress;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(ListColor.infoMain),
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(ListColor.infoMain),
          appBar: AppBar(
            leading: GestureDetector(
              onTap: onBackPress,
              child: SvgPicture.asset(
                "assets/icons/arrow-back.svg",
                height: GlobalVariable.ratioWidth(context) * 30,
                width: GlobalVariable.ratioWidth(context) * 30,
                fit: BoxFit.scaleDown,
              ),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Padding(
              padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 18),
              child: CustomText(
                title,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Listfontsize.h5,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(GlobalVariable.ratioWidth(context) * 15),
                      topRight: Radius.circular(GlobalVariable.ratioWidth(context) * 15),
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(GlobalVariable.ratioWidth(context) * 10),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

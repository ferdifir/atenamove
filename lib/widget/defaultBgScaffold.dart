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
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.actions,
  });

  final Widget child;
  final dynamic title;
  final void Function()? onBackPress;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(ListColor.infoMain),
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
          backgroundColor: const Color(ListColor.infoMain),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          appBar: AppBar(
            actions: actions,
            leading: GestureDetector(
              onTap: onBackPress,
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: const Color(ListColor.infoMain),
                  size: GlobalVariable.ratioWidth(context) * 24,
                ),
              ),
              // SvgPicture.asset(
              //   "assets/icons/arrow-back.svg",
              //   height: GlobalVariable.ratioWidth(context) * 30,
              //   width: GlobalVariable.ratioWidth(context) * 30,
              //   fit: BoxFit.scaleDown,
              // ),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Padding(
              padding: EdgeInsets.all(
                (title is String) ? GlobalVariable.ratioWidth(context) * 18 : 0,
              ),
              child: (title is String)
                  ? CustomText(
                      title,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Listfontsize.h5,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    )
                  : title,
            ),
            centerTitle: (title is String),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
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

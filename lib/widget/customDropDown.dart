import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:atenamove/widget/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../config/listColor.dart';
import 'customTextFormField.dart';

class CustomDropDown extends StatefulWidget {
  final List<DropDownModel> listItem;
  final void Function(DropDownModel)? onSelected;
  final bool isReadOnly;
  final Future<List<DropDownModel>> Function(String)? onSearch;
  final String? searchHintText;
  final String? title;
  final Color? titleColor;
  final Color? errorColor;
  final Color? focusedBorderColor;
  final Color? borderColor;
  final Color? fillColor;
  final Color? disableColor;
  final Color? enableBorderColor;
  final Color? disableBorderColor;
  final String? hintText;
  final Widget? titlewidget;
  final double? textSize;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final String? initialValue;
  final bool? isSetTitleToHint;
  const CustomDropDown({
    super.key,
    required this.listItem,
    this.isReadOnly = false,
    this.onSelected,
    this.title,
    this.titleColor,
    this.errorColor,
    this.focusedBorderColor,
    this.borderColor,
    this.fillColor,
    this.disableColor,
    this.enableBorderColor,
    this.disableBorderColor,
    this.hintText,
    this.searchHintText,
    this.titlewidget,
    this.textSize,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.isSetTitleToHint,
    this.onSearch,
    this.initialValue,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  TextEditingController xSearchController = TextEditingController();
  TextEditingController xSelectedController = TextEditingController();
  RxList<DropDownModel> xTempListValue = <DropDownModel>[].obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    xSelectedController = TextEditingController(text: widget.initialValue);
    xTempListValue.addAll(widget.listItem);
    xTempListValue.refresh();
  }

  List<DropDownModel> searchItem(String pSearch) {
    List<DropDownModel> tempList = [];
    tempList = List<DropDownModel>.from(widget.listItem).where((element) => element.text.toLowerCase().contains(pSearch.toLowerCase())).toList();
    return tempList;
  }

  void showDropDown() {
    FocusScope.of(context).requestFocus(new FocusNode());
    xSearchController.clear();
    xTempListValue.clear();
    xTempListValue.addAll(widget.listItem);
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(GlobalVariable.ratioWidth(context) * 20),
        ),
      ),
      builder: (context) {
        return Obx(
          () => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                right: GlobalVariable.ratioWidth(context) * 16,
                left: GlobalVariable.ratioWidth(context) * 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: GlobalVariable.ratioWidth(context) * 4,
                      bottom: GlobalVariable.ratioWidth(context) * 12,
                    ),
                    height: GlobalVariable.ratioWidth(context) * 3,
                    width: GlobalVariable.ratioWidth(context) * 38,
                    decoration: const BoxDecoration(
                      color: Color(ListColor.infoMain),
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: xSearchController,
                    newContentPadding: EdgeInsets.symmetric(vertical: GlobalVariable.ratioWidth(context) * 12, horizontal: GlobalVariable.ratioWidth(context) * 16),
                    onChanged: (value) async {
                      xTempListValue.clear();
                      if (widget.onSearch != null) {
                        xTempListValue.addAll(await widget.onSearch!(value));
                      } else {
                        xTempListValue.addAll(searchItem(value));
                      }
                    },
                    preffixIcon: Container(
                      padding: EdgeInsets.all(
                        GlobalVariable.ratioWidth(context) * 12,
                      ),
                      child: SvgPicture.asset(
                        "${GlobalVariable.xIconsPath}search.svg",
                        colorFilter: const ColorFilter.mode(
                          Color(ListColor.infoMain),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    context: context,
                    newInputDecoration: InputDecoration(
                      hintText: widget.searchHintText,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: GlobalVariable.ratioWidth(context) * 300,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < (widget.onSearch != null ? widget.listItem.length : xTempListValue.length); i++)
                            GestureDetector(
                              onTap: (){
                                Get.back();
                                DropDownModel selectedItem=(widget.onSearch != null ? widget.listItem[i] : xTempListValue[i]);
                                if(widget.onSelected!=null){widget.onSelected!(selectedItem);}
                                xSelectedController.text=selectedItem.text;
                              },
                            child:Container(
                              padding: EdgeInsets.symmetric(
                                vertical: GlobalVariable.ratioWidth(context) * 10,
                              ),
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color(ListColor.neutral40),
                                    width: i == (widget.onSearch != null ? widget.listItem.length - 1 : xTempListValue.length - 1) ? 0 : GlobalVariable.ratioWidth(context),
                                  ),
                                ),
                              ),
                              child: CustomText(
                                widget.onSearch == null ? xTempListValue[i].text : widget.listItem[i].text,
                              ),
                            ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      title: widget.title!,
      ignorePointers: true,
      titleColor: widget.titleColor ?? const Color(ListColor.neutral100),
      errorColor: widget.errorColor ?? const Color(ListColor.dangerMain),
      focusedBorderColor: widget.focusedBorderColor,
      fillColor: widget.fillColor ?? Colors.white,
      disableColor: widget.disableColor ?? const Color(ListColor.neutral40),
      enableBorderColor: widget.enableBorderColor,
      disableBorderColor: widget.disableBorderColor,
      hintText: widget.hintText ?? "",
      titlewidget: widget.titlewidget,
      textSize: widget.textSize ?? Listfontsize.px14,
      prefixIconConstraints: widget.prefixIconConstraints,
      suffixIconConstraints: widget.suffixIconConstraints,
      isSetTitleToHint: widget.isSetTitleToHint ?? false,
      onTap: () {
        showDropDown();
      },
      textEditingController: xSelectedController,
      suffixIcon: Container(
        padding: EdgeInsets.all(
          GlobalVariable.ratioWidth(context) * 12,
        ),
        child: SvgPicture.asset(
          "${GlobalVariable.xIconsPath}chevron-down-o.svg",
          colorFilter: const ColorFilter.mode(
            Color(ListColor.neutral100),
            BlendMode.srcIn,
          ),
          fit: BoxFit.contain,
        ),
      ),
      isReadOnly: true,
    );
  }
}

class DropDownModel{
  String text;
  String value;
  DropDownModel({
    this.text="",
    this.value="",
  });
}
import 'package:atenamove/config/ListFontSize.dart';
import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:atenamove/widget/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String? Function(String?)? validator;
  final VoidCallback? onSaved;
  final void Function(String)? onChanged;
  final bool isPassword;
  final bool isEmail;
  final bool isPhoneNumber;
  final bool isCollapse;
  final bool isShowCodePhoneNumber;
  final bool isNumber;
  final bool isName;
  final bool isSetTitleToHint;
  final bool isEnable;
  final bool isNextEditText;
  final bool isShort;
  final bool isShowPassword;
  final bool isMultiLine;
  final void Function()? onTap;
  final int minLines;
  final int maxLines;
  final bool isShowError;
  final bool isCustomTitle;
  final bool isReadOnly;
  final bool isShowCursor;
  final TextEditingController? textEditingController;
  final double? width;
  final double marginBottom;
  final String title;
  final Color titleColor;
  final Color? errorColor;
  final Color? focusedBorderColor;
  final Color? borderColor;
  final Color fillColor;
  final Color disableColor;
  final Color? enableBorderColor;
  final Color? disableBorderColor;
  final ValueChanged<bool>? onClickShowButton;
  final TextEditingController _textEditingControllerIDPhoneNumber = TextEditingController(text: "+62");
  final TextStyle? hintTextStyle;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;
  final String hintText;
  final Widget? titlewidget;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final TextAlign textAlign;
  final bool isDecimal;
  final double customContentPaddingHorizontal;
  final double customContentPaddingVertical;
  final bool isDense;
  final bool isSelectAllWhenOnClick;
  final double textSize;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final bool removeZeroFront;
  final List<TextInputFormatter>? customTextInputFormatter;
  final bool isMakeNewLine;
  final bool? ignorePointers;
  TextFormFieldWidget({
    this.onSaved,
    this.ignorePointers = false,
    this.onChanged,
    this.validator,
    this.isPassword = false,
    this.isEmail = false,
    this.isPhoneNumber = false,
    this.isShowCodePhoneNumber = true,
    this.textEditingController,
    this.isCollapse = false,
    this.width,
    this.title = "",
    this.isEnable = true,
    this.isNextEditText = true,
    this.isShort = false,
    this.isName = false,
    this.titleColor = const Color(ListColor.neutral100),
    this.borderColor,
    this.errorColor = const Color(ListColor.dangerMain),
    this.enableBorderColor,
    this.disableBorderColor,
    this.onClickShowButton,
    this.isShowPassword = false,
    this.isSetTitleToHint = false,
    this.isSelectAllWhenOnClick = false,
    this.marginBottom = 0,
    this.focusedBorderColor,
    this.fillColor = Colors.white,
    this.disableColor = const Color(ListColor.neutral40),
    this.hintTextStyle,
    this.hintText = "",
    this.titleTextStyle,
    this.contentTextStyle,
    this.isMultiLine = false,
    this.minLines = 1,
    this.maxLines = 6,
    this.isShowError = true,
    this.isNumber = false,
    this.isCustomTitle = false,
    this.isReadOnly = false,
    this.isShowCursor = true,
    this.titlewidget,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.textAlign = TextAlign.left,
    this.isDecimal = false,
    this.isDense = false,
    this.customContentPaddingHorizontal = 16,
    this.customContentPaddingVertical = 12,
    this.textSize = 14,
    this.removeZeroFront = true,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.isMakeNewLine = false,
    this.customTextInputFormatter,
    this.onTap,
  });
  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: EdgeInsets.only(bottom: widget.marginBottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!widget.isSetTitleToHint)
            Container(
              margin: EdgeInsets.only(top: 0, bottom: GlobalVariable.ratioWidth(context) * 8),
              child: widget.isCustomTitle && widget.titlewidget != null
                  ? widget.titlewidget
                  : CustomText(
                      widget.title,
                      color: widget.titleTextStyle == null ? widget.titleColor : widget.titleTextStyle?.color ?? widget.titleColor,
                      fontSize: widget.titleTextStyle == null ? Listfontsize.px14 : widget.titleTextStyle!.fontSize ?? Listfontsize.px14,
                      fontWeight: widget.titleTextStyle == null ? FontWeight.w600 : widget.titleTextStyle!.fontWeight ?? FontWeight.bold,
                    ),
            ),
          Container(
            margin: EdgeInsets.only(
              right: widget.isShort ? 100 : 0,
            ),
            child: _textFormField(context),
          ),
        ],
      ),
    );
  }

  Widget _textFormField(BuildContext context) {
    return widget.isPhoneNumber && widget.isShowCodePhoneNumber
        ? Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 70,
                child: _textFormFieldWidget(
                  context: context,
                  textEditingController: widget._textEditingControllerIDPhoneNumber,
                  isEnable: false,
                  isPassword: false,
                  validator: (String? value) {
                    return null;
                  },
                  ignorePointers: widget.ignorePointers ?? false,
                  customTextInputFormatter: widget.customTextInputFormatter,
                  isPhoneNumber: false,
                  isEmail: false,
                  isName: true,
                  onTap: widget.onTap,
                ),
              ),
              SizedBox(width: 20.00),
              Expanded(
                child: _textFormFieldDefault(context),
              ),
            ],
          )
        : _textFormFieldDefault(context);
  }

  Widget _textFormFieldWidget({
    required BuildContext context,
    bool isNextEditText = true,
    bool isEnable = true,
    bool isMakeNewLine = false,
    TextEditingController? textEditingController,
    Color? errorColor = const Color(ListColor.dangerMain),
    bool isPassword = false,
    bool isShowPassword = false,
    String? Function(String?)? validator,
    Function()? onTap,
    bool isPhoneNumber = false,
    bool isEmail = false,
    bool isName = false,
    bool isReadOnly = false,
    bool isShowCursor = true,
    int? maxLength,
    List<TextInputFormatter>? customTextInputFormatter,
    bool ignorePointers = false,
  }) {
    TextInputType textInputTypeByCondition = TextInputType.name;
    if (widget.isMultiLine) {
      textInputTypeByCondition = TextInputType.multiline;
    } else if (isPhoneNumber) {
      textInputTypeByCondition = TextInputType.phone;
    } else if (widget.isNumber) {
      textInputTypeByCondition = TextInputType.numberWithOptions(decimal: widget.isDecimal);
    } else if (widget.isEmail) {
      textInputTypeByCondition = TextInputType.emailAddress;
    }
    return CustomTextFormField(
      context: context,
      textSize: widget.textSize,
      newContentPadding: EdgeInsets.symmetric(horizontal: GlobalVariable.ratioWidth(context) * 12, vertical: GlobalVariable.ratioWidth(context) * 8),
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      readOnly: isReadOnly,
      showCursor: isShowCursor,
      // ignorePointers: ignorePointers,
      inputFormatters: customTextInputFormatter != null
          ? customTextInputFormatter
          : maxLength == null
              ? []
              : [LengthLimitingTextInputFormatter(maxLength)],
      initialValue: widget.initialValue,
      textInputAction: isNextEditText
          ? TextInputAction.next
          : isMakeNewLine
              ? TextInputAction.newline
              : TextInputAction.done,
      enabled: isEnable,
      controller: textEditingController,
      style: widget.contentTextStyle,
      textAlign: widget.textAlign,
      newInputDecoration: InputDecoration(
          isCollapsed: widget.isCollapse,
          isDense: widget.isDense,
          hintText: widget.isSetTitleToHint ? widget.title : widget.hintText,
          hintStyle: widget.hintTextStyle,
          fillColor: isEnable ? widget.fillColor : widget.disableColor,
          // errorStyle: GoogleFonts.openSans(
          //   height: widget.isShowError ? null : 0,
          //   color: errorColor,
          //   fontWeight: FontWeight.w600,
          //   fontSize: widget.isShowError ? GlobalVariable.ratioFontSize(context) * 12 : 0,
          // ),
          errorMaxLines: 2,
          contentPadding: EdgeInsets.symmetric(
            vertical: GlobalVariable.ratioWidth(context) * widget.customContentPaddingVertical,
            horizontal: GlobalVariable.ratioWidth(context) * widget.customContentPaddingHorizontal,
          ),
          filled: true,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.disableBorderColor ?? Color(ListColor.neutral50),
              width: GlobalVariable.ratioWidth(context),
            ), // BorderSide
            borderRadius: BorderRadius.circular(
              GlobalVariable.ratioWidth(context) * 6,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.enableBorderColor ?? (widget.textEditingController != null && widget.textEditingController!.text == "" ? Color(ListColor.neutral50) : Color(ListColor.neutral100)),
              width: GlobalVariable.ratioWidth(context) * 1.0,
            ), // BorderSide
            borderRadius: BorderRadius.circular(
              GlobalVariable.ratioWidth(context) * 6,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor ?? Color(ListColor.neutral50),
              width: GlobalVariable.ratioWidth(context),
            ),
            borderRadius: BorderRadius.circular(
              GlobalVariable.ratioWidth(context) * 6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.focusedBorderColor ?? Color(ListColor.neutral100),
              width: GlobalVariable.ratioWidth(context) * 1.0,
            ),
            borderRadius: BorderRadius.circular(
              GlobalVariable.ratioWidth(context) * 6,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.errorColor ?? Color(ListColor.dangerMain),
              width: GlobalVariable.ratioWidth(context),
            ),
            borderRadius: BorderRadius.circular(
              GlobalVariable.ratioWidth(context) * 6,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.errorColor ?? Color(ListColor.dangerMain),
              width: GlobalVariable.ratioWidth(context) * 2.0,
            ),
            borderRadius: BorderRadius.circular(
              GlobalVariable.ratioWidth(context) * 6,
            ),
          ),
          prefixIcon: widget.prefixIcon,
          prefixIconConstraints: widget.prefixIconConstraints,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    if (widget.onClickShowButton != null) widget.onClickShowButton!(!widget.isShowPassword);
                  },
                  child: !widget.isShowPassword
                      ? Container(
                          padding: EdgeInsets.all(
                            GlobalVariable.ratioWidth(context) * 12,
                          ),
                          child: SvgPicture.asset(
                            "${GlobalVariable.xIconsPath}eye.svg",
                            colorFilter: ColorFilter.mode(
                              Color(ListColor.neutral100),
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.contain,
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(
                            GlobalVariable.ratioWidth(context) * 12,
                          ),
                          child: SvgPicture.asset(
                            "${GlobalVariable.xIconsPath}eye-slash.svg",
                            colorFilter: ColorFilter.mode(
                              Color(ListColor.neutral100),
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                )
              : widget.suffixIcon,
          suffixIconConstraints: widget.suffixIconConstraints),
      obscureText: isPassword && !isShowPassword,
      validator: validator,
      onChanged: (String value) {
        if (widget.onChanged != null) widget.onChanged!(value);
      },
      maxLines: widget.isMultiLine ? widget.maxLines : 1,
      minLines: widget.isMultiLine ? widget.minLines : 1,
      keyboardType: textInputTypeByCondition,
    );
  }

  Widget _textFormFieldDefault(BuildContext context) {
    return _textFormFieldWidget(
      context: context,
      isEnable: widget.isEnable,
      isMakeNewLine: widget.isMakeNewLine,
      isNextEditText: widget.isNextEditText,
      textEditingController: widget.textEditingController,
      errorColor: widget.errorColor,
      isPassword: widget.isPassword,
      isShowPassword: widget.isShowPassword,
      validator: widget.validator,
      isPhoneNumber: widget.isPhoneNumber,
      isEmail: widget.isEmail,
      isName: widget.isName,
      isReadOnly: widget.isReadOnly,
      isShowCursor: widget.isShowCursor,
      maxLength: widget.maxLength,
      customTextInputFormatter: widget.customTextInputFormatter,
      onTap: widget.onTap,
    );
  }
}

class CustomTextFormField extends TextFormField {
  final BuildContext context;
  final InputDecoration? newInputDecoration;
  final EdgeInsets? newContentPadding;
  final double textSize;
  CustomTextFormField({
    required this.context,
    required this.newInputDecoration,
    this.newContentPadding,
    this.textSize = 14,
    super.key,
    super.controller,
    super.initialValue,
    super.focusNode,
    InputDecoration decoration = const InputDecoration(),
    super.keyboardType,
    super.textCapitalization,
    super.onTap,
    super.textInputAction,
    TextStyle? style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.textAlignVertical,
    super.autofocus,
    super.readOnly,
    super.toolbarOptions,
    bool super.showCursor = true,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    bool maxLengthEnforced = true,
    super.maxLengthEnforcement,
    int super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.onChanged,
    // VoidCallback? onTap,
    super.onEditingComplete,
    super.onFieldSubmitted,
    super.onSaved,
    super.validator,
    super.inputFormatters,
    super.enabled,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorColor,
    super.keyboardAppearance,
    super.scrollPadding,
    bool super.enableInteractiveSelection = true,
    super.selectionControls,
    super.buildCounter,
    // super.ignorePointers,
    super.scrollPhysics,
    super.autofillHints,
    super.autovalidateMode,
    ScrollController? scrollController,
    bool isShowCounter = true,
  }) : super(
          decoration: newInputDecoration?.copyWith(
            contentPadding: newContentPadding == null
                ? null
                : EdgeInsets.fromLTRB(
                    newContentPadding.left,
                    newContentPadding.top + (textSize * 2.3 / 11),
                    newContentPadding.right,
                    newContentPadding.bottom,
                  ),
            hintStyle: newInputDecoration.hintStyle != null
                ? newInputDecoration.hintStyle?.copyWith(
                    fontSize: GlobalVariable.ratioWidth(context) * textSize,
                  )
                : TextStyle(
                    fontSize: GlobalVariable.ratioWidth(context) * textSize,
                  ),
            // GoogleFonts.openSans(
            //     fontSize: GlobalVariable.ratioWidth(context) * textSize,
            //   )
            counterText: isShowCounter ? null : "",
          ),
          style: style == null
              ? GlobalVariable.getTextStyle(
                  TextStyle(
                    fontSize: GlobalVariable.ratioWidth(context) * textSize,
                  ),
                )
              : style.copyWith(
                  fontSize: GlobalVariable.ratioWidth(context) * textSize,
                ),
        );
}

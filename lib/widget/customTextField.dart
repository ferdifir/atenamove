import 'dart:async';

import 'package:atenamove/config/globalVariable.dart';
import 'package:atenamove/config/listColor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final BuildContext context;

  final InputDecoration newInputDecoration;

  final EdgeInsets? newContentPadding;

  final double textSize;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;

  final TextStyle? style;

  final StrutStyle? strutStyle;

  final TextAlign textAlign;

  final TextAlignVertical? textAlignVertical;

  final TextDirection? textDirection;

  final bool readonly;

  final ToolbarOptions? toolbaroptions;

  final bool showCursor;

  final bool autofocus;

  final String obscuringCharacter;

  final bool obscureText;

  final bool autocorrect;

  final SmartDashesType? smartDashesType;

  final SmartQuotesType? smartQuotesType;

  final bool enableSuggestions;

  final int? maxLines;

  final int? minLines;

  final bool expands;

  final int? maxLength;

  final MaxLengthEnforcement? maxLengthEnforcement;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String>? onSubmitted;

  final AppPrivateCommandCallback? onAppPrivateCommand;

  final List<TextInputFormatter>? inputFormatters;

  final bool enabled;

  final bool isDelayed;

  final double cursorWidth;

  final double? cursorHeight;

  final Radius? cursorRadius;

  final Color? cursorColor;

  final Brightness? keyboardAppearance;

  final EdgeInsets scrollPadding;

  final DragStartBehavior dragStartBehavior;

  final bool enableInteractiveSelection;

  final TextSelectionControls? selectionControls;
  final VoidCallback? onTap;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  CustomTextField({
    Key? key,
    required this.context,
    required this.newInputDecoration,
    this.newContentPadding,
    this.textSize = 14,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readonly = false,
    this.toolbaroptions,
    this.showCursor = true,
    this.autofocus = false,
    this.obscuringCharacter = '*',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.isDelayed = false,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
    this.suffixIcon,
    this.preffixIcon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
// delayed textfield onchange
  Timer? _debounceTimer;
  void _onTextchanged(String value) {
    if (_debounceTimer != null && (_debounceTimer?.isActive ?? false)) (_debounceTimer?.cancel());
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (widget.onChanged != null) widget.onChanged!(value);
    });
  }

  @override
  void dispose() {
    if (_debounceTimer != null && (_debounceTimer?.isActive ?? false)) {
      _debounceTimer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: widget.key,
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: widget.newInputDecoration.copyWith(
        contentPadding: widget.newContentPadding == null
            ? null
            : EdgeInsets.fromLTRB(
                widget.newContentPadding!.left,
                widget.newContentPadding!.top,
                widget.newContentPadding!.right,
                widget.newContentPadding!.bottom,
              ), // EdgeInsets. fromLTRB
        hintStyle: widget.newInputDecoration.hintStyle != null
            ? widget.newInputDecoration.hintStyle?.copyWith(
                fontSize: GlobalVariable.ratioWidth(context) * widget.textSize,
              )
            : GlobalVariable.getTextStyle(
                TextStyle(
                  fontSize: GlobalVariable.ratioWidth(context) * widget.textSize,
                ),
              ),
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.preffixIcon,
        disabledBorder: widget.newInputDecoration.disabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(ListColor.neutral50),
                width: GlobalVariable.ratioWidth(context),
              ), // BorderSide
              borderRadius: BorderRadius.circular(
                GlobalVariable.ratioWidth(context) * 10,
              ),
            ),
        enabledBorder: widget.newInputDecoration.enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: (widget.controller != null && widget.controller!.text == "" ? const Color(ListColor.neutral50) : const Color(ListColor.neutral100)),
                width: GlobalVariable.ratioWidth(context) * 1.0,
              ), // BorderSide
              borderRadius: BorderRadius.circular(
                GlobalVariable.ratioWidth(context) * 6,
              ),
            ),
        border: widget.newInputDecoration.border ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(ListColor.neutral50),
                width: GlobalVariable.ratioWidth(context),
              ),
              borderRadius: BorderRadius.circular(
                GlobalVariable.ratioWidth(context) * 6,
              ),
            ),
        focusedBorder: widget.newInputDecoration.focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(ListColor.neutral100),
                width: GlobalVariable.ratioWidth(context) * 1.0,
              ),
              borderRadius: BorderRadius.circular(
                GlobalVariable.ratioWidth(context) * 6,
              ),
            ),
        errorBorder: widget.newInputDecoration.errorBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(ListColor.dangerMain),
                width: GlobalVariable.ratioWidth(context),
              ),
              borderRadius: BorderRadius.circular(
                GlobalVariable.ratioWidth(context) * 6,
              ),
            ),
        focusedErrorBorder: widget.newInputDecoration.focusedErrorBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(ListColor.dangerMain),
                width: GlobalVariable.ratioWidth(context) * 2.0,
              ),
              borderRadius: BorderRadius.circular(
                GlobalVariable.ratioWidth(context) * 6,
              ),
            ),
      ),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style == null
          ? GlobalVariable.getTextStyle(
              TextStyle(
                fontSize: GlobalVariable.ratioWidth(context) * 14,
              ),
            )
          : widget.style?.copyWith(
              fontSize: GlobalVariable.ratioWidth(context) * widget.textSize,
            ),
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readonly,
      toolbarOptions: widget.toolbaroptions,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      mouseCursor: widget.mouseCursor,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      restorationId: widget.restorationId,
    );
  }
}

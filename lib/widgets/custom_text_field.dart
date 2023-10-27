import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double? width;
  final String hintText;
  final Color? textColor;
  final BoxBorder? border;
  final bool horizontalPadding;
  final bool obscureText;
  final int? maxLines;
  final Color? bgColor;
  final Color? borderColor;
  final Color? hintcolor;
  final double verticalPadding;
  final double fontsize;
  final double borderRadius;
  final double? contentPadding;
  final double? height;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? headingText;
  final Function()? onTap;
  final Widget? suffix;
  final Widget? suffix2;
  final Widget? preffix;
  final String? prefixText;
  TextInputType? keyboardType;
  final bool enabled;
  final String? suffixText;
  final bool enableInteractiveSelection;
  final bool textalign;
  final bool? autofocus;
  final FocusNode? focusNode;
  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.border,
    this.borderColor,
    this.maxLines,
    this.autofocus=false,
    this.preffix,
    this.height,
    this.contentPadding,
    this.horizontalPadding = false,
    this.obscureText = false,
    this.bgColor ,
    this.hintcolor ,
    this.verticalPadding=0,
    this.fontsize = 15,
    this.borderRadius = 10,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.headingText='',
    this.enabled = true,
    this.suffix,
    this.suffix2,
    this.suffixText,
    this.textColor,
    this.prefixText,
    this.focusNode,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.textalign = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50 ,
      width:width ?? MediaQuery.of(context).size.width,
      // margin: EdgeInsets.symmetric(horizontal: horizontalPadding ? 16 : 0, vertical: 0),
      decoration: BoxDecoration(
        color:  bgColor,
        border:  border,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: headingText != null ? null : EdgeInsets.symmetric(
          horizontal: 16, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if(headingText != null)
          //   Column(
          //     children: [
          //       ParagraphText(headingText!, fontWeight: FontWeight.w600,
          //         fontSize: 14,
          //         fontFamily: 'poppins',
          //         color: textColor?? MyColors.blackColor,),
          //       // vSizedBox10,
          //     ],
          //   ),


          GestureDetector(
            onTap: onTap,

            child: Container(
              height: height?? 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: bgColor?? Theme.of(context).colorScheme.white,
                  border:  Border.all(color: borderColor??  Theme.of(context).colorScheme.lightWhite,)
              ),
              child: Stack(
                children: [
                  TextField(
                    cursorColor:  Theme.of(context).colorScheme.fontColor,
                    maxLines: maxLines ?? 1,
                    focusNode: focusNode,
                    textAlign: textalign ? TextAlign.center : TextAlign.left,
                    controller: controller,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    style: TextStyle(color: textColor, fontSize: fontsize),
                    autofocus: autofocus!,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.done,
                    enableInteractiveSelection: true,
                    enabled: enabled,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:  BorderSide(color: borderColor?? Colors.transparent, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: borderColor?? Colors.transparent, width: 0.0),
                      ),
                      suffix: suffix,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: contentPadding ?? 14, horizontal: 20),
                      suffixStyle: TextStyle(
                          fontSize: 16
                      ),
                      prefixIcon: preffix,
                      isDense: true,
                      hintText: hintText,
                      suffixText: suffixText,
                      prefixText: prefixText,
                      prefixStyle: TextStyle(
                          fontSize: 16
                      ),
                      hintStyle: TextStyle(
                          color: hintcolor??  Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'poppins'
                      ),
                      labelStyle: TextStyle(
                          color:   Theme.of(context).colorScheme.fontColor,
                          fontSize: 16,
                          fontFamily: 'poppins'
                      ),
                      // border: headingText != null ? null : InputBorder.none,
                      errorText: errorText,
                    ),
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    onTap: onTap,
                  ),
                  Positioned(
                      right: 15,
                      top: 10,
                      child: suffix2 ?? Container()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

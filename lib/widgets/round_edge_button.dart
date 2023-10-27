import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RoundEdgedButton extends StatelessWidget {
  final double? height;
  final Color? color;
  final Color? border_color;
  final Color? loaderColor;
  final String text;
  final String fontfamily;
  final Function()? onTap;
  final double horizontalMargin;
  final double verticalPadding;
  final double verticalMargin;
  final bool isSolid;
  final Color? textColor;
  final double? borderRadius;
  final bool isBold;
  final double? fontSize;
  final double? width;
  final double? leftTextPadding;
  final double? rightTextPadding;
  final double? iconSize;
  final String? icon;
  final bool showGradient;
  final bool isLoad;
  final  FontWeight?  fontWeight;

  const RoundEdgedButton(
      {Key? key,
        this.color ,
        this.border_color ,
        this.loaderColor ,
        required this.text,
        this.fontfamily = 'poppins',
        this.onTap,
        this.horizontalMargin=0,
        this.textColor,
        this.iconSize,
        this.borderRadius,
        this.isBold = false,
        this.verticalMargin = 12,
        this.verticalPadding = 0,
        this.width,
        this.isLoad=false,
        this.fontSize=16,
        this.icon,
        this.leftTextPadding,
        this.rightTextPadding,
        this.showGradient = false,
        this.height=55,
        this.fontWeight= FontWeight.w600,
        this.isSolid=true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isLoad == true) ? null : onTap,
      child: Stack(
        children: [
          Container(
              height: height,
              margin: EdgeInsets.symmetric(
                  horizontal: horizontalMargin, vertical: verticalMargin),
              width: width ?? (MediaQuery
                  .of(context)
                  .size
                  .width),
              padding: EdgeInsets.symmetric(
                  horizontal: 8, vertical: verticalPadding),
              decoration: BoxDecoration(
                color: color ??  Theme.of(context).colorScheme.blackTxtColor,
                gradient: showGradient ? LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xfff02321),
                    Color(0xff781211),
                  ],
                ) : null,
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                border:  Border.all(color: border_color ??  Theme.of(context).colorScheme.blackTxtColor,),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(icon != null)
                    Image.asset(icon!, height: iconSize?? 35,),
                  if(icon != null)
                    SizedBox(width: leftTextPadding),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor ?? Theme.of(context).colorScheme.fontColor,
                      fontSize: fontSize ?? 13,
                      fontWeight: fontWeight,                        fontFamily: fontfamily,
                    ),
                  ),

                  if(icon != null)
                    SizedBox(width: rightTextPadding),

                  if(isLoad == true)
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                        CupertinoActivityIndicator(radius: 15, color: loaderColor,)
                      ],
                    )


                ],
              )
          ),
        ],
      ),
    );
  }
}
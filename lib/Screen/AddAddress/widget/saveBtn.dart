import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

class SaveButtonWidget extends StatelessWidget {
  String title;
  VoidCallback? onBtnSelected;
  Color? color;
  SaveButtonWidget({
    Key? key,
    this.onBtnSelected,
    this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: InkWell(
              onTap: onBtnSelected,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  // gradient: const LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [colors.grad1Color, colors.grad2Color],
                  //   stops: [0, 1],
                  // ),
                  borderRadius: BorderRadius.circular(circularBorderRadius10),
                ),
                height: 45.0,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: colors.whiteTemp,
                      fontSize: textFontSize16,
                      fontFamily: 'ubuntu',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

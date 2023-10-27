import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Helper/String.dart';
import '../../../Model/Order_Model.dart';
import '../../Language/languageSettings.dart';

getPlaced(String pDate, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
       Icon(
        Icons.circle,
        color:Theme.of(context).colorScheme.fontColor,
        size: 15,
      ),
      Container(
        margin: const EdgeInsetsDirectional.only(start: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTranslated(context, 'ORDER_NPLACED')!,
              style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
            ),
            Text(
              pDate,
              style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
            ),
          ],
        ),
      ),
    ],
  );
}

getProcessed(String? prDate, String? cDate, BuildContext context) {
  return cDate == null
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 2,
                    color: prDate == null ? Colors.grey : Theme.of(context).colorScheme.fontColor,
                  ),
                ),
                Icon(
                  Icons.circle,
                  color: prDate == null ? Colors.grey : Theme.of(context).colorScheme.fontColor,
                  size: 15,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context, 'ORDER_PROCESSED')!,
                    style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                  ),
                  Text(
                    prDate ?? ' ',
                    style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                  ),
                ],
              ),
            ),
          ],
        )
      : prDate == null
          ? Container()
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    SizedBox(
                      height: 30,
                      child: VerticalDivider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.fontColor,
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      color:Theme.of(context).colorScheme.fontColor,
                      size: 15,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, 'ORDER_PROCESSED')!,
                        style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                      ),
                      Text(
                        prDate,
                        style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                      ),
                    ],
                  ),
                ),
              ],
            );
}

getShipped(
  String? sDate,
  String? cDate,
  BuildContext context,
) {
  return cDate == null
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 2,
                    color: sDate == null ? Colors.grey : Theme.of(context).colorScheme.fontColor,
                  ),
                ),
                Icon(
                  Icons.circle,
                  color: sDate == null ? Colors.grey :Theme.of(context).colorScheme.fontColor,
                  size: 15,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context, 'ORDER_SHIPPED')!,
                    style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    sDate ?? ' ',
                    style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                  ),
                ],
              ),
            ),
          ],
        )
      : sDate == null
          ? Container()
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children:  [
                    SizedBox(
                      height: 30,
                      child: VerticalDivider(
                        thickness: 2,
                        color:Theme.of(context).colorScheme.fontColor,
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      color:Theme.of(context).colorScheme.fontColor,
                      size: 15,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, 'ORDER_SHIPPED')!,
                        style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        sDate,
                        style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                      ),
                    ],
                  ),
                ),
              ],
            );
}

getDelivered(
  String? dDate,
  String? cDate,
  BuildContext context,
) {
  return cDate == null
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 2,
                    color: dDate == null ? Colors.grey : Theme.of(context).colorScheme.fontColor,
                  ),
                ),
                Icon(
                  Icons.circle,
                  color: dDate == null ? Colors.grey : Theme.of(context).colorScheme.fontColor,
                  size: 15,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context, 'ORDER_DELIVERED')!,
                    style:  TextStyle(fontSize: textFontSize8, color: Theme.of(context).colorScheme.fontColor,),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    dDate ?? ' ',
                    style:  TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize: textFontSize8),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        )
      : Container();
}

getCanceled(String? cDate, BuildContext context) {
  return cDate != null
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children:  [
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 2,
                    color: Theme.of(context).colorScheme.fontColor,
                  ),
                ),
                Icon(
                  Icons.cancel_rounded,
                  color: Theme.of(context).colorScheme.fontColor,
                  size: 15,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context, 'ORDER_CANCLED')!,
                    style:  TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize: textFontSize8),
                  ),
                  Text(
                    cDate,
                    style:  TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize: textFontSize8),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        )
      : Container();
}

getReturned(
  OrderItem item,
  String? rDate,
  OrderModel model,
  BuildContext context,
) {
  return item.listStatus!.contains(RETURNED)
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children:  [
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    thickness: 2,
                    color: Theme.of(context).colorScheme.fontColor,
                  ),
                ),
                Icon(
                  Icons.cancel_rounded,
                  color: Theme.of(context).colorScheme.fontColor,
                  size: 15,
                ),
              ],
            ),
            Container(
              margin:  EdgeInsetsDirectional.only(start: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context, 'ORDER_RETURNED')!,
                    style:  TextStyle(fontSize: textFontSize8 , color: Theme.of(context).colorScheme.fontColor,),
                  ),
                  Text(
                    rDate ?? ' ',
                    style:  TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize: textFontSize8),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        )
      : Container();
}

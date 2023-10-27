import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';
import '../Helper/routes.dart';
import '../Provider/UserProvider.dart';
import '../Screen/Cart/Cart.dart';
import '../Screen/Cart/Widget/clearTotalCart.dart';
import 'desing.dart';
import '../Screen/Language/languageSettings.dart';

getAppBar(
  String title,
  BuildContext context,
  Function setState,
    bool isFromDashboard,
) {
  return AppBar(
    titleSpacing: 0,
    backgroundColor: Theme.of(context).colorScheme.white,
    leading:
    isFromDashboard == true? Container() :
    Builder(
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(circularBorderRadius4),
            onTap: () => Navigator.of(context).pop(),
            child:  Center(
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Theme.of(context).colorScheme.txtColor,

              ),
            ),
          ),
        );
      },
    ),
    title: Text(
      title,
      style:  TextStyle(
        color: Theme.of(context).colorScheme.txtColor,
        fontWeight: FontWeight.normal,
        fontFamily: 'ubuntu',
      ),
    ),
    actions: <Widget>[
      // title == getTranslated(context, 'FAVORITE')
      //     ? Container()
      //     : IconButton(
      //         padding: const EdgeInsets.all(0),
      //         icon: SvgPicture.asset(
      //           DesignConfiguration.setSvgPath('desel_fav'),
      //           color: Theme.of(context).colorScheme.txtColor,
      //         ),
      //         onPressed: () {
      //           Routes.navigateToFavoriteScreen(context);
      //         },
      //       ),
      Selector<UserProvider, String>(
        builder: (context, data, child) {
          return IconButton(
            icon: Stack(
              children: [
                Center(
                  child: SvgPicture.asset(
                    DesignConfiguration.setSvgPath('appbarCart'),
                    color: Theme.of(context).colorScheme.txtColor,
                  ),
                ),
                (data.isNotEmpty && data != '0')
                    ? Positioned(
                        bottom: 20,
                        right: 0,
                        child: Container(
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.txtColor,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Text(
                                data,
                                style:  TextStyle(
                                  fontSize: textFontSize10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ubuntu',
                                  color: Theme.of(context).colorScheme.blackTxtColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            onPressed: () {
              cartTotalClear(context);
              Navigator.push(context, CupertinoPageRoute(
                  builder: (context) => const Cart(fromBottom: false,),)).then((value) {setState;},);
            },
          );
        },
        selector: (_, HomePageProvider) => HomePageProvider.curCartCount,
      )
    ],
  );
}

getSimpleAppBar(
  String title,
  BuildContext context,
) {
  return AppBar(
    titleSpacing: 0,
    backgroundColor: Theme.of(context).colorScheme.white,
    leading: Builder(
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(circularBorderRadius4),
            onTap: () => Navigator.of(context).pop(),
            child:  Center(
              child: Icon(
                Icons.arrow_back_ios_rounded,
               color: Theme.of(context).colorScheme.txtColor,

            ),
            ),
          ),
        );
      },
    ),
    title: Text(
      title,
      style:  TextStyle(
        color: Theme.of(context).colorScheme.txtColor,
        fontWeight: FontWeight.normal,
        fontFamily: 'ubuntu',
      ),
    ),
  );
}

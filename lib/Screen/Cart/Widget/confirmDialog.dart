import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Provider/promoCodeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Model/Section_Model.dart';
import '../../../Provider/CartProvider.dart';
import '../../../widgets/desing.dart';
import '../../Language/languageSettings.dart';

class GetContent extends StatelessWidget {
  const GetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SectionModel> tempCartListForTestCondtion =
        context.read<CartProvider>().cartList;

    List prom_id=[];
    if(context.read<PromoCodeProvider>().validateProRes != null)
      for(int i=0; i<context.read<PromoCodeProvider>().validateProRes?['data'][0]['discounts'].length; i++) {
        prom_id.add(context.read<PromoCodeProvider>().validateProRes?['data'][0]['discounts'][i]['product_id']);
        print("prom_id__________$prom_id");
      }

    // if(context.read<CartProvider>().cartList != null)
    double sub_total=0;
    int j=0;
    List<SectionModel> cartList = context.read<CartProvider>().cartList;
    print("cartList$cartList");

    for(int index=0; index<context.read<CartProvider>().cartList.length; index++) {
      sub_total += (((double.parse(cartList[index].singleItemNetAmount!)) * double.parse(cartList[index].qty!)) + (((double.parse(cartList[index].singleItemTaxAmount!)) * double.parse(cartList[index].qty!))))!;


      j = prom_id.indexWhere((element) => element.contains(cartList[index].id));
    }

      return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
            child: Text(
              getTranslated(context, 'CONFIRM_ORDER')!,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.fontColor,
                    fontFamily: 'ubuntu',
                  ),
            )),
        Divider(color: Theme.of(context).colorScheme.lightBlack),

          Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       getTranslated(context, 'SUBTOTAL')!,
              //       style: Theme.of(context).textTheme.subtitle2!.copyWith(
              //             color: Theme.of(context).colorScheme.lightBlack2,
              //             fontFamily: 'ubuntu',
              //           ),
              //     ),
              //     Text(
              //       DesignConfiguration.getPriceFormat(
              //           context, context.read<CartProvider>().oriPrice)!,
              //       style: Theme.of(context).textTheme.subtitle2!.copyWith(
              //             color: Theme.of(context).colorScheme.fontColor,
              //             fontWeight: FontWeight.bold,
              //             fontFamily: 'ubuntu',
              //           ),
              //     )
              //   ],
              // ),

                Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, 'SUBTOTAL')!,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).colorScheme.lightBlack2,
                        fontFamily: 'ubuntu',
                      ),
                    ),
                    Text(
                      "${sub_total}"  ,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ubuntu',
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, 'DELIVERY_CHARGE')!,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Theme.of(context).colorScheme.lightBlack2,
                          fontFamily: 'ubuntu',
                        ),
                  ),
                  Text(
                    DesignConfiguration.getPriceFormat(
                        context, context.read<CartProvider>().deliveryCharge)!,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Theme.of(context).colorScheme.fontColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ubuntu',
                        ),
                  )
                ],
              ),
              // context.read<CartProvider>().isPromoValid!
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             getTranslated(context, 'PROMO_CODE_DIS_LBL')!,
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .subtitle2!
              //                 .copyWith(
              //                   color:
              //                       Theme.of(context).colorScheme.lightBlack2,
              //                   fontFamily: 'ubuntu',
              //                 ),
              //           ),
              //           Text(
              //             DesignConfiguration.getPriceFormat(
              //                 context, context.read<CartProvider>().promoAmt)!,
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .subtitle2!
              //                 .copyWith(
              //                   color: Theme.of(context).colorScheme.fontColor,
              //                   fontWeight: FontWeight.bold,
              //                   fontFamily: 'ubuntu',
              //                 ),
              //           )
              //         ],
              //       )
              //     : Container(),
              context.read<CartProvider>().isUseWallet!
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'WALLET_BAL')!,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                fontFamily: 'ubuntu',
                                color:
                                    Theme.of(context).colorScheme.lightBlack2,
                              ),
                        ),
                        Text(
                          DesignConfiguration.getPriceFormat(context,
                              context.read<CartProvider>().usedBalance)!,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                fontFamily: 'ubuntu',
                                color: Theme.of(context).colorScheme.fontColor,
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      ],
                    )
                  : Container(),


              // for(int index=0; index<context.read<CartProvider>().cartList.length; index++)
              if(j>0)
                if(prom_id.contains(cartList[j].productId))
                if(context.read<PromoCodeProvider>().validateProRes != null)
                  // for(int i=0; i<context.read<PromoCodeProvider>().validateProRes?['data'][0]['discounts'].length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Theme.of(context).colorScheme.lightBlack2,
                              fontFamily: 'ubuntu',
                            ),
                      ),
                      Text(
                        context.read<PromoCodeProvider>().validateProRes == null? "0":
                        "${double.parse(context.read<PromoCodeProvider>().validateProRes?['data'][0]['discounts'][j]['final_discount']).toStringAsFixed(2)}"  ,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.fontColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ubuntu',
                        ),
                      ),
                    ],
                  ),
                ),


              if(context.read<PromoCodeProvider>().validateProRes != null)
              // for(int i=0; i<context.read<PromoCodeProvider>().validateProRes?['data'][0]['discounts'].length; i++)
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, 'TOTAL_PRICE')!,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.lightBlack2,
                            fontFamily: 'ubuntu',
                          ),
                    ),
                    Text(
    context.read<PromoCodeProvider>().validateProRes == null?
    "$sub_total":
                      "${sub_total - double.parse(context.read<PromoCodeProvider>().validateProRes?['data'][0]['discounts'][j]['final_discount'])}",
                      // '${DesignConfiguration.getPriceFormat(context, context.read<CartProvider>().totalPrice)!} ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ubuntu',
                      ),
                    ),
                  ],
                ),
              ),

                if(context.read<PromoCodeProvider>().validateProRes == null)
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, 'TOTAL_PRICE')!,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.lightBlack2,
                            fontFamily: 'ubuntu',
                          ),
                    ),
                    Text(
                      "$sub_total",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ubuntu',
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: context.read<CartProvider>().noteController,
                  // style: Theme.of(context).textTheme.subtitle2,
                  style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.fontColor.withOpacity(0.1),
                    hintText: getTranslated(context, 'NOTE'),
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)),
                  ),
                ),
              ),
              tempCartListForTestCondtion[0].productType != 'digital_product'
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        controller:
                            context.read<CartProvider>().emailController,
                        style: TextStyle(color: Theme.of(context).colorScheme.fontColor ),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.fontColor.withOpacity(0.1),
                          hintText: 'Enter Email Id',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5) ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

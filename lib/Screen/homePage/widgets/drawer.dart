import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/AllBidProduct.dart';
import 'package:eshop_multivendor/Screen/AllNormalProduct.dart';
import 'package:eshop_multivendor/Screen/BuySellerList.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/Sell/Brand.dart';
import 'package:eshop_multivendor/Screen/Sell/bidding_Scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



Drawer get_drawer(BuildContext context,){

  return Drawer(
    backgroundColor: Theme.of(context).colorScheme.lightWhite,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),

        InkWell(
          onTap: (){
            Navigator.pop(context);
            ///buy normal products
            Navigator.push(context, CupertinoPageRoute(builder: (context)=>AllNormalProduct()));
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>BuySellerList()));
          },
          child: Container(
            color: Theme.of(context).colorScheme.white,
            padding: EdgeInsets.only(top: 5, left: 10,right: 10, bottom: 5),
            child: Row(
              children: [

                CircleAvatar(
                maxRadius: 25,
                child: Image.asset('assets/images/buy.png',color: Theme.of(context).colorScheme.txtColor,height:25,)),

                SizedBox(width: 20),

                Text("${getTranslated(context, 'BUY')!}", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.txtColor,),),

              ],
            ),
          ),
        ),

        SizedBox(height: 10),

        InkWell(
          onTap: (){
            Navigator.pop(context);
            ///buy bid products
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>BiddingProduct()));
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AllBidProduct()));
          },
          child: Container(
            color: Theme.of(context).colorScheme.white,
            padding: EdgeInsets.only(top: 5, left: 10,right: 10, bottom: 5),
            child: Row(
              children: [

                CircleAvatar(
                maxRadius: 25,
                child: Image.asset('assets/images/sell.png',color: Theme.of(context).colorScheme.txtColor,height:25,)),

                SizedBox(width: 20),

                Text("${getTranslated(context, 'Sell')}", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.txtColor,),),

              ],
            ),
          ),
        ),

        SizedBox(height: 10),

        InkWell(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>BrandScreen()));
          },
          child: Container(
            color: Theme.of(context).colorScheme.white,
            padding: EdgeInsets.only(top: 5, left: 10,right: 10, bottom: 5),
            child: Row(
              children: [

                CircleAvatar(
                maxRadius: 25,
                child: Image.asset('assets/images/CHECK.png',color: Theme.of(context).colorScheme.txtColor,height:25,)),

                SizedBox(width: 20),

                Text("Legit Check", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.txtColor,),),

              ],
            ),
          ),
        ),

        SizedBox(height: 10),
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            color: Theme.of(context).colorScheme.white,
            padding: EdgeInsets.only(top: 5, left: 10,right: 10, bottom: 5),
            child: Row(
              children: [

                CircleAvatar(
                maxRadius: 25,
                child: Image.asset('assets/images/TRADE.png',color: Theme.of(context).colorScheme.txtColor,height:25,)),

                SizedBox(width: 20),

                Text("Trade", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.txtColor,),),

              ],
            ),
          ),
        ),


      ],
    ),
  );

}
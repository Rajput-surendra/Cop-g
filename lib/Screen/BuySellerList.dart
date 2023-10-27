import 'dart:convert';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:http/http.dart'as http;
import 'package:eshop_multivendor/Models2/get_seller.dart';
import 'package:flutter/material.dart';
import '../Helper/Constant.dart';


class BuySellerList extends StatefulWidget {
  const BuySellerList({Key? key}) : super(key: key);

  @override
  State<BuySellerList> createState() => _BuySellerListState();
}

class _BuySellerListState extends State<BuySellerList> {

  GetSellerModel?getSellerModel;
  Future<void> getSeller() async {
    var headers = {
      'Cookie': 'ci_session=76d3bace1bcc4256c88658c9ee725bbd4165fc0d'
    };

    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get_sellers'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var Result = await response.stream.bytesToString();
      final finalResult = GetSellerModel.fromJson(json.decode(Result));
      setState(() {
        getSellerModel = finalResult;
      });
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  void initState() {
    getSeller();
    super.initState();
  }

  setStateNow() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.lightWhite,
      appBar: AppBar(
        leading: Container(
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
        ),
        title: Text(
         'Shop By Seller',
          style:  TextStyle(
            color: Theme.of(context).colorScheme.txtColor,
            fontWeight: FontWeight.normal,
            fontFamily: 'ubuntu',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.white,
        titleSpacing: 0,
      ),
      body:
      getSellerModel?.data!=null ?
      Container(
          height: MediaQuery.of(context).size.height/4.6,
          width: MediaQuery.of(context).size.width/1,
          child: ListView.builder(
            itemCount:getSellerModel?.data.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation:5,
                  margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network('${getSellerModel?.data[index].sellerProfile}',fit: BoxFit.cover,)),

                      SizedBox(width: 20,),

                      Text('${getSellerModel?.data[index].sellerName}',textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,style:
                      TextStyle(color:Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),)
                    ],
                  ),

                ),
              );
            },)
      ):
      Center(child: CircularProgressIndicator()),
    );
  }
}

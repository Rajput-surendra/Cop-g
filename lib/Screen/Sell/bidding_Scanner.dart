import 'dart:convert';

import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Helper/Color.dart';
import '../../Models2/Bidding_model.dart';
import '../../widgets/appBar.dart';
import '../Language/languageSettings.dart';
import 'package:http/http.dart'as http;

import 'BiddingProduct.dart';
import 'dart:convert' as convert;



class BiddingProduct extends StatefulWidget {
  const BiddingProduct({Key? key}) : super(key: key);

  @override
  State<BiddingProduct> createState() => _BiddingProductState();
}

class _BiddingProductState extends State<BiddingProduct> {

  @override
  void initState() {

    super.initState();
    getProductApi();
  }

  BiddingModel? biddingModel;

  getProductApi() async {

    Map<String, dynamic> params = {
      'user_id' : CUR_USERID,
    };

    var response = await http.post(Uri.parse('$baseUrl/bid_product'), body: params);
    var jsonResponse = convert.jsonDecode(response.body);
    print('____finalResult______${jsonResponse}_________');

    if (jsonResponse['error'] == false) {

      print("bid image==${imageUrl}${biddingModel?.data?[0].image}");

      var finalResult = BiddingModel.fromJson(jsonResponse);
      setState(() {
        biddingModel = finalResult;
      });
      print('____finalResult______${biddingModel?.data}_________');
    }


  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
          appBar: getSimpleAppBar(getTranslated(context, 'BIDDING_PRODUCT')!, context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              biddingModel?.data == null ? Center(child: CircularProgressIndicator()) : biddingModel!.data!.length == 0 ? Container(
                height: MediaQuery.of(context).size.height/1.2,
                  child: Center(child: Text("No Product found..!!", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,)))):Container(
                  height: MediaQuery.of(context).size.height/1,
                  child: ListView.builder(
                    itemCount: biddingModel?.data?.length,
                      itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BiddingProductConfirm(price: biddingModel!.data![index].price,productId: biddingModel!.data![index].productId,sellerId: biddingModel!.data![index].sellerId,)));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                         child: Column(
                           children: [
                             Row(
                               children: [
                                 Container(
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10)
                                   ),
                                   height: 100,
                                   width: 100,
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: ClipRRect(
                                       borderRadius: BorderRadius.circular(10),
                                       child:
                                       // Image.asset("assets/images/img_1.png",fit: BoxFit.fill ,)
                                       Image.network("${imageUrl}${biddingModel?.data?[index].logo}"),
                                     ),
                                   ),
                                 ),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text("${biddingModel?.data?[index].name}",style: TextStyle(color: Theme.of(context).colorScheme.fontColor,fontWeight: FontWeight.bold),),
                                     Text("₹ ${biddingModel?.data?[index].price}", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),)
                                   ],
                                 )
                               ],
                             )
                           ],
                         ),
                      ),
                    );
                  }),
                )
            ],
          ),
        ),
      ),
    );
  }
}

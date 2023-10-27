import 'dart:convert';

import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../../Helper/Color.dart';
import '../../Models2/Get_bid_list_model.dart';
import '../../widgets/appBar.dart';
import '../Language/languageSettings.dart';

class BiddingProductList extends StatefulWidget {
  const BiddingProductList({Key? key}) : super(key: key);

  @override
  State<BiddingProductList> createState() => _BiddingProductListState();
}

class _BiddingProductListState extends State<BiddingProductList> {
  @override
void initState() {
    // TODO: implement initState
    super.initState();
    getBiddinglistApi();
  }
  GetBidListModel? getBid;
  getBiddinglistApi() async {
    var headers = {
      'Cookie': 'ci_session=243276c20bd25294e5fba86415abc4097e582d6e; ekart_security_cookie=d56f1753070aa5a64f488d217693c18c'
    };
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/bid_product'));
    request.fields.addAll({
      'user_id':CUR_USERID.toString()
    });

    print("get_bid_params____${request.fields}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print("get_bid_res____${response}");

    if (response.statusCode == 200) {
    var result = await response.stream.bytesToString();
    var finalResult = GetBidListModel.fromJson(jsonDecode(result));
    setState(() {
      getBid =  finalResult;
    });
    }
    else {
    print(response.reasonPhrase);
    }

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppBar(getTranslated(context, 'BIDDING_PRODUCT_LIST')!, context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getBid?.data == null ? Center(child: CircularProgressIndicator()) : getBid!.data!.length == 0 ? Text("No Product found",
              style: TextStyle( color: Theme.of(context).colorScheme.fontColor,),):Container(
              height: MediaQuery.of(context).size.height/1,
              child: ListView.builder(
                  itemCount: getBid?.data?.length,
                  itemBuilder: (context,index){
                    return Card(
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
                                    Image.network("${imageUrl}${getBid?.data?[index].logo}"),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${getBid?.data?[index].name}",style: TextStyle(color: Theme.of(context).colorScheme.fontColor,fontWeight: FontWeight.bold),),
                                  Text("₹ ${getBid?.data?[index].price}", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,)),
                                  Text("${getBid?.data?[index].message}", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,)),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),


          ],
        ),
      ),

    );
  }
}

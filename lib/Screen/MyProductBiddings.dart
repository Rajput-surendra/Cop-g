import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:eshop_multivendor/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyProductBiddings extends StatefulWidget {
  Map product_detail;
  MyProductBiddings({Key? key, required this.product_detail}) : super(key: key);

  @override
  State<MyProductBiddings> createState() => _MyProductBiddingsState();
}

class _MyProductBiddingsState extends State<MyProductBiddings> {
  bool loading = false;
  bool loading2 = false;
  List biddingList = [];
  Map acceptBidData = {};
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool containsStatus1=false;


  productBiddingsApi() async {
    SettingProvider settingsProvider =
    Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> params = {
        'user_id': '${settingsProvider.userId}',
        'product_id': '${widget.product_detail['id'].toString()}',
      };

      print("my_product_biddingsApi_url_is__ ${my_product_biddingsApi} & params___ $params");

      final response = await http.post(my_product_biddingsApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        loading = false;
      });

      biddingList = [];
      if (jsonResponse['error'] == false) {
        biddingList = jsonResponse['data'];
        containsStatus1 = biddingList.any((item) => item['status'].toString() == '1');

        print("my_product_biddingsApi_response_is_______ ${biddingList}");
      }
    } else {
      toast('Something went wrong');
    }
  }
  acceptBidApi(index) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      setState(() {
        loading2 = true;
      });
      Map<String, dynamic> params = {
        'bid_id': '${biddingList[index]['id'].toString()}',
        'status': '1',
      };

      print("bids_status_changeApi_url_is__ ${bids_status_changeApi} & params___ $params");

      final response = await http.post(bids_status_changeApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        loading2 = false;
      });


      if (jsonResponse['error'] == false) {
        acceptBidData = jsonResponse['data'];
        toast('Accepted Successfully');
        print("bids_status_changeApi_response_is_______ ${acceptBidData}");
      } else {
        toast('Something went wrong');
      }
    } else {
      toast('Something went wrong');
    }
  }

  Future _refresh() async {
    await productBiddingsApi();
    setState(() {});
  }



  @override
  void initState() {
    productBiddingsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppBar(getTranslated(context, 'MY_PRODUCT_BIDDINGS')!, context),
      body: loading == true
          ? Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: Theme.of(context).colorScheme.fontColor,
          ))
          : RefreshIndicator(
        color: Theme.of(context).colorScheme.fontColor,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      imageUrl:
                      "${imageUrl}${widget.product_detail['image']}",
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.product_detail['name']}", style: TextStyle(fontSize: 16, color:  Theme.of(context).colorScheme.fontColor ),),
                          SizedBox(height: 5,),
                          Text("Rs. ${widget.product_detail['price']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor ),),
                          SizedBox(height: 15,),
                          Text("${widget.product_detail['description']}", style: TextStyle(fontSize: 14,  color:  Theme.of(context).colorScheme.fontColor ),),
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),
                    Divider(color:  Theme.of(context).colorScheme.white )
                  ],
                ),

                biddingList == null || biddingList.length == 0
                    ? Center(
                  child: Text(
                    "No Bids yet..!!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.fontColor,
                    ),
                  ),
                )
                    :
                ListView.builder(
                  itemCount: biddingList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15, bottom: index == biddingList.length - 1 ? 80 : 0, left: 20, right: 20),
                          child: Container(
                            // height: 100,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.white,
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,
                                  vertical: 15),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${biddingList[index]['username']}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${biddingList[index]['amount']}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 170,
                                    child: Wrap(
                                      children: [
                                        Text(
                                          '${biddingList[index]['message']}',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .fontColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),

                        Positioned(
                          right: 30,
                          top: 15,
                          child:
                          RoundEdgedButton(
                            text:  biddingList[index]['status'].toString() == "1"? 'Accepted' :
                            biddingList[index]['status'].toString() != "1" && containsStatus1==false? 'Accept' :  '',
                            width: biddingList[index]['status'].toString() != "1" && containsStatus1==false? 80:
                            biddingList[index]['status'].toString() == "1"? 80: 0,
                            height: biddingList[index]['status'].toString() != "1" && containsStatus1==false? 25:
                            biddingList[index]['status'].toString() == "1"? 25: 0,
                            fontSize: 12,
                            borderRadius: 5,
                            color: loading2==true? Theme.of(context).colorScheme.green.withOpacity(0.5) : Theme.of(context).colorScheme.green,
                            border_color: Theme.of(context).colorScheme.green,
                            onTap: () async{

                              if(containsStatus1){
                                toast('Bid already accepted');
                              }else{
                                await acceptBidApi(index);
                                productBiddingsApi();
                              }

                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}

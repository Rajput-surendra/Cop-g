import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/BidProductDetail.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/custom_text_field.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:eshop_multivendor/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;



class AllBidProduct extends StatefulWidget {
  const AllBidProduct({Key? key}) : super(key: key);

  @override
  State<AllBidProduct> createState() => _AllBidProductState();
}

class _AllBidProductState extends State<AllBidProduct> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  List bidProductList = [];
  List biddingList = [];
  bool loading = false;
  bool loading2 = false;
  int count =0;

  getBidProductApi() async {
    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> params = {
        'user_id': '${settingsProvider.userId}',
      };

      print("all_bid_productApi_url_is__ ${all_bid_productApi} & params___ $params");

      final response = await http.post(all_bid_productApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        loading = false;
      });

      bidProductList = [];
      if (jsonResponse['error'] == false) {
        bidProductList = jsonResponse['data'];

        bool allItemsHaveStatus1 = bidProductList.every((item) => item['endtimestatus'].toString() == '1');

        if (allItemsHaveStatus1) {
          bidProductList.clear();
        }

        print("all_bid_productApi_response_is_______  $allItemsHaveStatus1");
      } else {
        toast('Something went wrong');
      }
    } else {
      toast('Something went wrong');
    }
  }


  applyBidApi(int index, mysetState) async {

    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();

    if(double.parse(amountController.text) < double.parse(bidProductList[index]['price'])){
      toast('Minimum limit is ${bidProductList[index]['price']}');
    }else{
      if (isNetworkAvail) {
        mysetState(() {
          loading2 = true;
        });
        Map<String, dynamic> params = {
          'user_id': '${settingsProvider.userId}',
          'amount': amountController.text,
          'message': messageController.text,
          'seller_id': bidProductList[index]['seller_id'],
          'product_id': bidProductList[index]['id'],
        };

        print("apply_bid_productsApi_url_is__ ${apply_bid_productsApi} & params___ $params");

        final response = await http.post(apply_bid_productsApi, body: params);
        var jsonResponse = convert.jsonDecode(response.body);
        mysetState(() {
          loading2 = false;
        });

        if (jsonResponse['error'] == false) {
          toast('${jsonResponse['message']}');
          Navigator.pop(context);
          amountController.clear();
          messageController.clear();
          await getBidProductApi();
          setState(() {});
          print("apply_bid_productsApi_response_is_______ ${jsonResponse}");
        } else {
          Navigator.pop(context);
          amountController.clear();
          messageController.clear();
          toast('${jsonResponse['message']}');
        }
      } else {
        toast('Something went wrong');
      }
    }

  }

  Future _refresh() async {
    await getBidProductApi();
    setState(() {});
  }


  @override
  void initState() {
    getBidProductApi();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppBar(getTranslated(context, 'Sell')!, context),
      body: loading == true
          ? Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: Theme.of(context).colorScheme.fontColor,
          ))
          : bidProductList == null || bidProductList.length == 0
          ? Center(
        child: Text(
          getTranslated(context, 'No Data Found')!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
          ),
        ),
      )
          : RefreshIndicator(
        color: Theme.of(context).colorScheme.fontColor,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: ListView.builder(
              itemCount: bidProductList.length,
              itemBuilder: (context, index) {
                if(bidProductList[index]['endtimestatus'].toString() == "0" && bidProductList[index]['all_biddings'].isEmpty) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(context, CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            BidProductDetail(
                                prodDetail: bidProductList[index]),));
                      getBidProductApi();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 15,
                          bottom: index == bidProductList.length - 1
                              ? 80
                              : 0),
                      child: Container(
                        height: 120,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme
                              .of(context)
                              .colorScheme
                              .white,
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    height: 120,
                                    width: 120,
                                    imageUrl:
                                    "${imageUrl}${bidProductList[index]['image']}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${bidProductList[index]['name']}',
                                        style: TextStyle(
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .fontColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${bidProductList[index]['price']}',
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
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
                                              '${bidProductList[index]['description']}',
                                              style: TextStyle(
                                                color: Theme
                                                    .of(context)
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
                                ),


                              ],
                            ),

                            // biddingList?[index]['status'].toString() == "2"? Container(height: 10,):
                            Positioned(
                                right: 10,
                                child: RoundEdgedButton(
                                  text: 'Apply Bid',
                                  width: 60,
                                  height: 20,
                                  fontSize: 9,
                                  borderRadius: 5,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.05,
                                            right: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.05,
                                          ),
                                          child: StatefulBuilder(
                                              builder: (context,
                                                  dialog_setState) {
                                                return AlertDialog(
                                                  backgroundColor: Theme
                                                      .of(context)
                                                      .colorScheme
                                                      .lightWhite,
                                                  insetPadding: EdgeInsets.zero,
                                                  contentPadding: EdgeInsets
                                                      .zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                  content: Padding(
                                                    padding: EdgeInsets.all(
                                                        MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width * 0.05),
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width / 1.1,
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisSize: MainAxisSize
                                                              .min,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [

                                                                ///heading
                                                                Text(
                                                                  'Apply Bid',
                                                                  style: TextStyle(
                                                                    letterSpacing: 0.3,
                                                                    height: 1.5,
                                                                    fontSize: 18,
                                                                    color: Theme
                                                                        .of(
                                                                        context)
                                                                        .colorScheme
                                                                        .fontColor,
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment: Alignment
                                                                      .centerRight,
                                                                  child: InkWell(
                                                                      onTap: () =>
                                                                          Navigator
                                                                              .pop(
                                                                              context),
                                                                      child: Icon(
                                                                        CupertinoIcons
                                                                            .multiply,
                                                                        color: Theme
                                                                            .of(
                                                                            context)
                                                                            .colorScheme
                                                                            .fontColor,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(),
                                                            SizedBox(
                                                              height: 20,
                                                            ),

                                                            CustomTextField(
                                                                controller: amountController,
                                                                keyboardType: TextInputType
                                                                    .number,
                                                                hintText: 'Enter Bid Amount'),
                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            CustomTextField(
                                                                controller: messageController,
                                                                hintText: 'Enter Description'),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            RoundEdgedButton(
                                                              text: 'Apply Bid',
                                                              isLoad: loading2,
                                                              loaderColor:
                                                              Theme
                                                                  .of(context)
                                                                  .colorScheme
                                                                  .fontColor,
                                                              borderRadius: 10,
                                                              onTap: () async {
                                                                applyBidApi(
                                                                    index,
                                                                    dialog_setState);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                      },
                                    );
                                    print("Apply Bid successfully");
                                  },
                                )
                            )
                            //     : Positioned(
                            //   right: 10,
                            //   child: RoundEdgedButton(
                            //       text: 'Time Out',
                            //     width: 60,
                            //     height: 20,
                            //     fontSize: 9,
                            //     borderRadius: 5,
                            //     color: Theme.of(context).colorScheme.redDark,
                            //     border_color: Theme.of(context).colorScheme.redDark,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  );
                }else{
                  return  Center();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

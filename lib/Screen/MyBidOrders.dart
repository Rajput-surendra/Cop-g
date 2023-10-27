import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/BidOrderDetail.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/OrderDetail/OrderDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class MyBidOrders extends StatefulWidget {
  const MyBidOrders({Key? key}) : super(key: key);

  @override
  State<MyBidOrders> createState() => _MyBidOrdersState();
}

class _MyBidOrdersState extends State<MyBidOrders> {
  bool  loading = false;
  List OrderList = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();


  getOrderListApi() async {
    isNetworkAvail = await isNetworkAvailable();
    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);


    if (isNetworkAvail) {
      setState(() {
        loading = true;
      });

      Map<String, dynamic> params = {
        'user_id' : settingsProvider.userId.toString()
      };

      print("get_bid_ordersApi_url_is__ ${get_bid_ordersApi} & params___ $params");

      final response = await http.post(get_bid_ordersApi, body:params );
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        loading = false;
      });

      OrderList = [];
      if (jsonResponse['error'] == false) {
        OrderList = jsonResponse['data'];
        print("get_bid_ordersApi_response_is_______ ${OrderList}");
      } else {
        toast('Something went wrong');
      }
    } else {
      toast('Something went wrong');
    }
  }

  Future _refresh() async {
    await getOrderListApi();
    setState(() {});
  }

  @override
  void initState() {
    getOrderListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading == true
          ? Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: Theme.of(context).colorScheme.fontColor,
          ))
          : OrderList == null || OrderList.length == 0
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
              itemCount: OrderList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>BidOrderDetail(orderDetail: OrderList[index])));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 15,
                        bottom: index == OrderList.length - 1
                            ? 80
                            : 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.white,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 110,
                              width: 100,
                              imageUrl:
                              "${imageUrl}${OrderList[index]['image']}",
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
                                SizedBox(
                                  width: 200,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        "${OrderList[index]['product_name']}  ${DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.parse(OrderList[index]['created_at'].toString()))}",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 170,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        '${OrderList[index]['description']}',
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
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),

    );
  }
}

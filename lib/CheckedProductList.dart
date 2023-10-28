import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/MyProductBiddings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:eshop_multivendor/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CheckedProductList extends StatefulWidget {
  const CheckedProductList({Key? key}) : super(key: key);

  @override
  State<CheckedProductList> createState() => _CheckedProductListState();
}

class _CheckedProductListState extends State<CheckedProductList> {
  bool loading = false;
  List legitProductList = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future _refresh() async {
    await getLegitProdApi();
    setState(() {});
  }

  getLegitProdApi() async {
    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> params = {
        'user_id': '${settingsProvider.userId}',
      };

      print("get_legit_checkApi_url_is__ ${get_legit_checkApi} & params___ $params");

      final response = await http.post(get_legit_checkApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        loading = false;
      });

      legitProductList = [];
      if (jsonResponse['error'] == false) {
        legitProductList = jsonResponse['data'];
        print("get_legit_checkApi_response_is_______ ${legitProductList}");
      } else {
        toast('Something went wrong');
      }
    } else {
      toast('Something went wrong');
    }
  }

  @override
  void initState() {
    getLegitProdApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: getSimpleAppBar(getTranslated(context, 'checked_products')!, context),
      body: loading == true
          ? Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: Theme.of(context).colorScheme.fontColor,
          ))
          : legitProductList == null || legitProductList.length == 0
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
              itemCount: legitProductList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    // Navigator.push(context, CupertinoPageRoute(builder: (context)=>MyProductBiddings(product_detail: bidProductList[index])));
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15,
                            bottom: index == legitProductList.length - 1
                                ? 80
                                : 0),
                        child: Container(
                          height: 120,
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
                                  height: 120,
                                  width: 120,
                                  imageUrl:
                                  "${imageUrl}${legitProductList[index]['image'][0]}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                '${legitProductList[index]['product_name']}',
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
                      ),
                      Positioned(
                        right: 10,
                        top: 15,
                          child: RoundEdgedButton(
                            width: 70,
                            height: 30,
                            fontSize: 12,
                            borderRadius: 5,
                            text: legitProductList[index]['status'].toString() == "0"? 'Pending' : 'Approve',
                            color: legitProductList[index]['status'].toString() == "0"? Colors.orange : Colors.green,
                          )
                      )
                    ],
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

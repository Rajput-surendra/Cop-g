import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/routes.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Screen/Cart/Widget/confirmDialog.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/Payment/Payment.dart';
import 'package:eshop_multivendor/widgets/custom_text_field.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:eshop_multivendor/widgets/round_edge_button.dart';
import 'package:eshop_multivendor/widgets/security.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:mime/mime.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';



class BidProductDetail extends StatefulWidget {
  Map prodDetail;
  BidProductDetail({Key? key, required this.prodDetail}) : super(key: key);

  @override
  State<BidProductDetail> createState() => _BidProductDetailState();
}

class _BidProductDetailState extends State<BidProductDetail> {
  bool loading = false;
  bool loading2 = false;
  List biddingList = [];
  TextEditingController amountController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();


  applyBidApi(mysetState) async {

    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();

    if(double.parse(amountController.text) < double.parse(widget.prodDetail['price'])){
      toast('Minimum limit is ${widget.prodDetail['price']}');
    }else{
      if (isNetworkAvail) {
        mysetState(() {
          loading = true;
        });
        Map<String, dynamic> params = {
          'user_id': '${settingsProvider.userId}',
          'amount': amountController.text,
          'message': messageController.text,
          'seller_id': widget.prodDetail['seller_id'],
          'product_id': widget.prodDetail['id'],
        };

        print("apply_bid_productsApi_url_is__ ${apply_bid_productsApi} & params___ $params");

        final response = await http.post(apply_bid_productsApi, body: params);
        var jsonResponse = convert.jsonDecode(response.body);
        mysetState(() {
          loading = false;
        });

        if (jsonResponse['error'] == false) {
          toast('${jsonResponse['message']}');
          Navigator.pop(context);
          amountController.clear();
          messageController.clear();
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
  productBiddingsApi() async {
    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      setState(() {
        loading2 = true;
      });
      Map<String, dynamic> params = {
        'user_id': '${settingsProvider.userId}',
        'product_id': '${widget.prodDetail['id'].toString()}',
      };

      print("my_biddingsApi_url_is__ ${my_biddingsApi} & params___ $params");

      final response = await http.post(my_biddingsApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        loading2 = false;
      });

      biddingList = [];
      if (jsonResponse['error'] == false) {
        biddingList = jsonResponse['data'];
        print("my_biddingsApi_response_is_______ ${biddingList}");
      } else {
        // toast('Something went wrong');
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
      backgroundColor:  Theme.of(context).colorScheme.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      imageUrl:
                      "${imageUrl}${widget.prodDetail['image']}",
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.prodDetail['name']}", style: TextStyle(fontSize: 16, color:  Theme.of(context).colorScheme.fontColor ),),
                          SizedBox(height: 5,),
                          Text("Rs. ${widget.prodDetail['price']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor ),),
                          SizedBox(height: 15,),
                          Text("${widget.prodDetail['description']}", style: TextStyle(fontSize: 14,  color:  Theme.of(context).colorScheme.fontColor ),),
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),
                    Divider(color:  Theme.of(context).colorScheme.lightWhite )
                  ],
                ),


                Positioned(
                  left: 10,
                  top: 30,
                  child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child:  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.white,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.fontColor,
                    ),
                  ),
                ),)
              ],
            ),


            RefreshIndicator(
              color: Theme.of(context).colorScheme.fontColor,
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
              child: ListView.builder(
                itemCount: biddingList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);

                  return Padding(
                    padding: EdgeInsets.only(top: 15, bottom: index == biddingList.length - 1 ? 80 : 0, left: 20, right: 20),
                    child: Container(
                        // height: 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.lightWhite,
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,
                              vertical: 15),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 2,),
                                  Text(
                                    'Bidder Name:  ',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  Text(
                                    'Amount:  ',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Description:  ',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${settingsProvider.userName}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    '${biddingList[index]['amount']}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 5,),
                                  SizedBox(
                                    width: 200,
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
                            ],
                          ),
                        )
                    ),
                  );
                },
              ),
            ),
            )],
        ),
      ),
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child:
        loading2 == true?  Center(
            child: CupertinoActivityIndicator(
              radius: 15,
              color: Theme.of(context).colorScheme.fontColor,
            )):
        biddingList.length == 0 || biddingList == null ?  Container(
          height: 100,
          child: Column(
            children: [
              Center(
                child: Text(
                  getTranslated(context, 'No Data Found')!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.fontColor,
                  ),
                ),
              ),
              RoundEdgedButton(
                text: 'Apply Bid',
                isLoad: loading,
                loaderColor: Theme.of(context).colorScheme.fontColor,
                borderRadius: 10,
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: StatefulBuilder(builder: (context, dialog_setState) {
                          return AlertDialog(
                            backgroundColor: Theme.of(context).colorScheme.lightWhite,
                            insetPadding: EdgeInsets.zero,
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.05),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          ///heading
                                          Text(
                                            'Apply Bid',
                                            style: TextStyle(
                                              letterSpacing: 0.3,
                                              height: 1.5,
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .fontColor,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                                onTap: () => Navigator.pop(context),
                                                child: Icon(
                                                  CupertinoIcons.multiply,
                                                  color: Theme.of(context)
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
                                          keyboardType: TextInputType.number,
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
                                        isLoad: loading,
                                        loaderColor:
                                        Theme.of(context).colorScheme.fontColor,
                                        borderRadius: 10,
                                        onTap: () async {
                                          await applyBidApi(dialog_setState);
                                          productBiddingsApi();
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
                },
              )
            ],
          ),
        ):
        biddingList?[0]['status'].toString() == "1"?
        RoundEdgedButton(
          text: 'Payment',
          borderRadius: 10,
          onTap: () async{
           await Navigator.push(context, CupertinoPageRoute(builder: (BuildContextcontext) => Payment()));
           confirmDialog();
          },
        ):
        biddingList?[0]['status'].toString() == "2"? Container(height: 10,):
        Container(height: 10,),
      ),
    );
  }

  double delivery_charge=0;
  String orderId = '';
  String razorpayOrderId = '';
  String? rozorpayMsg;
  String myaddressId='';
  Razorpay? _razorpay;
  bool _placeOrder = true;
  List myaddressList = [];
  TextEditingController noteController= TextEditingController();

  void confirmDialog() {
    showGeneralDialog(
      barrierColor: Theme.of(context).colorScheme.lightWhite,
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              elevation: 2.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius5),
                ),
              ),
              content: Column(
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
                                '${biddingList[0]['amount']}',
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
                              '$delivery_charge',
                              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ubuntu',
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context, 'TOTAL_LBL')!,
                              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.lightBlack2,
                                fontFamily: 'ubuntu',
                              ),
                            ),
                            Text(
                              '${double.parse(biddingList[0]['amount']) + delivery_charge}',
                              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ubuntu',
                              ),
                            )
                          ],
                        ),

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



                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller:noteController,
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
                        // tempCartListForTestCondtion[0].productType != 'digital_product'
                        //     ? Container()
                        //     : Container(
                        //   padding: const EdgeInsets.symmetric(vertical: 5),
                        //   child: TextField(
                        //     controller:
                        //     context.read<CartProvider>().emailController,
                        //     style: TextStyle(color: Theme.of(context).colorScheme.fontColor ),
                        //     decoration: InputDecoration(
                        //       contentPadding:
                        //       const EdgeInsets.symmetric(horizontal: 10),
                        //       border: InputBorder.none,
                        //       filled: true,
                        //       fillColor: Theme.of(context).colorScheme.fontColor.withOpacity(0.1),
                        //       hintText: 'Enter Email Id',
                        //       hintStyle: TextStyle(color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5) ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    getTranslated(context, 'CANCEL')!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5) ,
                      fontSize: textFontSize15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ubuntu',
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    getTranslated(context, 'DONE')!,
                    style:  TextStyle(
                      color: Theme.of(context).colorScheme.fontColor ,
                      fontSize: textFontSize15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ubuntu',
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    loading=true;
                    setState(() {});
                    placeOrderApi();

                  },
                )
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
    );
  }

  placeOrderApi() async{
    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();
    await getAddressIdApi();

    if (isNetworkAvail) {

      Map<String, dynamic> params = {
        'user_id': '${settingsProvider.userId}',
        'product_id': '${widget.prodDetail['id']}',
        'mobile': '${settingsProvider.mobile}',
        'product_price': '${widget.prodDetail['price']}',
        'final_price': '${biddingList[0]['amount']}',
        'address_id': '${myaddressId}',
        'payment_method': 'RazorPay',
        'order_note': noteController.text,
      };

      print("bid_place_orderApi_url_is__ ${bid_place_orderApi} & params___ $params");

      final response = await http.post(bid_place_orderApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['error'] == false) {
        orderId = jsonResponse['data']['id'];
        // toast('${jsonResponse['message']}');
        razorpayPayment(orderId, jsonResponse['message']);

        print("bid_place_orderApi_response_is_______ ${ jsonResponse['data']}");

      } else {
        toast('${jsonResponse['message']}');
      }
    } else {
      toast('Something went wrong');
    }
  }

  getAddressIdApi() async{
    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {

      Map<String, dynamic> params = {
        'user_id': '${settingsProvider.userId}',
      };

      print("getAddressApi_url_is__ ${getAddressApi} & params___ $params");

      final response = await http.post(getAddressApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);


      if (jsonResponse['error'] == false) {
        myaddressList = jsonResponse['data'];

        if(myaddressList.length != 0 || myaddressList != null)
        myaddressId = myaddressList[0]['id'].toString();

        print("getAddressApi_response_is_______ ${myaddressList}");
      } else {
        toast('Something went wrong');
      }
    } else {
      toast('Something went wrong');
    }
  }

  razorpayPayment(
      String orderID,
      String? msg,
      ) async {
    SettingProvider settingsProvider =
    Provider.of<SettingProvider>(context, listen: false);

    String? contact = settingsProvider.mobile;
    String? email = settingsProvider.email;
    // String amt = ((context.read<CartProvider>().totalPrice.round()) * 100).toStringAsFixed(2);

    if (contact != '' && email != '') {
      // context.read<CartProvider>().setProgress(true);
      //
      // context.read<CartProvider>().checkoutState!(() {});
      try {
        //create a razorpayOrder for capture payment automatically
        var response = await ApiBaseHelper().postAPICall(createRazorpayOrder, {'order_id': orderID});
        var razorpayOrderID = response['data']['id'];
        var options = {
          KEY: context.read<CartProvider>().razorpayId,
          AMOUNT: '${biddingList[0]['amount']}00',
          NAME: settingsProvider.userName,
          'prefill': {CONTACT: contact, EMAIL: email, 'Order Id': orderID},
          'order_id': razorpayOrderID,
        };

        print("razor_pay_request__ $options");

        razorpayOrderId = orderID;
        rozorpayMsg = msg;
        _razorpay = Razorpay();
        _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

        _razorpay!.open(options);
      } catch (e) {}
    } else {
      if (email == '') {
        toast(getTranslated(context, 'emailWarning')!);
      } else if (contact == '') {
        toast(getTranslated(context, 'phoneWarning')!);
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Map<String, dynamic> result =
    await updateOrderStatus(orderID: orderId, status: PLACED);
    if (!result['error']) {
      await addTransaction(response.paymentId, orderId, SUCCESS, rozorpayMsg, true);
    } else {
      toast('${result['message']}');
    }
    if (mounted) {
      context.read<CartProvider>().setProgress(false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    var getdata = json.decode(response.message!);
    String errorMsg = getdata['error']['description'];
    toast(errorMsg);
    deleteOrder(orderId);
    if (mounted) {
      context.read<CartProvider>().checkoutState!(
            () {
          _placeOrder = true;
        },
      );
    }
    context.read<CartProvider>().setProgress(false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    deleteOrder(orderId);
  }

  Future<Map<String, dynamic>> updateOrderStatus(
      {required String status, required String orderID}) async {
    var parameter = {ORDER_ID: orderID, STATUS: status};
    var result = await ApiBaseHelper().postAPICall(updateOrderApi, parameter);
    return {'error': result['error'], 'message': result['message']};
  }

  Future<void> addTransaction(
      String? tranId,
      String orderID,
      String? status,
      String? msg,
      bool redirect,
      ) async {
    try {
      var parameter = {
        USER_ID: CUR_USERID,
        ORDER_ID: orderID,
        TYPE: context.read<CartProvider>().payMethod,
        TXNID: tranId,
        AMOUNT: context.read<CartProvider>().totalPrice.toString(),
        STATUS: status,
        MSG: msg ?? '$status the payment'
      };
      apiBaseHelper.postAPICall(addTransactionApi, parameter).then(
            (getdata) {
          bool error = getdata['error'];
          String? msg1 = getdata['message'];

          if (!error) {
            if (redirect) {
              context.read<UserProvider>().setCartCount('0');
              // clearAll();
              Routes.navigateToOrderSuccessScreen(context);
            }
          } else {
            toast(msg1!);
          }
        },
        onError: (error) {
          toast(error.toString());
        },
      );
    } on TimeoutException catch (_) {
      toast(getTranslated(context, 'somethingMSg')!);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      var parameter = {
        ORDER_ID: orderId,
      };

      http.Response response =
      await post(deleteOrderApi, body: parameter, headers: headers)
          .timeout(const Duration(seconds: timeOut));

      if (mounted) {
        setState(() {});
      }

      Navigator.of(context).pop();
    } on TimeoutException catch (_) {
      toast(getTranslated(context, 'somethingMSg')!,);

      setState(() {});
    }
  }
}

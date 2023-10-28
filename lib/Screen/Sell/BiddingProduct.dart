import 'dart:convert';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/appBar.dart';
import '../Language/languageSettings.dart';
import 'package:http/http.dart'as http;

class BiddingProductConfirm extends StatefulWidget {
   BiddingProductConfirm({Key? key,this.price,this.productId,this.sellerId}) : super(key: key);
  String? price,sellerId,productId;

  @override
  State<BiddingProductConfirm> createState() => _BiddingProductConfirmState();
}

class _BiddingProductConfirmState extends State<BiddingProductConfirm> {
  addBiddingProductApi() async {
    setState(() {
      isloader = true;
    });
    var headers = {
      'Cookie': 'ci_session=0ef5ed217b3f4cedcde77d2bb4feca381a5f7938; ekart_security_cookie=d56f1753070aa5a64f488d217693c18c'
    };
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/user_bid_product'));
    request.fields.addAll({
      'user_id': CUR_USERID.toString(),
      'seller_id': widget.sellerId.toString(),
      'product_id': widget.productId.toString(),
      'amount': widget.price.toString(),
      'message':messageC.text
    });
  print('____request.fields______${request.fields}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
     var result  = await response.stream.bytesToString();
     var finalResult =  jsonDecode(result);
     setSnackbar(finalResult['message'], context);
     Navigator.pop(context);
     messageC.clear();
     setState(() {
       isloader = false;
     });
    }
    else {
      setState(() {
        isloader = false;
      });
    print(response.reasonPhrase);
    }

  }
  bool isloader = false;
  TextEditingController messageC =  TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomSheet: InkWell(
        onTap: (){
          if(_formKey.currentState!.validate()){
            addBiddingProductApi();
          }else{
            setSnackbar("field is required", context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.white,),
            child:  Center(child:isloader ? Center(child: CircularProgressIndicator()):Text("Bidding Product",style: TextStyle(color: colors.whiteTemp),) ),
          ),
        ),
      ),
      backgroundColor: colors.primary,
      //Theme.of(context).colorScheme.blackTxtColor,
      appBar: getSimpleAppBar(getTranslated(context, 'BIDDING_PRODUCT')!, context),
      body: Form(
        key:_formKey ,
            child: Column(
          children: [
            SizedBox(height: 20,),
             Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
               decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.white,
                 borderRadius: BorderRadius.circular(10)
               ),
               child: TextFormField(
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Please enter amount';
                   }
                   return null;
                 },
                 controller: messageC,
                 decoration: InputDecoration(
                   hintStyle: TextStyle(color: Theme.of(context).colorScheme.fontColor,),
                   contentPadding: EdgeInsets.only(left: 10),
                   hintText: 'Amount',
                   border: InputBorder.none

                 ),
               ),
             ),
           ),
            SizedBox(height: 80,),

          ],
        ),
      ),
    );
  }
}

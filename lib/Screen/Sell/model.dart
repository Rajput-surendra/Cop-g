import 'dart:convert';

import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Screen/Sell/shoes_details_screen.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;

import '../../Helper/Color.dart';
import '../../Models2/Get_sub_model.dart';
import '../../widgets/appBar.dart';
import '../Language/languageSettings.dart';

class ModelScreen extends StatefulWidget {
 ModelScreen({Key? key,this.catID, required this.catImage}) : super(key: key);
  String? catID;
  String? catImage;

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  bool  loading = false;
  List modelList=[];

  @override
  void initState() {
    super.initState();
    getProductsApi();
  }

  getProductsApi() async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      setState(() {
        loading = true;
      });

      Map params ={
        'category_id': widget.catID.toString()
      };

      print("getProductApi_is__ ${getProductApi} & params___$params ");

      final response = await http.post(getProductApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {loading = false;});

      modelList = [];
      if (jsonResponse['error'] == false) {
        modelList = jsonResponse['data'];
        print("getProductApi_response_is_______ ${modelList}");
      } else {
        toast('${jsonResponse['message']}');
      }
    } else {
      toast('Something went wrong');
    }
    // var headers = {
    //   'Cookie': 'ci_session=dff198e1be2c178b137c620053b701a4d243d24a; ekart_security_cookie=55f826ca73b59ac7f1138d3fcac56523'
    // };
    // var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/get_categories'));
    // request.fields.addAll({
    //   'id': widget.catID.toString()
    // });
    // print('____request.fields______${request.fields}_________');
    // request.headers.addAll(headers);
    // http.StreamedResponse response = await request.send();
    // if (response.statusCode == 200) {
    //   var result = await response.stream.bytesToString();
    //   var finalResult =GetSubModel.fromJson(jsonDecode(result));
    //   setState(() {
    //     getSubModel =  finalResult;
    //   });
    //   print("model screen response ============= $getSubModel");
    //
    // }
    // else {
    // print(response.reasonPhrase);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.lightWhite,
        // appBar: getSimpleAppBar(getTranslated(context, 'MODEL')!, context),
        body: Column(
          children: [
            SizedBox(height: 2,),
            Container(
              height: 110,
              decoration: BoxDecoration(
                  color:
                Theme.of(context).colorScheme.lightWhite,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios_new,size: 20,color: Theme.of(context).colorScheme.fontColor,)),
                        SizedBox(width: 5,),
                        Text("SELECT MODEL",style: TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize: 13),),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Image.asset("assets/images/model.png",height: 50,color: colors.whiteTemp,),
                  ),
                  Divider(
                    color: colors.black54.withOpacity(0.2),
                    thickness: 1,
                  ),
                ],
              ),
            ),
            loading == true
                ? Center(
                child: CupertinoActivityIndicator(
                  radius: 15,
                  color: Theme.of(context).colorScheme.fontColor,
                ))
                : modelList == null || modelList.length == 0
                ? Center(
              child: Text(
                getTranslated(context, 'No Data Found')!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.fontColor,
                ),
              ),
            )
                :
            Container(
              color: colors.primary,
              height: MediaQuery.of(context).size.height/1.3,

              child: ListView.builder(
                itemCount: modelList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ShoesDetailsScreen(modelDetail: modelList[index], cat_id: widget.catID.toString(),
                            product_id: modelList[index]['variants'][0]['product_id'], catImage: widget.catImage.toString())));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all( color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5),)
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network("${modelList[index]['image']}",fit: BoxFit.cover, height: 100, width: 120,)),
                            ),
                            SizedBox(width: 10,),
                            SizedBox(
                              width: 170,
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Center(child: Text("${modelList[index]['name']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Theme.of(context).colorScheme.fontColor,),)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

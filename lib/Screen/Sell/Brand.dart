import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Models2/Get_new_cate_biding_Model.dart';
import 'model.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({Key? key}) : super(key: key);

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  @override
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoriesApi();
  }
  GetNewCateBidingModel? getNewCateBidingModel;
  getCategoriesApi() async {
    var headers = {
      'Cookie': 'ci_session=79302024174fff25d6c2492be30557b94eee0f6c; ekart_security_cookie=55f826ca73b59ac7f1138d3fcac56523'
    };
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/get_categories'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result =   await response.stream.bytesToString();
      var finalResult = GetNewCateBidingModel.fromJson(jsonDecode(result));
      setState(() {
        getNewCateBidingModel =  finalResult;
      });
    }
    else {
      print(response.reasonPhrase);
    }

  }
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,bottom: false,
      child: Scaffold(
        //backgroundColor: colors.primary,
      // appBar: AppBar(
        //   toolbarHeight: 80,
        // ),
        // appBar: getSimpleAppBar(getTranslated(context, 'BRAND')!, context),
        body: Container(
          color:colors.primary,
          //Theme.of(context).colorScheme.lightWhite,

          child: Column(
            children: [
              SizedBox(height: 2,),
              Container(
                height: 110,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.lightWhite,

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
                              child: Icon(Icons.arrow_back_ios_new,size: 20, color: Theme.of(context).colorScheme.fontColor,)),
                          SizedBox(width: 5,),
                          Text("SELECT BRAND",style: TextStyle( color: Theme.of(context).colorScheme.fontColor,fontSize: 13),),

                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Image.asset("assets/images/brand.png",height: 50, color: colors.whiteTemp, ),
                    ),
                    Divider(
                      color: colors.black54.withOpacity(0.2),
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              getNewCateBidingModel?.data == null ? Center(child: CircularProgressIndicator()) : getNewCateBidingModel!.data!.length == 0 ? Text("No Brand found!!"):    Container(
                height: MediaQuery.of(context).size.height/1.3,
                child: GridView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3/2,
                      mainAxisSpacing: 8

                  ),
                  itemCount: getNewCateBidingModel!.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ModelScreen(catID: getNewCateBidingModel!.data![index].id, catImage: getNewCateBidingModel!.data![index].image,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5,right: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(
                            decoration:  BoxDecoration(
                                color: colors.blackTemp.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Theme.of(context).colorScheme.fontColor.withOpacity(0.3))
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network("${getNewCateBidingModel!.data![index].image}",height: 30,width: 30,fit: BoxFit.fitWidth,)),
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
      ),
    );
  }
}




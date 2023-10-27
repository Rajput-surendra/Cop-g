import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/MyProductBiddings.dart';
import 'package:eshop_multivendor/widgets/CustomDropDown.dart';
import 'package:eshop_multivendor/widgets/custom_text_field.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:eshop_multivendor/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyBidProduct extends StatefulWidget {
  const MyBidProduct({Key? key}) : super(key: key);

  @override
  State<MyBidProduct> createState() => _MyBidProductState();
}

class _MyBidProductState extends State<MyBidProduct> {
  bool loading = false;
  TextEditingController product_nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

// TextEditingController tagsController = TextEditingController();
  // TextEditingController madeInController = TextEditingController();
  // TextEditingController allowedQuantityController = TextEditingController();
  // TextEditingController minOrderController = TextEditingController();
  // TextEditingController qtyStepController = TextEditingController();
  // TextEditingController deliverZipcodeController = TextEditingController();
  // TextEditingController prodDescController = TextEditingController();
  // TextEditingController specialPriceController = TextEditingController();
  List bidProductList = [];
  List taxList = [];
  var selected_tax;
  List brandList = [];
  var selected_brand;
  List categoryList = [];
  var selected_category;
  late File imgFile;
  final imgPicker = ImagePicker();
  var selectedimage;
  var stored_image_path;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  void _image_camera_dialog(BuildContext context, mysetState) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Select an Image',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
              onPressed: () {
                openGallery(mysetState);
                Navigator.pop(context);
              },
              child: Text(
                'Select a photo from Gallery',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
          CupertinoActionSheetAction(
              onPressed: () {
                openCamera(mysetState);
                Navigator.pop(context);
              },
              child: Text(
                'Take a photo with the camera',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void openCamera(mysetState) async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera, imageQuality: 80);
    mysetState(() {
      imgFile = File(imgCamera!.path);
      selectedimage = imgFile;
      print('image upload camera${imgFile} $selectedimage');
    });
  }

  void openGallery(mysetState) async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    mysetState(() {
      imgFile = File(imgGallery!.path);
      selectedimage = imgFile;
      print('image upload$imgFile $selectedimage');
    });
  }

  getBidProductApi() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> params = {
        'user_id': '${settingsProvider.userId}',
      };

      print("bid_productApi_url_is__ ${my_bid_productApi} & params___ $params");

      final response = await http.post(my_bid_productApi, body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        loading = false;
      });

      bidProductList = [];
      if (jsonResponse['error'] == false) {
        bidProductList = jsonResponse['data'];
        print("bid_productApi_response_is_______ ${bidProductList}");
      } else {
        toast('Something went wrong');
      }
    } else {
      toast('Something went wrong');
    }
  }

  Future _refresh() async {
    await getBidProductApi();
    setState(() {});
  }

  addProductApi(mysetState) async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);

    if (product_nameController.text == "" ||
        product_nameController.text == null) {
      toast('Please enter Product Name');
    } else if (descController.text == "" || descController.text == null) {
      toast('Please enter Description');
    } else if (priceController.text == "" || priceController.text == null) {
      toast('Please enter price of product');
    } else {
      mysetState(() {
        loading = true;
      });

      ///this will use for adding normal products not bid product
      // Map<String, dynamic> params = {
      //   // 'seller_id': CUR_USERID,
      //   // 'pro_input_name': product_nameController.text,
      //   // 'short_description': descController.text,
      //   // 'simple_price': simplePriceController.text,
      //   // 'simple_special_price': specialPriceController.text,
      //
      //   // 'tags': tagsController.text,
      //   // 'pro_input_tax': selected_tax['id'].toString(),//dropdown tax api
      //   // 'brand': selected_brand['id'].toString(),//dropdown tax api
      //   // 'made_in': madeInController.text,
      //   // 'total_allowed_quantity': allowedQuantityController.text,
      //   // 'minimum_order_quantity': minOrderController.text,
      //   // 'quantity_step_size': qtyStepController.text,
      //   // 'deliverable_type': '1',//always 1
      //   // 'deliverable_zipcodes': deliverZipcodeController.text,
      //   // 'cod_allowed': '1',//always 1
      //   // 'pro_input_image': 'uploads/media/2023/download_-_2023-08-08T120012_067.jpg', //file
      //   // 'pro_input_description': prodDescController.text,
      //   // 'category_id': selected_category['id'].toString(),//dropdown categ api
      //   // 'product_type': 'simple_product',//always
      //
      //
      //
      //   // 'variant_stock_level_type': 'product_level',//for variable only
      //   // 'attribute_values':"",//for variable only
      //   // 'simple_product_stock_status':"",//for variable only
      //
      //
      // };
      ///----

      var request = await http.MultipartRequest("POST", add_bid_productsApi);
      request.fields.addAll({
        'name': product_nameController.text,
        'description': descController.text,
        'price': priceController.text,
        'user_id': '${settingsProvider.userId}',
      });
      if (selectedimage != null) {
        request.files.add(await http.MultipartFile.fromPath('image', selectedimage.path));
      }
      print("add_bid_prod_params___ ${request.fields} image___ ${request.files} url_is__ ${add_bid_productsApi}");

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var jsonResponse = convert.jsonDecode(responseString);

      mysetState(() {
        loading = false;
      });

      if (jsonResponse['error'] == false) {
        toast("${jsonResponse['message']}");
        product_nameController.clear();
        descController.clear();
        priceController.clear();
        selectedimage = '';
        Navigator.pop(context);
        await getBidProductApi();
        setState(() {});

        print("add_bid_prod_response_is_______ ${jsonResponse}");
      } else {
        Navigator.pop(context);
        toast("${jsonResponse['message']}");
      }
    }
  }

  dropdownDataApi() async {
    ///tax dropdown------------------

    setState(() {
      loading = true;
    });
    print("fetch_tax_url_is__ ${fetch_taxApi}");

    final response = await http.post(fetch_taxApi, body: {});
    var jsonResponse = convert.jsonDecode(response.body);
    if (jsonResponse['error'] == false) {
      taxList = jsonResponse['data'];
      print("fetch_tax_response_is_______ ${taxList}");
    }

    ///brand dropdown-------------------
    final response1 = await http.post(fetch_brandsApi, body: {});
    var jsonResponse1 = convert.jsonDecode(response.body);
    if (jsonResponse1['error'] == false) {
      brandList = jsonResponse1['data'];
      print("brandList_response_is_______ ${brandList}");
    }

    ///category dropdown-------------------
    final response2 = await http.post(fetch_categoryApi, body: {});
    var jsonResponse2 = convert.jsonDecode(response.body);
    if (jsonResponse2['error'] == false) {
      categoryList = jsonResponse2['data'];
      print("categoryList_response_is_______ ${categoryList}");
    }

    setState(() {
      loading = false;
    });
  } //normal add product ke time lagegi ye api

  @override
  void initState() {
    getBidProductApi();
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
          : bidProductList == null || bidProductList.length == 0
              ? Center(
                child: Container(
                  height: 200,
                  child: Text( getTranslated(context, 'No Data Found')!,
                    style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),
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
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              Navigator.push(context, CupertinoPageRoute(builder: (context)=>MyProductBiddings(product_detail: bidProductList[index])));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 15,
                                  bottom: index == bidProductList.length - 1
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
                                            '${bidProductList[index]['price']}',
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
                                                  '${bidProductList[index]['description']}',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                                    'Add Product',
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

                              ///image picker

                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    _image_camera_dialog(context, dialog_setState);
                                  },
                                  child: Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .white),
                                      child: selectedimage == null || selectedimage == ""
                                          ? Icon(
                                              Icons.camera_alt,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .fontColor,
                                              size: 30,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                File(selectedimage?.path ?? ""),
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              CustomTextField(
                                  controller: product_nameController,
                                  hintText: 'Product Name'),

                              SizedBox(
                                height: 5,
                              ),

                              CustomTextField(
                                  controller: descController,
                                  hintText: 'Product Description'),

                              SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  hintText: 'Simple Price'),

                              // SizedBox(height: 5,),
                              // CustomTextField(
                              //     controller: specialPriceController,
                              //     hintText: 'Special Price'),
                              //
                              // SizedBox(height: 5,),

                              // CustomTextField(
                              //     controller: tagsController,
                              //     hintText: 'Tags'),
                              //
                              // SizedBox(height: 5,),
                              // CustomTextField(
                              //     controller: madeInController,
                              //     hintText: 'Made in'),

                              // SizedBox(height: 5,),
                              // CustomTextField(
                              //     controller: allowedQuantityController,
                              //     hintText: 'Total Allowed Quantity'),
                              //
                              // SizedBox(height: 5,),
                              // CustomTextField(
                              //     controller: minOrderController,
                              //     hintText: 'Min order Quantity'),
                              //
                              // SizedBox(height: 5,),
                              // CustomTextField(
                              //     controller: qtyStepController,
                              //     hintText: 'Quantity Step Size'),
                              //
                              // SizedBox(height: 5,),
                              // CustomTextField(
                              //     controller: deliverZipcodeController,
                              //     hintText: 'Deliver Zip code'),

                              // SizedBox(height: 5,),
                              // CustomTextField(
                              //     controller: prodDescController,
                              //     hintText: 'Product Description'),
                              //
                              // SizedBox(height: 5,),

                              // CustomDropdownButton<dynamic>(
                              //   items: (taxList),
                              //   selectedItem: selected_tax,
                              //   itemMapKey: 'title',
                              //   hint: 'Select product tax',
                              //   onChanged: (value){
                              //     selected_tax = value! ;
                              //     print('selected_tax___________${selected_tax?['id']}');
                              //   },
                              // ),
                              // CustomDropdownButton<dynamic>(
                              //   items: (brandList as List<dynamic>),
                              //   selectedItem: selected_brand,
                              //   hint: 'Select Brand',
                              //   itemMapKey: 'name',
                              //   onChanged: (value){
                              //     selected_brand = value! ;
                              //     print('selected_brand___________${selected_brand?['id']}');
                              //   },
                              // ),
                              // CustomDropdownButton<dynamic>(
                              //   items: (categoryList as List<dynamic>),
                              //   selectedItem: selected_category,
                              //   hint: 'Select Category',
                              //   itemMapKey: 'name',
                              //   onChanged: (value){
                              //     selected_category = value! ;
                              //     print('selected_category___________${selected_category?['id']}');
                              //   },
                              // ),

                              SizedBox(
                                height: 5,
                              ),

                              RoundEdgedButton(
                                text: 'Add Product',
                                isLoad: loading,
                                loaderColor:
                                    Theme.of(context).colorScheme.fontColor,
                                borderRadius: 10,
                                onTap: () async {
                                  addProductApi(dialog_setState);
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
        backgroundColor: Theme.of(context).colorScheme.white,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.fontColor,
        ),
      ),
    );
  }
}

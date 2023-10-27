import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Model/Model.dart';
import 'package:eshop_multivendor/Models2/categories_model.dart';
import 'package:eshop_multivendor/Models2/get_seller.dart';
import 'package:eshop_multivendor/Screen/AllCategory/All_Category.dart';
import 'package:eshop_multivendor/Screen/Cart/Cart.dart';
import 'package:eshop_multivendor/Screen/Cart/Widget/clearTotalCart.dart';
import 'package:eshop_multivendor/Screen/Product%20Detail/productDetail.dart';
import 'package:eshop_multivendor/Screen/ProductList&SectionView/SectionList.dart';
import 'package:eshop_multivendor/Screen/Sell/bidding_Scanner.dart';
import 'package:eshop_multivendor/Screen/SubCategory/SubCategory.dart';
import 'package:eshop_multivendor/Screen/product_animation_detail_screen.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:eshop_multivendor/widgets/desing.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:eshop_multivendor/widgets/security.dart';
import 'package:eshop_multivendor/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'as http;
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:version/version.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/String.dart';
import '../../Helper/routes.dart';
import '../../Model/Section_Model.dart';
import '../../Provider/CartProvider.dart';
import '../../Provider/Favourite/FavoriteProvider.dart';
import '../../Provider/Search/SearchProvider.dart';
import '../../Provider/SettingProvider.dart';
import '../../Provider/Theme.dart';
import '../../Provider/UserProvider.dart';
import '../../Provider/homePageProvider.dart';
import '../../Provider/systemProvider.dart';
import '../../QR_code_scanner.dart';
import '../Language/languageSettings.dart';
import '../NoInterNetWidget/NoInterNet.dart';
import '../Notification/NotificationLIst.dart';
import '../SQLiteData/SqliteData.dart';
import '../Sell/Brand.dart';
import '../homePage/widgets/MostLikeSection.dart';
import '../homePage/widgets/drawer.dart';
import '../homePage/widgets/hideAppBarBottom.dart';
import '../homePage/widgets/homePageDialog.dart';
import '../homePage/widgets/horizontalCategoryList.dart';
import '../homePage/widgets/section.dart';
import '../homePage/widgets/slider.dart';
import 'dart:convert' as convert;




class CopGScreen extends StatefulWidget {
  const CopGScreen({Key? key}) : super(key: key);

  @override
  _CopGScreenState createState() => _CopGScreenState();
}

class _CopGScreenState extends State<CopGScreen>
    with AutomaticKeepAliveClientMixin<CopGScreen>, TickerProviderStateMixin {

  late TabController tabController;

  var latitude;
  var longitude;

  var pinController = TextEditingController();
  var currentAddress = TextEditingController();

  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  var db = DatabaseHelper();
  final ScrollController _scrollBottomBarController = ScrollController();
  DateTime? currentBackPressTime;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  int count = 1;
  int category_length=0;

  @override
  bool get wantKeepAlive => true;

  setStateNow() {
    setState(() {});
  }

  setSnackBarFunctionForCartMessage() {
    Future.delayed(const Duration(seconds: 6)).then(
          (value) {
        if (homePageSingleSellerMessage) {
          homePageSingleSellerMessage = false;
          showOverlay(
            getTranslated(context,
                'One of the product is out of stock, We are not able To Add In Cart')!,
            context,
          );
        }
      },
    );
  }

  CategoriesData? categoriesData;
  bool isLoading=true;
   getCategories() async {

     var response = await http.post(Uri.parse('$baseUrl/get_categories'), body: {});
     var jsonResponse = convert.jsonDecode(response.body);

     if (jsonResponse['error'] == false) {
       var finalResult = CategoriesData.fromJson(jsonResponse);

       setState(() {
         categoriesData = finalResult;

       });

       if(categoriesData?.data.length != 0) {
         category_length = categoriesData!.data.length;

         tabController = TabController(length: category_length, vsync: this);
       }
       print('get_categories_response______________${categoriesData?.data.first.name}_________');
     }

     getProductsApi(0);

///old
    // var headers = {
    //   'Cookie': 'ci_session=453c82cf282c7397cb80d7e3cd77a15383df89d4'
    // };
    // var request = http.Request('POST', Uri.parse('${baseUrl}get_categories'));
    // request.headers.addAll(headers);
    // http.StreamedResponse response = await request.send();
    //
    // if (response.statusCode == 200) {
    //   var  Result = await response.stream.bytesToString();
    //   var finalResult = CategoriesData.fromJson(json.decode(Result));
    //
    //   print("get_category_list____________ ${finalResult.data.first.name}");
    //
    //   setState(() {
    //     categoriesData = finalResult;
    //
    //   });
    //
    // }
    // else {
    //   print(response.reasonPhrase);
    // }
  }

  List ProductList=[];
  List<Product> tempList=[];
  getProductsApi(int index) async{
    setState(() {
      isLoading=true;
    });
     Map<String, dynamic> params ={
       'category_id': categoriesData?.data[index].id.toString()
     };

    var response = await http.post(getProductApi, body: params);
    var jsonResponse = convert.jsonDecode(response.body);

    if (jsonResponse['error'] == false) {
  tempList =
      (jsonResponse['data'] as List).map((data) => Product.fromJson(data)).toList();

      context.read<HomePageProvider>().getFav(context, setStateNow);

      ProductList = jsonResponse['data'];
      setState(() {
        isLoading=false;
      });

    }

  }

  // GetSellerModel?getSellerModel;
  // Future<void> getSeller() async {
  //   var headers = {
  //     'Cookie': 'ci_session=76d3bace1bcc4256c88658c9ee725bbd4165fc0d'
  //   };
  //
  //   var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get_sellers'));
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     var Result = await response.stream.bytesToString();
  //     final finalResult = GetSellerModel.fromJson(json.decode(Result));
  //     setState(() {
  //       getSellerModel = finalResult;
  //     });
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }


  Future<void> getCurrentLoc() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("checking permission here ${permission}");
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // var loc = Provider.of<LocationProvider>(context, listen: false);

    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
    List<Placemark> placemark = await placemarkFromCoordinates(
        double.parse(latitude!), double.parse(longitude!),
        localeIdentifier: "en");

    pinController.text = placemark[0].postalCode!;
    if (mounted) {
      setState(() {
        pinController.text = placemark[0].postalCode!;
        currentAddress.text =
        "${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}";
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        // loc.lng = position.longitude.toString();
        //loc.lat = position.latitude.toString();


      });

    }
  }




  @override
  void initState() {
    getCategories();



    UserProvider user = Provider.of<UserProvider>(context, listen: false);

    SettingProvider setting =
    Provider.of<SettingProvider>(context, listen: false);
    user.setMobile(setting.mobile);
    user.setName(setting.userName);
    user.setEmail(setting.email);
    user.setProfilePic(setting.profileUrl);
    Future.delayed(Duration.zero).then(
          (value) {
        callApi();

      },
    );

    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    setSnackBarFunctionForCartMessage();
    Future.delayed(Duration.zero).then(
          (value) {
        hideAppbarAndBottomBarOnScroll(
          _scrollBottomBarController,
          context,
        );
      },
    );
    super.initState();
    // getCurrentLoc();

    // getSeller();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.white,
        leading: GestureDetector(
            onTap: (){
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(Icons.menu,color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5),)),
        title:SvgPicture.asset(
          DesignConfiguration.setSvgPath('homelogo'),
          height: 40,
        ),
        titleSpacing: 0,
        toolbarHeight:120,
        actions: <Widget>[
          Selector<UserProvider, String>(
            builder: (context, data, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Stack(
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          DesignConfiguration.setSvgPath('appbarCart'),
                          color: Theme.of(context).colorScheme.txtColor,
                        ),
                      ),
                      (data.isNotEmpty && data != '0')
                          ? Positioned(
                        bottom: 20,
                        right: 0,
                        child: Container(
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.txtColor,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Text(
                                data,
                                style:  TextStyle(
                                  fontSize: textFontSize10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ubuntu',
                                  color: Theme.of(context).colorScheme.blackTxtColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          : Container()
                    ],
                  ),
                  onPressed: () {
                    cartTotalClear(context);
                    Navigator.push(context, CupertinoPageRoute(
                      builder: (context) => const Cart(fromBottom: false,),)).then((value) {setState;},);
                  },
                ),
              );
            },
            selector: (_, HomePageProvider) => HomePageProvider.curCartCount,
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Theme.of(context).colorScheme.lightWhite,
              padding: EdgeInsets.fromLTRB(
                10,
                context.watch<HomePageProvider>().getBars ? 10 : 30,
                10,
                0,
              ),
              child: GestureDetector(
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: TextField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.normal,
                      ),
                      enabled: false,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.lightWhite,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(circularBorderRadius10),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(circularBorderRadius10),
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 0, 5.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(circularBorderRadius10),
                          ),
                        ),
                        isDense: true,
                        hintText: getTranslated(context, 'searchHint'),
                        hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Theme.of(context).colorScheme.fontColor,
                          fontSize: textFontSize12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(
                              DesignConfiguration.setSvgPath('homepage_search'),
                              height: 15,
                              width: 15,
                              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)
                          ),
                        ),
                        suffixIcon: Selector<ThemeNotifier, ThemeMode>(
                          selector: (_, themeProvider) =>
                              themeProvider.getThemeMode(),
                          builder: (context, data, child) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: (data == ThemeMode.system &&
                                  MediaQuery.of(context).platformBrightness ==
                                      Brightness.light) ||
                                  data == ThemeMode.light
                                  ? SvgPicture.asset(
                                  DesignConfiguration.setSvgPath('voice_search'),
                                  height: 15,
                                  width: 15,
                                  color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)
                              )
                                  : SvgPicture.asset(
                                  DesignConfiguration.setSvgPath(
                                      'voice_search_white'),
                                  height: 15,
                                  width: 15,
                                  color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)
                              ),
                            );
                          },
                        ),
                        fillColor: Theme.of(context).colorScheme.white,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  Routes.navigateToSearchScreen(context);
                },
              ),
            ),
          ),
        ),
      ),

      drawer: get_drawer(context),
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: onWillPopScope,
        child:
        isLoading == true? Center(child: CircularProgressIndicator()):
        categoriesData?.data.length == 0? Container(
            height: MediaQuery.of(context).size.height/1.2,
            child: Center(child: Text("No Data found..!!", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,)))):
        isNetworkAvail ?
        DefaultTabController(
          length: categoriesData!.data.length,
                              child:  Column(
                                children: [
                                  ///tabs
                                  Center(
                                    child: Padding(
                                      padding:  EdgeInsets.only(top: 8.0, bottom: 8),
                                      child: Container(
                                        height: 40,
                                        child: ButtonsTabBar(
                                            controller: tabController,
                                            backgroundColor: Theme.of(context).colorScheme.fontColor,
                                            unselectedBackgroundColor:  Theme.of(context).colorScheme.white,
                                            duration: 0,
                                            borderColor: Theme.of(context).colorScheme.white,
                                            unselectedBorderColor: Theme.of(context).colorScheme.lightWhite,
                                            borderWidth: 0,
                                            contentPadding: const EdgeInsets.only(left: 18,right: 18,top: 8,bottom: 8),
                                            radius: 30,
                                            tabs: [
                                              for(int i=0; i< categoriesData!.data.length; i++)
                                              Tab(
                                                child:  Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    CachedNetworkImage(imageUrl: '${categoriesData!.data[i].image}', height: 13,
                                                      color: tabController.index == i? Theme.of(context).colorScheme.white  : Theme.of(context).colorScheme.fontColor,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text("${categoriesData!.data[i].name}",
                                                      style: TextStyle(fontSize: 12,
                                                         fontFamily: "trans_regular",
                                                        fontWeight: tabController.index ==i? FontWeight.w600 : FontWeight.w400,
                                                        color: tabController.index ==i? Theme.of(context).colorScheme.white  : Theme.of(context).colorScheme.fontColor,

                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onTap: (int index) {
                                              setState(() {
                                                tabController.index = index;
                                                print("selected index is ${tabController.index}");

                                                getProductsApi(tabController.index);
                                                setState(() {});
                                              });
                                            }
                                        ),
                                      ),
                                    ),
                                  ),

                                  ///views
                                  Expanded(
                                    child: TabBarView(
                                      physics: const NeverScrollableScrollPhysics(),
                                     controller: tabController,
                                      children: [

                                        for(int i=0; i< categoriesData!.data.length; i++)
                                          categoriesData!.data[i].name.toLowerCase().contains('exclusive')?
                                          exclusiveProductDesign() :
                                          normalProductDesign(),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
            : NoInterNet(
          buttonController: buttonController,
          buttonSqueezeanimation: buttonSqueezeanimation,
          setStateNoInternate: setStateNoInternate,
        ),
      ),
    );
  }

  Widget exclusiveProductDesign(){
     return  SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           ///all product cards
           const Section(),
           SizedBox(height: 20,),

           
           ///exclusive items

           Container(
             alignment: Alignment.centerRight,
             padding: const EdgeInsets.only(
               right: 15.0,
               left: 15.0,
               bottom: 10,
             ),
             child: GestureDetector(
               child: Text(
                 getTranslated(context, 'SHOW ALL')!,
                 style: Theme.of(context).textTheme.caption!.copyWith(
                   color: Theme.of(context).colorScheme.fontColor,
                   fontSize:13,
                   fontWeight: FontWeight.bold,
                   fontStyle: FontStyle.normal,
                   fontFamily: 'ubuntu',
                 ),
               ),
               onTap: () {
                 // SectionModel model = context.read<HomePageProvider>().sectionList[index];
                 //
                 // Navigator.push(
                 //   context,
                 //   CupertinoPageRoute(
                 //     builder: (context) => SectionList(
                 //       index: index,
                 //       section_model: model,
                 //       from: title ==
                 //           getTranslated(context, 'You might also like')!
                 //           ? 2
                 //           : 1,
                 //       productList: productList,
                 //     ),
                 //   ),
                 // );
               },
             ),
           ),
           Column(
             children: [
               Row(
                 children: [
                   if(ProductList.length > 0)
                   GestureDetector(
                     onTap:() {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(model: tempList[0],  secPos: 0, index: 0, list: true)),);
                       // Navigator.push(context, PageRouteBuilder(
                       //       pageBuilder: (_, __, ___) => ProductDetail(model: tempList[0], fromExclusive:true, secPos: 0, index: 0, list: true)),
                       // );
                     },
                     child: Container(
                       height: 350,
                       width: MediaQuery.of(context).size.width/2,
                       child: CachedNetworkImage(imageUrl: '${ProductList[0]['image']}', fit: BoxFit.cover,),
                     ),
                   ),
                   Column(
                     children: [
                       if(ProductList.length > 1)
                         GestureDetector(
                           onTap:() {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(model: tempList[1],  secPos: 0, index: 0, list: true)),);

                             // Navigator.push(context, PageRouteBuilder(
                             //     pageBuilder: (_, __, ___) => ProductDetail(model: tempList[1], fromExclusive:true,  secPos: 0, index: 1, list: true)),
                             // );
                           },
                           child: Container(
                           height: 350/2,
                           width: MediaQuery.of(context).size.width/2,
                             child: CachedNetworkImage(imageUrl: '${ProductList[1]['image']}', fit: BoxFit.cover,),
                       ),
                         ),
                       if(ProductList.length > 2)
                         GestureDetector(
                           onTap:() {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(model: tempList[2],  secPos: 0, index: 0, list: true)),);
                             // Navigator.push(context, PageRouteBuilder(
                             //     pageBuilder: (_, __, ___) => ProductDetail(model: tempList[2],  fromExclusive:true, secPos: 0, index: 2, list: true)),
                             // );
                           },
                           child: Container(
                           height: 350/2,
                           width: MediaQuery.of(context).size.width/2,
                             child: CachedNetworkImage(imageUrl: '${ProductList[2]['image']}', fit: BoxFit.cover,),
                       ),
                         ),
                     ],
                   ),
                 ],
               ),
               Row(
                 children: [
                   if(ProductList.length > 3)
                     GestureDetector(
                       onTap:() {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(model: tempList[3],  secPos: 0, index: 0, list: true)),);
                         // Navigator.push(context, PageRouteBuilder(
                         //     pageBuilder: (_, __, ___) => ProductDetail(model: tempList[3], fromExclusive:true,  secPos: 0, index: 3, list: true)),
                         // );
                       },
                       child: Container(
                       height: 350/2,
                       width: MediaQuery.of(context).size.width/2,
                         child: CachedNetworkImage(imageUrl: '${ProductList[3]['image']}', fit: BoxFit.cover,),
                   ),
                     ),
                   if(ProductList.length > 4)
                     GestureDetector(
                       onTap:() {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(model: tempList[4],  secPos: 0, index: 0, list: true)),);
                         // Navigator.push(context, PageRouteBuilder(
                         //     pageBuilder: (_, __, ___) => ProductDetail(model: tempList[4], fromExclusive:true,  secPos: 0, index: 4, list: true)),
                         // );
                       },
                       child: Container(
                       height: 350/2,
                       width: MediaQuery.of(context).size.width/2,
                         child: CachedNetworkImage(imageUrl: '${ProductList[4]['image']}', fit: BoxFit.cover,),
                   ),
                     ),

                 ],
               ),
             ],
           ),
           const SizedBox(height: 40,),

           CustomSlider(),

           SizedBox(height: 20,),
         ],
       ),
     );
}

  Widget normalProductDesign(){

    return ListView.builder(
        itemCount: ProductList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){

      return  GestureDetector(
        onTap: (){

          Navigator.push(
            context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => ProductDetail(model: tempList[index],from3dProduct:true, secPos: 0, index: index, list: true)),
          );

          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailAnimation(index: index, )));
        },
        child: Stack(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 40, right: 100, top: 10),
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width/1.5,
                decoration: BoxDecoration(
                    color: index % 2 == 0 ? Color(0xff363638) : Color(0xff636366),
                    borderRadius: BorderRadius.circular(15)
                ),
              ),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width/3.3,
              top: 80,
              child: SizedBox(
                width: 270,
                child: Hero(
                  tag: 'tag1${index}',
                  transitionOnUserGestures: true,
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(ModalRoute.of(context)?.animation ?? const AlwaysStoppedAnimation(1)),
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 1, end: 0).animate(ModalRoute.of(context)?.secondaryAnimation ?? const AlwaysStoppedAnimation(1)),
                      child: CachedNetworkImage(imageUrl: '${ProductList[index]['other_images'][1]}', fit: BoxFit.cover,),
                    ),
                  ),
                )
              ),
            ),

            Positioned(
              left: 60,
              top: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ProductList[index]['name']}',
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ubuntu',
                      color: Theme.of(context).colorScheme.fontColor,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Image.asset('assets/images/rupee.png', height: 13,),
                      Text(
                        '${ProductList[index]['min_max_price']['special_price']}',
                        style:  TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ubuntu',
                          color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Image.asset('assets/images/rupee.png', height: 13,),
                      Text(
                        '${ProductList[index]['min_max_price']['max_price']}',
                        style:  TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ubuntu',
                          decoration: TextDecoration.lineThrough,
                          color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),



          ],
        ),
      );
    });
    ///static
    // return ListView.builder(
    //     itemCount:5,
    //     scrollDirection: Axis.horizontal,
    //     itemBuilder: (context, index){
    //
    //   return  GestureDetector(
    //     onTap: (){
    //
    //       // Navigator.push(
    //       //   context,
    //       //   PageRouteBuilder(pageBuilder: (_, __, ___) => ProductDetail(model: tempList[index], secPos: 0, index: 0, list: true)),
    //       // );
    //
    //       Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailAnimation(index: index, )));
    //     },
    //     child: Stack(
    //       children: [
    //
    //         Padding(
    //           padding: const EdgeInsets.only(left: 40, right: 100, top: 10),
    //           child: Container(
    //             height: 300,
    //             width: MediaQuery.of(context).size.width/1.5,
    //             decoration: BoxDecoration(
    //                 color: index % 2 == 0 ? Color(0xff363638) : Color(0xff636366),
    //                 borderRadius: BorderRadius.circular(15)
    //             ),
    //           ),
    //         ),
    //
    //         Positioned(
    //           left: MediaQuery.of(context).size.width/3.3,
    //           top: 80,
    //           child: SizedBox(
    //             width: 270,
    //             child: Hero(
    //               tag: 'tag1${index}',
    //               transitionOnUserGestures: true,
    //               child: FadeTransition(
    //                 opacity: Tween<double>(begin: 0, end: 1).animate(ModalRoute.of(context)?.animation ?? const AlwaysStoppedAnimation(1)),
    //                 child: FadeTransition(
    //                   opacity: Tween<double>(begin: 1, end: 0).animate(ModalRoute.of(context)?.secondaryAnimation ?? const AlwaysStoppedAnimation(1)),
    //                   child: Image.asset( "assets/images/sneak1.png", fit: BoxFit.cover,),
    //                 ),
    //               ),
    //             )
    //           ),
    //         ),
    //
    //         Positioned(
    //           left: 60,
    //           top: 30,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 'Alpha Savage',
    //                 style:  TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                   fontFamily: 'ubuntu',
    //                   color: Theme.of(context).colorScheme.fontColor,
    //                 ),
    //               ),
    //               SizedBox(height: 10,),
    //               Row(
    //                 children: [
    //                   Image.asset('assets/images/rupee.png', height: 13,),
    //                   Text(
    //                     '1953',
    //                     style:  TextStyle(
    //                       fontSize: 13,
    //                       fontWeight: FontWeight.bold,
    //                       fontFamily: 'ubuntu',
    //                       color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
    //                     ),
    //                   ),
    //                   SizedBox(width: 10,),
    //                   Image.asset('assets/images/rupee.png', height: 13,),
    //                   Text(
    //                     '2100',
    //                     style:  TextStyle(
    //                       fontSize: 13,
    //                       fontWeight: FontWeight.bold,
    //                       fontFamily: 'ubuntu',
    //                       decoration: TextDecoration.lineThrough,
    //                       color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //
    //
    //
    //       ],
    //     ),
    //   );
    // });

    ///old
    // return  SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //
    //
    //
    //
    //       ///product cards
    //       const Section(),
    //     ],
    //   ),
    // );
  }



        ///
//           RefreshIndicator(
//             color: Theme.of(context).colorScheme.fontColor,
//             key: _refreshIndicatorKey,
//             onRefresh: _refresh,
//             child: CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               controller: _scrollBottomBarController,
//               slivers: [
//                 SliverPersistentHeader(
//                   floating: false,
//                   pinned: true,
//                   delegate: SearchBarHeaderDelegate(),
//                 ),
//
//
//                 SliverToBoxAdapter(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       Padding(
//                         padding: EdgeInsets.only(left: 10.0,right: 10),
//                         child: Text('Sneakers Shoes',style: TextStyle(color: Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),),
//
//                       ),
//                       const SizedBox(height:20,),
//
//                       categoriesData?.data!=null?Container(
//                         height: MediaQuery.of(context).size.height/2.75,
//                         width: MediaQuery.of(context).size.width/1,
//                         child: ListView.builder(
//                           itemCount:categoriesData?.data.length,
//                           scrollDirection: Axis.horizontal,
//                           shrinkWrap: true,
//                           // physics: NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return Container(
//                               width:MediaQuery.of(context).size.width/1.2,
//                               child: Card(
//                                 elevation:5,
//                                 margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                 child: Column(
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.push(context,MaterialPageRoute(builder: (context)=>AllCategory()));
//                                       },
//                                       child: Container(
//                                           height:210,
//                                           width:MediaQuery.of(context).size.width/1.3,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(30)),
//                                           child: Image.network('${categoriesData?.data[index].image}',fit: BoxFit.fill,)),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left:10.0,top:20),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                               width: 90,
//                                               height: 20,
//                                               child: Text('${categoriesData?.data[index].name}',textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),)),
//                                           Container(
//                                               width: 90,
//                                               height: 20,
//                                               child: Text('${categoriesData?.data[index].name}',textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),))
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//
//                               ),
//                             );
//                           },),
//                       ):const Center(child: CircularProgressIndicator()),
//                       const SizedBox(height: 10,),
//
//
//                       ///product cards
//                       const Section(),
//
//                       const SizedBox(height: 20,),
//                       CustomSlider(),
//                       SizedBox(height: 20,),
// ///tab wala code
//                       // DefaultTabController(
//                       //                     length: 3,
//                       //                       child:  Center(
//                       //                         child: Padding(
//                       //                           padding:  EdgeInsets.only(top: 8.0),
//                       //                           child: Container(
//                       //                             height: 50,
//                       //                             child: ButtonsTabBar(
//                       //                                 controller: tabController,
//                       //                                 backgroundColor: Theme.of(context).colorScheme.white,
//                       //                                 unselectedBackgroundColor:  Theme.of(context).colorScheme.lightWhite,
//                       //                                 duration: 0,
//                       //                                 borderColor: Theme.of(context).colorScheme.white,
//                       //                                 unselectedBorderColor: Theme.of(context).colorScheme.lightWhite,
//                       //                                 borderWidth: 0,
//                       //                                 contentPadding: const EdgeInsets.only(left: 18,right: 18,top: 8,bottom: 8),
//                       //                                 radius: 30,
//                       //                                 tabs: [
//                       //                                   Tab(
//                       //                                     child:  Row(
//                       //                                       crossAxisAlignment: CrossAxisAlignment.center,
//                       //                                       children: [
//                       //
//                       //                                         Image.asset('assets/images/sneakers.png', height: 12,
//                       //                                           // color: myIndex==0? MyColors.white  : MyTheme.of(context).colorScheme.fontColorColor,
//                       //                                         ),
//                       //                                         SizedBox(width: 10),
//                       //                                         Text("Sneakers",
//                       //                                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: "trans_regular",
//                       //                                             // color: myIndex==0? MyColors.white  : MyTheme.of(context).colorScheme.fontColorColor,
//                       //                                           ),
//                       //                                         )
//                       //                                       ],
//                       //                                     ),
//                       //                                   ),
//                       //                                   Tab(
//                       //                                     child: Row(
//                       //                                       crossAxisAlignment: CrossAxisAlignment.center,
//                       //                                       children: [
//                       //                                         Image.asset('assets/images/streetwear.png', height: 12,
//                       //                                           // color: myIndex==1? MyColors.white  : MyTheme.of(context).colorScheme.fontColorColor,
//                       //                                         ),
//                       //                                         SizedBox(width: 10),
//                       //
//                       //                                         Text("Street Wear",
//                       //                                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: "trans_regular",
//                       //                                             // color: myIndex==1? MyColors.white  : MyTheme.of(context).colorScheme.fontColorColor,
//                       //                                           ),
//                       //                                         )
//                       //                                       ],
//                       //                                     ),
//                       //                                   ),
//                       //                                   Tab(
//                       //                                     child: Row(
//                       //                                       crossAxisAlignment: CrossAxisAlignment.center,
//                       //                                       children: [
//                       //                                         Image.asset('assets/images/accessories.png', height: 12,
//                       //                                           // color: myIndex==1? MyColors.white  : MyTheme.of(context).colorScheme.fontColorColor,
//                       //                                         ),
//                       //                                         SizedBox(width: 10),
//                       //
//                       //                                         Text("Accessories",
//                       //                                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: "trans_regular",
//                       //                                             // color: myIndex==1? MyColors.white  : MyTheme.of(context).colorScheme.fontColorColor,
//                       //                                           ),
//                       //                                         )
//                       //                                       ],
//                       //                                     ),
//                       //                                   )
//                       //                                 ],
//                       //                                 onTap: (int index) {
//                       //                                   setState(() {
//                       //                                     tabController.index = index;
//                       //                                     setState(() {});
//                       //                                     print('index is ${tabController.index}');
//                       //                                   });
//                       //                                 }
//                       //                             ),
//                       //                           ),
//                       //                         ),
//                       //                       ),
//                       //                     ),
//                       //
//                       //                       PageView(
//                       //                         controller: _pageController,
//                       //                         onPageChanged: (index) {
//                       //                           tabController.index = index;
//                       //                           setState(() {});
//                       //                         },
//                       //                         children: [
//                       //                           ///1st item
//                       //                           Column(
//                       //                             crossAxisAlignment: CrossAxisAlignment.start,
//                       //                             children: [
//                       //                               Padding(
//                       //                                 padding: EdgeInsets.only(left: 10.0,right: 10),
//                       //                                 child: Text('Sneakers Shoes',style: TextStyle(color: Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),),
//                       //
//                       //                               ),
//                       //                               const SizedBox(height:20,),
//                       //
//                       //                               categoriesData?.data!=null?Container(
//                       //                                 height: MediaQuery.of(context).size.height/2.75,
//                       //                                 width: MediaQuery.of(context).size.width/1,
//                       //                                 child: ListView.builder(
//                       //                                   itemCount:categoriesData?.data.length,
//                       //                                   scrollDirection: Axis.horizontal,
//                       //                                   shrinkWrap: true,
//                       //                                   // physics: NeverScrollableScrollPhysics(),
//                       //                                   itemBuilder: (context, index) {
//                       //                                     return Container(
//                       //                                       width:MediaQuery.of(context).size.width/1.2,
//                       //                                       child: Card(
//                       //                                         elevation:5,
//                       //                                         margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                       //                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       //                                         child: Column(
//                       //                                           children: [
//                       //                                             InkWell(
//                       //                                               onTap: () {
//                       //                                                 Navigator.push(context,MaterialPageRoute(builder: (context)=>AllCategory()));
//                       //                                               },
//                       //                                               child: Container(
//                       //                                                   height:210,
//                       //                                                   width:MediaQuery.of(context).size.width/1.3,
//                       //                                                   decoration: BoxDecoration(
//                       //                                                       borderRadius: BorderRadius.circular(30)),
//                       //                                                   child: Image.network('${categoriesData?.data[index].image}',fit: BoxFit.fill,)),
//                       //                                             ),
//                       //                                             Padding(
//                       //                                               padding: const EdgeInsets.only(left:10.0,top:20),
//                       //                                               child: Row(
//                       //                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //                                                 children: [
//                       //                                                   Container(
//                       //                                                       width: 90,
//                       //                                                       height: 20,
//                       //                                                       child: Text('${categoriesData?.data[index].name}',textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),)),
//                       //                                                   Container(
//                       //                                                       width: 90,
//                       //                                                       height: 20,
//                       //                                                       child: Text('${categoriesData?.data[index].name}',textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),))
//                       //                                                 ],
//                       //                                               ),
//                       //                                             )
//                       //                                           ],
//                       //                                         ),
//                       //
//                       //                                       ),
//                       //                                     );
//                       //                                   },),
//                       //                               ):const Center(child: CircularProgressIndicator()),
//                       //                               const SizedBox(height: 10,),
//                       //
//                       //
//                       //                               ///product cards
//                       //                               const Section(),
//                       //
//                       //                               const SizedBox(height: 20,),
//                       //                               CustomSlider(),
//                       //                               SizedBox(height: 20,),
//                       //                             ],
//                       //                           ),
//                       //
//                       //                           ///2nd item
//                       //                           Container(color: Colors.green, height: 500,),
//                       //
//                       //                           ///3ed item
//                       //                           Container(color: Colors.blue, height: 500,),
//                       //
//                       //
//                       //                         ],
//                       //                       ),
//
//
//                       ///
//                       // const SizedBox(height: 10,),
//                       // Container(
//                       //   height:150,
//                       //   padding: const EdgeInsets.only(left: 10,right: 10),
//                       //   width:MediaQuery.of(context).size.width/1,
//                       //   child: Card(
//                       //     elevation: 5,
//                       //     child: Row(
//                       //       mainAxisAlignment: MainAxisAlignment.start,
//                       //       children: [
//                       //         Image.asset('assets/images/img_1.png',fit: BoxFit.fill,),
//                       //         SizedBox(width: 15,),
//                       //         Column(
//                       //           children: [
//                       //             SizedBox(height: 20,),
//                       //             Container(
//                       //                 width:110,
//                       //                 child: Text('You Do not have any pending check',overflow:TextOverflow.ellipsis,maxLines:2,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11, color: Theme.of(context).colorScheme.txtColor,),)),
//                       //             SizedBox(height: 10,),
//                       //             Container(
//                       //                 width:110,
//                       //                 child: ElevatedButton(onPressed: (){
//                       //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>BrandScreen()));
//                       //                 },style: ElevatedButton.styleFrom(backgroundColor:Colors.black), child:Text('Start a new check',textAlign: TextAlign.center,style: TextStyle(fontSize: 12),)))
//                       //           ],
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                       // const SizedBox(height: 10,),
//                       // Padding(
//                       //   padding: const EdgeInsets.only(left: 10.0,right: 10),
//                       //   child: Row(
//                       //     children: [
//                       //       InkWell(
//                       //         onTap: () {
//                       //
//                       //         },
//                       //         child: Container(
//                       //           width:MediaQuery.of(context).size.width/2.2,
//                       //           height: 200,
//                       //           child: Card(
//                       //               color: Theme.of(context).colorScheme.white,
//                       //               shape:
//                       //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       //               elevation: 2,
//                       //
//                       //               child: Column(
//                       //                 mainAxisSize: MainAxisSize.min,
//                       //                 crossAxisAlignment: CrossAxisAlignment.center,
//                       //                 children: [
//                       //                   const SizedBox(height:30,),
//                       //                   Container(
//                       //                     height: 110,
//                       //                     width: MediaQuery.of(context).size.width,
//                       //                     decoration: const BoxDecoration(
//                       //                       shape: BoxShape.circle,
//                       //                     ),
//                       //                     child: CircleAvatar(
//                       //                         maxRadius: 40,
//                       //                         child: Image.asset('assets/images/buy.png',color: Theme.of(context).colorScheme.txtColor,height:80,)),
//                       //                   ),
//                       //
//                       //                   const SizedBox(
//                       //                     height:20,
//                       //                   ),
//                       //                    Text('Buy',
//                       //                     style: TextStyle(
//                       //                       color: Theme.of(context).colorScheme.txtColor,
//                       //                       fontWeight: FontWeight.bold, fontSize: 15,),
//                       //                     textAlign: TextAlign.center,
//                       //                   ),
//                       //
//                       //                 ],
//                       //               )),
//                       //         ),
//                       //       ),
//                       //       SizedBox(width: 10,),
//                       //       InkWell(
//                       //         onTap: () {
//                       //           Navigator.push(context, MaterialPageRoute(builder: (context)=>BiddingProduct()));
//                       //         },
//                       //         child: Container(
//                       //           width:MediaQuery.of(context).size.width/2.2,
//                       //           height: 200,
//                       //           child: Card(
//                       //               color: Theme.of(context).colorScheme.white,
//                       //               shape:
//                       //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       //               elevation: 2,
//                       //
//                       //               child: Column(
//                       //                 mainAxisSize: MainAxisSize.min,
//                       //                 crossAxisAlignment: CrossAxisAlignment.center,
//                       //                 children: [
//                       //                   const SizedBox(height:30,),
//                       //                   CircleAvatar(
//                       //                       maxRadius: 50,
//                       //                       child: Image.asset('assets/images/sell.png',color: colors.whiteTemp,height:60,)),
//                       //
//                       //                   const SizedBox(
//                       //                     height:20,
//                       //                   ),
//                       //                    Text('Bidding',
//                       //                     style: TextStyle(
//                       //                       color: Theme.of(context).colorScheme.txtColor,
//                       //                       fontWeight: FontWeight.bold, fontSize: 15,),
//                       //                     textAlign: TextAlign.center,
//                       //                   ),
//                       //
//                       //                 ],
//                       //               )),
//                       //         ),
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//
//                       //  Padding(
//                       //   padding: EdgeInsets.only(left: 10.0,right: 10),
//                       //   child: Text('Shop By Seller',style: TextStyle(color: Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),),
//                       // ),
//
//                       //const HorizontalCategoryList(),
//                       // const MostLikeSection(),
//                       // const SizedBox(height:10,),
//                       // getSellerModel?.data!=null ? Container(
//                       //     height: MediaQuery.of(context).size.height/4.6,
//                       //     width: MediaQuery.of(context).size.width/1,
//                       //     child: ListView.builder(
//                       //       itemCount:getSellerModel?.data.length,
//                       //       scrollDirection: Axis.horizontal,
//                       //       shrinkWrap: true,
//                       //       // physics: NeverScrollableScrollPhysics(),
//                       //       itemBuilder: (context, index) {
//                       //         return Column(
//                       //           children: [
//                       //             Container(
//                       //               width:150,
//                       //               height: 140,
//                       //               child: Card(
//                       //                 elevation:5,
//                       //                 margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                       //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       //                 child: ClipRRect(
//                       //                     borderRadius: BorderRadius.circular(10),
//                       //                     child: Image.network('${getSellerModel?.data[index].sellerProfile}',fit: BoxFit.fill,)),
//                       //
//                       //               ),
//                       //             ),
//                       //             Container(
//                       //                 width: 60,
//                       //                 height: 20,
//                       //                 child: Text('${getSellerModel?.data[index].sellerName}',textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),))
//                       //           ],
//                       //         );
//                       //       },)
//                       // ):Center(child: CircularProgressIndicator()),
//                       //  Padding(
//                       //   padding: EdgeInsets.only(left: 10.0,right: 10),
//                       //   child: Text('Kids Shoes',style: TextStyle(color: Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),),
//                       // ),
//                       // const SizedBox(height:20,),
//                       // categoriesData?.popularCategories!=null ? Container(
//                       //     height: MediaQuery.of(context).size.height/2.75,
//                       //     width: MediaQuery.of(context).size.width/1,
//                       //     child: ListView.builder(
//                       //       itemCount:categoriesData?.popularCategories.length,
//                       //       scrollDirection: Axis.horizontal,
//                       //       shrinkWrap: true,
//                       //       // physics: NeverScrollableScrollPhysics(),
//                       //       itemBuilder: (context, index) {
//                       //         return Container(
//                       //           width:MediaQuery.of(context).size.width/1.2,
//                       //           child: Card(
//                       //             elevation:5,
//                       //             margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                       //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       //             child: Column(
//                       //               children: [
//                       //                 Container(
//                       //                     height:210,
//                       //                     width:MediaQuery.of(context).size.width/1.3,
//                       //                     decoration: BoxDecoration(
//                       //                         borderRadius: BorderRadius.circular(30)),
//                       //                     child: Image.network('${categoriesData?.popularCategories[index].image}',fit: BoxFit.fill,)),
//                       //                 Padding(
//                       //                   padding: const EdgeInsets.only(left:10.0,top:20),
//                       //                   child: Row(
//                       //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //                     children: [
//                       //                       Container(
//                       //                           width: 60,
//                       //                           height: 20,
//                       //                           child: Text('${categoriesData?.popularCategories[index].name}',textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),)),
//                       //                       Container(
//                       //                           width: 60,
//                       //                           height: 20,
//                       //                           child: Text('${categoriesData?.popularCategories[index].name}',textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Theme.of(context).colorScheme.txtColor,fontSize: 20,fontWeight: FontWeight.bold),))
//                       //                     ],
//                       //                   ),
//                       //                 )
//                       //               ],
//                       //             ),
//                       //
//                       //           ),
//                       //         );
//                       //       },)
//                       //
//                       // ):Center(child: CircularProgressIndicator()),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           )




  Future<void> _refresh() {
    context.read<HomePageProvider>().catLoading = true;
    context.read<HomePageProvider>().secLoading = true;
    context.read<HomePageProvider>().sliderLoading = true;
    context.read<HomePageProvider>().mostLikeLoading = true;
    context.read<HomePageProvider>().offerLoading = true;
    context.read<HomePageProvider>().proIds.clear();
    context.read<HomePageProvider>().sliderList.clear();
    context.read<HomePageProvider>().offerImagesList.clear();
    context.read<HomePageProvider>().sectionList.clear();
    return callApi();
  }

  Future<void> callApi() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    SettingProvider setting =
    Provider.of<SettingProvider>(context, listen: false);

    user.setUserId(setting.userId);

    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      getSetting();
      context.read<HomePageProvider>().getSliderImages();
      context.read<HomePageProvider>().getCategories(context);
      context.read<HomePageProvider>().getOfferImages();
      context.read<HomePageProvider>().getSections();
      context.read<HomePageProvider>().getMostLikeProducts();
      context.read<HomePageProvider>().getMostFavouriteProducts();
    } else {
      if (mounted) {
        setState(
              () {
            isNetworkAvail = false;
          },
        );
      }
    }
    return;
  }

  void getSetting() {
    CUR_USERID = context.read<SettingProvider>().userId;
    context.read<SystemProvider>().getSystemSettings(userID: CUR_USERID).then(
          (systemConfigData) async {
        if (!systemConfigData['error']) {
          //
          //Tag list from system API
          if (systemConfigData['tagList'] != null) {
            context.read<SearchProvider>().tagList =
            systemConfigData['tagList'];
          }
          //check whether app is under maintenance
          if (systemConfigData['isAppUnderMaintenance'] == '1') {
            HomePageDialog.showUnderMaintenanceDialog(context);
          }

          if (CUR_USERID != null) {
            context
                .read<UserProvider>()
                .setCartCount(systemConfigData['cartCount']);
            context
                .read<UserProvider>()
                .setBalance(systemConfigData['userBalance']);
            context
                .read<UserProvider>()
                .setPincode(systemConfigData['pinCode']);

            if (systemConfigData['referCode'] == null ||
                systemConfigData['referCode'] == '' ||
                systemConfigData['referCode']!.isEmpty) {
              generateReferral();
            }

            context.read<HomePageProvider>().getFav(context, setStateNow);
            context.read<CartProvider>().getUserCart(save: '0');
            _getOffFav();
            context.read<CartProvider>().getUserOfflineCart();
          }
          if (systemConfigData['isVersionSystemOn'] == '1') {
            String? androidVersion = systemConfigData['androidVersion'];
            String? iOSVersion = systemConfigData['iOSVersion'];

            PackageInfo packageInfo = await PackageInfo.fromPlatform();

            String version = packageInfo.version;

            final Version currentVersion = Version.parse(version);
            final Version latestVersionAnd = Version.parse(androidVersion!);
            final Version latestVersionIos = Version.parse(iOSVersion!);

            if ((Platform.isAndroid && latestVersionAnd > currentVersion) ||
                (Platform.isIOS && latestVersionIos > currentVersion)) {
              HomePageDialog.showAppUpdateDialog(context);
            }
          }
          setState(() {});
        } else {
          setSnackbar(systemConfigData['message']!, context);
        }
      },
    ).onError(
          (error, stackTrace) {
        setSnackbar(error.toString(), context);
      },
    );
  }

  Future<void>? getDialogForClearCart() {
    HomePageDialog.clearYouCartDialog(context);
  }

  Future<void> _getOffFav() async {
    if (CUR_USERID == null || CUR_USERID == '') {
      List<String>? proIds = (await db.getFav())!;
      if (proIds.isNotEmpty) {
        isNetworkAvail = await isNetworkAvailable();

        if (isNetworkAvail) {
          try {
            var parameter = {'product_ids': proIds.join(',')};

            Response response =
            await post(getProductApi, body: parameter, headers: headers)
                .timeout(const Duration(seconds: timeOut));
            print('______dddddddddddddddddddd____${getProductApi}____${parameter}_____');

            var getdata = json.decode(response.body);
            bool error = getdata['error'];
            if (!error) {
              var data = getdata['data'];

              List<Product> tempList =
              (data as List).map((data) => Product.fromJson(data)).toList();

              context.read<FavoriteProvider>().setFavlist(tempList);
            }
            if (mounted) {
              setState(() {
                context.read<FavoriteProvider>().setLoading(false);
              });
            }
          } on TimeoutException catch (_) {
            setSnackbar(getTranslated(context, 'somethingMSg')!, context);
            context.read<FavoriteProvider>().setLoading(false);
          }
        } else {
          if (mounted) {
            setState(() {
              isNetworkAvail = false;
              context.read<FavoriteProvider>().setLoading(false);
            });
          }
        }
      } else {
        context.read<FavoriteProvider>().setFavlist([]);
        setState(() {
          context.read<FavoriteProvider>().setLoading(false);
        });
      }
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> generateReferral() async {
    String refer = getRandomString(8);

    Map parameter = {
      REFERCODE: refer,
    };

    apiBaseHelper.postAPICall(validateReferalApi, parameter).then(
          (getdata) {
        bool error = getdata['error'];
        if (!error) {
          REFER_CODE = refer;

          Map parameter = {
            USER_ID: CUR_USERID,
            REFERCODE: refer,
          };

          apiBaseHelper.postAPICall(getUpdateUserApi, parameter);
        } else {
          if (count < 5) generateReferral();
          count++;
        }

        context.read<HomePageProvider>().secLoading = false;
      },
      onError: (error) {
        setSnackbar(error.toString(), context);
        context.read<HomePageProvider>().secLoading = false;
      },
    );
  }

  Widget homeShimmer() {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: SingleChildScrollView(
            child: Column(
              children: [
                HorizontalCategoryList.catLoading(context),
                sliderLoading(),
                Section.sectionLoadingShimmer(context),
              ],
            )),
      ),
    );
  }

  Widget sliderLoading() {
    double width = deviceWidth!;
    double height = width / 2;
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.simmerBase,
      highlightColor: Theme.of(context).colorScheme.simmerHigh,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        height: height,
        color: Theme.of(context).colorScheme.white,
      ),
    );
  }

  setStateNoInternate() async {
    context.read<HomePageProvider>().catLoading = true;
    context.read<HomePageProvider>().secLoading = true;
    context.read<HomePageProvider>().offerLoading = true;
    context.read<HomePageProvider>().mostLikeLoading = true;
    context.read<HomePageProvider>().sliderLoading = true;
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
          (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          if (mounted) {
            setState(
                  () {
                isNetworkAvail = true;
              },
            );
          }
          callApi();
        } else {
          await buttonController.reverse();
          if (mounted) setState(() {});
        }
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  Future<bool> onWillPopScope() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      setSnackbar(getTranslated(context, 'Press back again to Exit')!, context);
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Theme.of(context).colorScheme.lightWhite,
        padding: EdgeInsets.fromLTRB(
          10,
          context.watch<HomePageProvider>().getBars ? 10 : 30,
          10,
          0,
        ),
        child: GestureDetector(
          child: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: TextField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.normal,
                ),
                enabled: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.lightWhite,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(circularBorderRadius10),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(circularBorderRadius10),
                    ),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 0, 5.0),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(circularBorderRadius10),
                    ),
                  ),
                  isDense: true,
                  hintText: getTranslated(context, 'searchHint'),
                  hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Theme.of(context).colorScheme.fontColor,
                    fontSize: textFontSize12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      DesignConfiguration.setSvgPath('homepage_search'),
                      height: 15,
                      width: 15,
                        color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)
                    ),
                  ),
                  suffixIcon: Selector<ThemeNotifier, ThemeMode>(
                    selector: (_, themeProvider) =>
                        themeProvider.getThemeMode(),
                    builder: (context, data, child) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: (data == ThemeMode.system &&
                            MediaQuery.of(context).platformBrightness ==
                                Brightness.light) ||
                            data == ThemeMode.light
                            ? SvgPicture.asset(
                          DesignConfiguration.setSvgPath('voice_search'),
                          height: 15,
                          width: 15,
                            color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)
                        )
                            : SvgPicture.asset(
                          DesignConfiguration.setSvgPath(
                              'voice_search_white'),
                          height: 15,
                          width: 15,
                           color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)
                        ),
                      );
                    },
                  ),
                  fillColor: Theme.of(context).colorScheme.white,
                  filled: true,
                ),
              ),
            ),
          ),
          onTap: () async {
            Routes.navigateToSearchScreen(context);
          },
        ),
      ),
    );
  }

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 75;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

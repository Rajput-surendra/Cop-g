import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/Product%20Detail/productDetail.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/Theme.dart';
import 'package:eshop_multivendor/Screen/Profile/MyProfile.dart';
import 'package:eshop_multivendor/Screen/ExploreSection/explore.dart';
import 'package:eshop_multivendor/Screen/Home_page2/home_screen2.dart';
import 'package:eshop_multivendor/Screen/Search/Search.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Helper/String.dart';
import '../../Provider/SettingProvider.dart';
import '../Auth/Login.dart';
import '../Favourite/Favorite.dart';
import '../copg_screen/cop-g_screen.dart';
import '../../widgets/security.dart';
import '../../widgets/systemChromeSettings.dart';
import '../PushNotification/PushNotificationService.dart';
import '../SQLiteData/SqliteData.dart';
import '../../Helper/routes.dart';
import '../../widgets/desing.dart';
import '../Language/languageSettings.dart';
import '../../widgets/networkAvailablity.dart';
import '../../widgets/snackbar.dart';
import '../Cart/Cart.dart';
import '../Cart/Widget/clearTotalCart.dart';
import '../Notification/NotificationLIst.dart';
import '../homePage/homepageNew.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

var db = DatabaseHelper();

class _DashboardPageState extends State<Dashboard>
    with TickerProviderStateMixin {
  int _selBottom = 2;
  late TabController _tabController;

  late StreamSubscription streamSubscription;

  late AnimationController navigationContainerAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void initState() {
    initDynamicLinks();
    _tabController = TabController(
      length: 5,
      vsync: this,
    );


    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);

    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();



    final pushNotificationService = PushNotificationService(
        context: context, tabController: _tabController);
    pushNotificationService.initialise();

    if (_selectedIndex == 4 || _tabController.index ==4) {
      if (settingsProvider.userId == null) {
        toast(getTranslated(context, 'not_login_msg'));
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),),
        );
        _selectedIndex =0;
        _tabController.index  =0;
      }
    }

    // _tabController.addListener(
    //   () {
    //     Future.delayed(const Duration(seconds: 0)).then(
    //       (value) {
    //         if (_tabController.index == 4) {
    //           if (settingsProvider.userId == null) {
    //             toast(getTranslated(context, 'not_login_msg'));
    //             Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),),
    //             );
    //             _tabController.animateTo(0);
    //           }
    //         }
    //       },
    //     );
    //     setState(
    //       () {
    //         _selBottom = _tabController.index;
    //       },
    //     );
    //     if (_tabController.index == 4) {
    //       cartTotalClear(context);
    //     }
    //   },
    // );

    Future.delayed(
      Duration.zero,
      () {
        context.read<HomePageProvider>()
          ..setAnimationController(navigationContainerAnimationController)
          ..setBottomBarOffsetToAnimateController(
              navigationContainerAnimationController)
          ..setAppBarOffsetToAnimateController(
              navigationContainerAnimationController);
      },
    );
    super.initState();
  }

  setSnackBarFunctionForCartMessage() {
    Future.delayed(const Duration(seconds: 5)).then(
      (value) {
        if (homePageSingleSellerMessage) {
          homePageSingleSellerMessage = false;
          showOverlay(
              getTranslated(context,
                  'One of the product is out of stock, We are not able To Add In Cart')!,
              context);
        }
      },
    );
  }

  void initDynamicLinks() async {
    streamSubscription = FirebaseDynamicLinks.instance.onLink.listen(
      (event) {
        final Uri deepLink = event.link;
        if (deepLink.queryParameters.isNotEmpty) {
          int index = int.parse(deepLink.queryParameters['index']!);

          int secPos = int.parse(deepLink.queryParameters['secPos']!);

          String? id = deepLink.queryParameters['id'];

          String? list = deepLink.queryParameters['list'];

          getProduct(id!, index, secPos, list == 'true' ? true : false);
        }
      },
    );
  }

  Future<void> getProduct(String id, int index, int secPos, bool list) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var parameter = {
          ID: id,
        };

        Response response =
            await post(getProductApi, headers: headers, body: parameter)
                .timeout(const Duration(seconds: timeOut));
        log('______dddddddddddddddddddd____${getProductApi}____${parameter}_____');

        var getdata = json.decode(response.body);
        bool error = getdata['error'];
        String msg = getdata['message'];
        if (!error) {
          var data = getdata['data'];

          List<Product> items = [];

          items = (data as List).map((data) => Product.fromJson(data)).toList();
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => ProductDetail(
                index: list ? int.parse(id) : index,
                model: list
                    ? items[0]
                    : context
                        .read<HomePageProvider>()
                        .sectionList[secPos]
                        .productList![index],
                secPos: secPos,
                list: list,
              ),
            ),
          );
        } else {
          if (msg != 'Products Not Found !') setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      {
        if (mounted) {
          setState(
            () {
              isNetworkAvail = false;
            },
          );
        }
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //
  //   return WillPopScope(
  //     onWillPop: () async {
  //       if (_tabController.index != 0) {
  //         _tabController.animateTo(0);
  //         return false;
  //       }
  //       return true;
  //     },
  //     child: Scaffold(
  //       extendBodyBehindAppBar: false,
  //       extendBody: true,
  //       backgroundColor: Theme.of(context).colorScheme.lightWhite,
  //       appBar:
  //       // _selBottom == 0
  //       //     ? _getAppBar()
  //       //     :
  //       PreferredSize(
  //               preferredSize: Size.zero,
  //               child: Container(),
  //             ),
  //       body: SafeArea(
  //         child: TabBarView(
  //           controller: _tabController,
  //           children:  [
  //            // HomeScreen2(),
  //
  //             //AllCategory(),
  //
  //             HomePage(),
  //             Search(fromDashboard: true,),
  //             CopGScreen(),
  //             Favorite(),
  //             MyProfile(),
  //
  //
  //             // Cart(
  //             //   fromBottom: true,
  //             // ),
  //
  //           ],
  //         ),
  //       ),
  //       // floatingActionButton: FloatingActionButton(
  //       //   backgroundColor: Colors.pink,
  //       //   child: const Icon(Icons.add),
  //       //   onPressed: () {
  //       //     Navigator.push(
  //       //       context,
  //       //       CupertinoPageRoute(
  //       //         builder: (context) => const AnimationScreen(),
  //       //       ),
  //       //     );
  //       //   },
  //       // ),
  //       bottomNavigationBar: _getBottomBar(),
  //     ),
  //   );
  // }
  //
  // Widget _getBottomBar() {
  //   Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
  //
  //   return AnimatedContainer(
  //     duration: Duration(
  //       milliseconds: context.watch<HomePageProvider>().getBars ? 500 : 500,
  //     ),
  //     height: context.watch<HomePageProvider>().getBars
  //         ? 100
  //         :100,
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).colorScheme.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Theme.of(context).colorScheme.black26,
  //           blurRadius: 5,
  //         )
  //       ],
  //     ),
  //     child: Selector<ThemeNotifier, ThemeMode>(
  //       selector: (_, themeProvider) => themeProvider.getThemeMode(),
  //       builder: (context, data, child) {
  //         return TabBar(
  //           controller: _tabController,
  //           tabs: [
  //
  //             ///home
  //             Tab(
  //               icon: _selBottom == 0
  //                   ? Image.asset('assets/images/home.png',height:25,width:25,  color:  Theme.of(context).colorScheme.txtColor,)
  //                   : Image.asset('assets/images/home.png',height:25,width:25,),
  //
  //               child: _selBottom == 0 ? Text('${getTranslated(context, 'HOME_LBL')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor,fontSize: 9),):
  //               Text('${getTranslated(context, 'HOME_LBL')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor.withOpacity(0.4), fontSize: 9), ),
  //             ),
  //
  //             ///search
  //             Tab(
  //               icon: _selBottom ==1
  //                   ? Icon(Icons.search, size:25, color:  Theme.of(context).colorScheme.txtColor,)
  //                   : Icon(Icons.search, size:25, color:  Theme.of(context).colorScheme.txtColor.withOpacity(0.4)),
  //
  //               child: _selBottom == 1 ? Text('${getTranslated(context, 'search')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor,fontSize: 9),):
  //               Text('${getTranslated(context, 'search')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor.withOpacity(0.4),fontSize: 9),),
  //             ),
  //
  //             ///cop-g
  //             Tab(
  //               icon: _selBottom ==2
  //                   ? Image.asset('assets/images/cop_g_icon.png',height:25,width:25, )
  //                   : Image.asset('assets/images/png/gray_cop_g.png',height: 25,width: 25,),
  //               child: _selBottom == 2 ? Text('${getTranslated(context, 'COP G')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor,fontSize: 9),):
  //               Text('${getTranslated(context, 'COP G')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor.withOpacity(0.4),fontSize: 9),),
  //             ),
  //
  //             ///wishlist
  //             Tab(
  //               icon: _selBottom ==3
  //                   ? Image.asset('assets/images/wishlist.png',height:25,width:25,color:  Theme.of(context).colorScheme.txtColor,)
  //                   : Image.asset('assets/images/wishlist.png',height: 25,width: 25,),
  //
  //               child: _selBottom == 3 ? Text('${getTranslated(context, 'Wishlist')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor,fontSize: 9),):
  //               Text('${getTranslated(context, 'Wishlist')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor.withOpacity(0.4),fontSize: 9),),
  //             ),
  //
  //             ///profile
  //             Tab(
  //               icon: _selBottom ==4
  //                   ? Image.asset('assets/images/account.png',height:25,width:25,color:  Theme.of(context).colorScheme.txtColor,)
  //                   : Image.asset('assets/images/account.png',height: 25,width: 25,),
  //               child: _selBottom == 4 ? Text('${getTranslated(context, 'ACCOUNT')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor,fontSize: 9),):
  //               Text('${getTranslated(context, 'ACCOUNT')}', style: TextStyle(color:  Theme.of(context).colorScheme.txtColor.withOpacity(0.4),fontSize: 9),),
  //             ),
  //
  //           ],
  //           indicatorColor: Colors.transparent,
  //           labelColor: Theme.of(context).colorScheme.fontColor,
  //           isScrollable: false,
  //           labelStyle: const TextStyle(fontSize: textFontSize12),
  //         );
  //       },
  //     ),
  //   );
  // }
  //
  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }



  // _getAppBar() {
  //   String? title;
  //   if (_selBottom ==1) {
  //     title = getTranslated(context, 'Wishlist');
  //   } else if (_selBottom == 2) {
  //     title = getTranslated(context, 'COP G');
  //   }
  //   else if (_selBottom == 3) {
  //     title = getTranslated(context, 'Shopping');
  //   }
  //   else if (_selBottom == 4) {
  //     title = getTranslated(context, 'ACCOUNT');
  //   }
  //   final appBar = AppBar(
  //     toolbarHeight: 100,
  //     elevation: 0,
  //     centerTitle: false,
  //     automaticallyImplyLeading: false,
  //     backgroundColor: Theme.of(context).colorScheme.white,
  //     title: _selBottom == 0
  //         ? SvgPicture.asset(
  //       DesignConfiguration.setSvgPath('homelogo'),
  //             height: 40,
  //           )
  //         : Text(
  //             title!,
  //             style: const TextStyle(
  //               color: Theme.of(context).colorScheme.fontColor,
  //               fontFamily: 'ubuntu',
  //               fontWeight: FontWeight.normal,
  //             ),
  //           ),
  //     actions: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.only(
  //           left: 10.0,
  //           right: 6.0,
  //           bottom: 10.0,
  //           top: 20.0,),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(circularBorderRadius10),
  //             color: Theme.of(context).colorScheme.lightWhite,
  //           ),
  //           width: 50,
  //           child: IconButton(
  //             icon: SvgPicture.asset(
  //                 DesignConfiguration.setSvgPath('fav_black'),
  //                 color: Theme.of(context)
  //                     .colorScheme
  //                     .black // Add your color here to apply your own color
  //                 ),
  //             onPressed: () {
  //               Routes.navigateToFavoriteScreen(context);
  //             },
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.only(
  //           left: 10.0,
  //           right: 20.0,
  //           bottom: 10.0,
  //           top: 20.0,
  //         ),
  //         child: Container(
  //           // width: 50,
  //           // height: 30,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(circularBorderRadius10),
  //             color: Theme.of(context).colorScheme.lightWhite,
  //           ),
  //
  //           child: IconButton(
  //             icon: SvgPicture.asset(
  //               DesignConfiguration.setSvgPath('notification_black'),
  //               color: Theme.of(context).colorScheme.black,
  //             ),
  //             onPressed: () {
  //               CUR_USERID != null
  //                   ? Navigator.push(
  //                       context,
  //                       CupertinoPageRoute(
  //                         builder: (context) => const NotificationList(),
  //                       ),
  //                     ).then(
  //                       (value) {
  //                         if (value != null && value) {
  //                           _tabController.animateTo(1);
  //                         }
  //                       },
  //                     )
  //                   : Routes.navigateToLoginScreen(context);
  //             },
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  //
  //   return PreferredSize(
  //     preferredSize: appBar.preferredSize,
  //     child: SlideTransition(
  //       position: context.watch<HomePageProvider>().animationAppBarBarOffset,
  //       child: SizedBox(
  //         height: context.watch<HomePageProvider>().getBars ? 100 : 0,
  //         child: appBar,
  //       ),
  //     ),
  //   );
  // }

  // getTabItem(String enabledImage, String disabledImage, int selectedIndex,
  //     String name) {
  //   return Wrap(
  //     children: [
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(top: 4.0),
  //             child: SizedBox(
  //               height: 25,
  //               child: _selBottom == selectedIndex
  //                   ? Lottie.asset(
  //                       DesignConfiguration.setLottiePath(enabledImage),
  //                       repeat: false,
  //                       height: 25,)
  //                   : SvgPicture.asset(
  //                       DesignConfiguration.setSvgPath(disabledImage),
  //                       color: Colors.grey,
  //                       height: 20,
  //                     ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 4.0),
  //             child: Text(
  //               getTranslated(context, name)!,
  //               style: TextStyle(
  //                 color: _selBottom == selectedIndex
  //                     ? Theme.of(context).colorScheme.fontColor
  //                     : Theme.of(context).colorScheme.lightBlack,
  //                 fontWeight: FontWeight.w400,
  //                 fontStyle: FontStyle.normal,
  //                 fontSize: textFontSize10,
  //                 fontFamily: 'ubuntu',
  //               ),
  //               textAlign: TextAlign.center,
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  int _selectedIndex = 0;

  void onItemTapped(int index) {
    print('pressed $_selectedIndex index');
    _selectedIndex = index;

    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    if (_selectedIndex == 4 || _tabController.index ==4) {
      if (settingsProvider.userId == null) {
        toast(getTranslated(context, 'not_login_msg'));
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),),
        );
        _selectedIndex =0;
        _tabController.index  =0;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async {
            if (_selectedIndex != 0) {
              _selectedIndex=0;
              return false;
            }
            return true;
          },
      child: Scaffold(
        body: Center(
          child: [
            HomePage(),
            Search(fromDashboard: true,),
            CopGScreen(),
            Favorite(),
            MyProfile(),
          ].elementAt(_selectedIndex),
        ),

        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.white,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.black26,
                      blurRadius: 5,
                    )
                  ],
          ),
          child: BottomNavigationBar(
            backgroundColor:  Theme.of(context).colorScheme.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 10,
            elevation: 0,
            unselectedFontSize: 10,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Image.asset('assets/images/home.png',height:25,width:25,),
                    Text('${getTranslated(context, 'HOME_LBL')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4)))
                  ],
                ),
                activeIcon:  Column(
                  children: [
                    Image.asset('assets/images/home.png',height:25,width:25,  color:  Theme.of(context).colorScheme.txtColor,),
                    Text('${getTranslated(context, 'HOME_LBL')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor))
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.white,
              ),

              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Icon(Icons.search, size:25, color:  Theme.of(context).colorScheme.txtColor.withOpacity(0.4)),
                    Text('${getTranslated(context, 'search')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4)))
                  ],
                ),
                activeIcon: Column(
                  children: [
                    Icon(Icons.search, size:25, color:  Theme.of(context).colorScheme.txtColor,),
                    Text('${getTranslated(context, 'search')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor))
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.white,
              ),

              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Image.asset('assets/images/png/gray_cop_g.png',height: 25,width: 25,),
                    Text('${getTranslated(context, 'COP G')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4)))
                  ],
                ),
                activeIcon: Column(
                  children: [
                    Image.asset('assets/images/cop_g_icon.png',height:25,width:25, ),
                    Text('${getTranslated(context, 'COP G')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor))
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.white,
              ),

              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Image.asset('assets/images/wishlist.png',height: 25,width: 25,),
                    Text('${getTranslated(context, 'Wishlist')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4)))
                  ],
                ),
                activeIcon: Column(
                  children: [
                    Image.asset('assets/images/wishlist.png',height:25,width:25,color:  Theme.of(context).colorScheme.txtColor,),
                    Text('${getTranslated(context, 'Wishlist')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor))
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.white,
              ),

              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Image.asset('assets/images/account.png',height: 25,width: 25,),
                    Text('${getTranslated(context, 'ACCOUNT')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4)))
                  ],
                ),
                activeIcon: Column(
                  children: [
                    Image.asset('assets/images/account.png',height:25,width:25,color:  Theme.of(context).colorScheme.txtColor,),
                    Text('${getTranslated(context, 'ACCOUNT')}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4)))
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.white,
              ),

            ],
            currentIndex: _selectedIndex,
            selectedItemColor:   Theme.of(context).colorScheme.white,
            onTap: onItemTapped,
          ),
        ),
      ),
    );

  }
}

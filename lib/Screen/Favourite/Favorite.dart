import 'dart:async';
import 'package:eshop_multivendor/Screen/Closet.dart';
import 'package:eshop_multivendor/Screen/SQLiteData/SqliteData.dart';
import 'package:eshop_multivendor/Provider/Favourite/FavoriteProvider.dart';
import 'package:eshop_multivendor/Screen/Favourite/Widget/FavProductData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Helper/Color.dart';
import '../../Helper/String.dart';
import '../../widgets/appBar.dart';
import '../AllItems.dart';
import '../Language/languageSettings.dart';
import '../../widgets/networkAvailablity.dart';
import '../../widgets/simmerEffect.dart';
import '../NoInterNetWidget/NoInterNet.dart';

class Favorite extends StatefulWidget {
  const Favorite({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => StateFav();
}

class StateFav extends State<Favorite> with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController tabController;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ScrollController controller = ScrollController();
  List<String>? proIds;
  var db = DatabaseHelper();
  bool isLoadingMore = false;

  backFromCartFunct() {
    _refresh();
    setState(() {});
  }

  setStateNow() {
    setState(() {});
  }

  callApi() async {

    if (CUR_USERID != null) {
      Future.delayed(Duration.zero).then(
            (value) => context.read<FavoriteProvider>().getFav(isLoadingMore: true, type: '1'),
      );
    } else {
      context.read<FavoriteProvider>().changeStatus(FavStatus.inProgress);
      proIds = (await db.getFav())!;
      context
          .read<FavoriteProvider>()
          .getOfflineFavorateProducts(context, setStateNow)
          .then(
            (value) {
          context.read<FavoriteProvider>().changeStatus(FavStatus.isSuccsess);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    callApi();
    controller.addListener(_scrollListener);
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );

    tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: tabController.index);
    tabController.addListener(() {
      _pageController.animateToPage(
        tabController.index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }



  _scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        !isLoadingMore) {
      if (mounted) {
        if (context.read<FavoriteProvider>().hasMoreData) {
          setState(
            () {
              isLoadingMore = true;
            },
          );

          await context
              .read<FavoriteProvider>()
              .getFav(isLoadingMore: false, type: '1')
              .then(
            (value) {
              setState(
                () {
                  isLoadingMore = false;
                },
              );
            },
          );
        }
      }
    }
  }

  @override
  void dispose() {
    buttonController!.dispose();
    controller.dispose();
    for (int i = 0;
        i < context.read<FavoriteProvider>().controllerText.length;
        i++) {
      context.read<FavoriteProvider>().controllerText[i].dispose();
    }
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Future.delayed(Duration.zero).then(
            (value) =>
                context.read<FavoriteProvider>().getFav(isLoadingMore: false, type: '1'),
          );
        } else {
          await buttonController!.reverse();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
     // Theme.of(context).colorScheme.lightWhite,
      appBar: getAppBar(
          getTranslated(context, 'FAVORITE')!, context, setStateNow, true),
      body: isNetworkAvail
          // ? _showContent(context)
          ? DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: Theme.of(context).colorScheme.white,
                    child: TabBar(
                      controller: tabController,
                      labelColor: Theme.of(context).colorScheme.txtColor,
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .txtColor
                          .withOpacity(0.5),
                      indicator: ShapeDecoration(
                        shape: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blue,
                                width: 3,
                                style: BorderStyle.solid)),
                      ),
                      tabs: <Widget>[
                        Text(
                          'All Items',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Closet',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                      onTap: (index) {
                        tabController.index = index;
                        setState(() {});
                        print('index is ${tabController.index}');
                      },
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        tabController.index = index;
                        setState(() {});
                      },
                      children: [
                        ///All items
                        AllItems(),

                        ///closet
                        Closet()
                      ],
                    ),
                  ),
                ],
              ),
            )
          : NoInterNet(
              buttonController: buttonController,
              buttonSqueezeanimation: buttonSqueezeanimation,
              setStateNoInternate: setStateNoInternate,
            ),
    );
  }

  Future _refresh() async {
    if (mounted) {
      if (CUR_USERID != null) {
        return Future.delayed(Duration.zero).then((value) =>
            context.read<FavoriteProvider>().getFav(isLoadingMore: true, type: '1'));
      } else {
        proIds = (await db.getFav())!;
        return context
            .read<FavoriteProvider>()
            .getOfflineFavorateProducts(context, setStateNow);
      }
    }
  }

  _showContent(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, value, child) {
        if (value.getCurrentStatus == FavStatus.isSuccsess) {
          return value.favoriteList.isEmpty
              ? Center(
                  child: Text(
                    getTranslated(context, 'noFav')!,
                    style: TextStyle(
                      fontFamily: 'ubuntu',
                      color: Theme.of(context).colorScheme.txtColor,
                    ),
                  ),
                )
              : DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        color: Theme.of(context).colorScheme.white,
                        child: TabBar(
                          controller: tabController,
                          labelColor: Theme.of(context).colorScheme.txtColor,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .txtColor
                              .withOpacity(0.5),
                          indicator: ShapeDecoration(
                            shape: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 3,
                                    style: BorderStyle.solid)),
                          ),
                          tabs: <Widget>[
                            Text(
                              'All Items',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Closet',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                          onTap: (index) {
                            tabController.index = index;
                            setState(() {});
                            print('index is ${tabController.index}');
                          },
                        ),
                      ),
                      RefreshIndicator(
                        color: Theme.of(context).colorScheme.fontColor,
                        // key: _refreshIndicatorKey,
                        onRefresh: _refresh,
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowIndicator();
                            return true;
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: controller,
                            itemCount: value.favoriteList.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return (index == value.favoriteList.length &&
                                      isLoadingMore)
                                  ? const SingleItemSimmer()
                                  : FavProductData(
                                      index: index,
                                      favList: value.favoriteList,
                                      updateNow: setStateNow,type: '1',
                                    );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        } else if (value.getCurrentStatus == FavStatus.isFailure) {
          return Center(
            child: Text(
              value.errorMessage,
              style: const TextStyle(
                fontFamily: 'ubuntu',
              ),
            ),
          );
        }
        return const ShimmerEffect();
      },
    );
  }
}

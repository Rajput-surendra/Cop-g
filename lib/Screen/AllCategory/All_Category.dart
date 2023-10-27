import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/NoInterNetWidget/NoInterNet.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Helper/String.dart';
import '../../Model/Section_Model.dart';
import '../../widgets/desing.dart';
import '../Language/languageSettings.dart';
import '../ProductList&SectionView/ProductList.dart';
import '../SubCategory/SubCategory.dart';

class AllCategory extends StatefulWidget {
  const AllCategory({Key? key}) : super(key: key);

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory>
    with TickerProviderStateMixin {
  late AnimationController buttonController;
  late Animation buttonSqueezeanimation;

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
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
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
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
    buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.fontColor,)),
        title:  Text('Categories',style: TextStyle( color: Theme.of(context).colorScheme.fontColor,),),
      ),
      body: !isNetworkAvail
          ? NoInterNet(
              buttonController: buttonController,
              buttonSqueezeanimation: buttonSqueezeanimation,
              setStateNoInternate: setStateNoInternate,
            )
          : Consumer<HomePageProvider>(
              builder: (context, homePageProvider, _) {
                if (homePageProvider.catLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Row(
                  children: [
                    const SizedBox(height: 20,),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Theme.of(context).colorScheme.lightWhite,
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowIndicator();
                            return true;
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding:
                                const EdgeInsetsDirectional.only(top: 10.0),
                            itemCount:
                                context.read<HomePageProvider>().catList.length,
                            itemBuilder: (context, index) {
                              return Selector<CategoryProvider, int>(
                                builder: (context, data, child) {
                                  if (index == 0 &&
                                      (context
                                          .read<HomePageProvider>()
                                          .popularList
                                          .isNotEmpty)) {
                                    return GestureDetector(
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: data == index
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .white
                                              : Colors.transparent,
                                          border: data == index
                                              ?  Border(
                                                  left: BorderSide(
                                                    width: 5.0,
                                                    color: Theme.of(context).colorScheme.blackTxtColor,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        circularBorderRadius25),
                                                child: SvgPicture.asset(
                                                  DesignConfiguration
                                                      .setSvgPath(data == index
                                                          ? 'popular_sel'
                                                          : 'popular'),
                                                  color: Theme.of(context).colorScheme.fontColor,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${context.read<HomePageProvider>().catList[index].name!}\n',
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                    fontFamily: 'ubuntu',
                                                    color: data == index
                                                        ?   Theme.of(context).colorScheme.fontColor
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .fontColor,
                                                  ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        context.read<CategoryProvider>().setCurSelected(index);
                                        context
                                            .read<CategoryProvider>()
                                            .setSubList(
                                              context
                                                  .read<HomePageProvider>()
                                                  .popularList,
                                            );
                                      },
                                    );
                                  } else {
                                    return GestureDetector(
                                      child: Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: data == index
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .white
                                              : Colors.transparent,
                                          border: data == index
                                              ?  Border(
                                                  left: BorderSide(
                                                    width: 5.0,
                                                    color: Theme.of(context).colorScheme.fontColor,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          circularBorderRadius25),
                                                  child: DesignConfiguration
                                                      .getCacheNotworkImage(
                                                    boxFit: BoxFit.fill,
                                                    context: context,
                                                    heightvalue: null,
                                                    widthvalue: null,
                                                    imageurlString: context
                                                        .read<
                                                            HomePageProvider>()
                                                        .catList[index]
                                                        .image!,
                                                    placeHolderSize: null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${context.read<HomePageProvider>().catList[index].name!}\n',
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                    fontFamily: 'ubuntu',
                                                    color: data == index
                                                        ? Theme.of(context).colorScheme.fontColor
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .fontColor,
                                                  ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        context
                                            .read<CategoryProvider>()
                                            .setCurSelected(index);
                                        if (context
                                                    .read<HomePageProvider>()
                                                    .catList[index]
                                                    .subList ==
                                                null ||
                                            context
                                                .read<HomePageProvider>()
                                                .catList[index]
                                                .subList!
                                                .isEmpty) {
                                          context
                                              .read<CategoryProvider>()
                                              .setSubList([]);
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => ProductList(
                                                name: context
                                                    .read<HomePageProvider>()
                                                    .catList[index]
                                                    .name,
                                                id: context
                                                    .read<HomePageProvider>()
                                                    .catList[index]
                                                    .id,
                                                tag: false,
                                                fromSeller: false,
                                              ),
                                            ),
                                          );
                                        } else {
                                          context
                                              .read<CategoryProvider>()
                                              .setSubList(
                                                context
                                                    .read<HomePageProvider>()
                                                    .catList[index]
                                                    .subList,
                                              );
                                        }
                                      },
                                    );
                                  }
                                },
                                selector: (_, cat) => cat.curCat,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: context.read<HomePageProvider>().catList.isNotEmpty
                          ? Column(
                              children: [
                                Selector<CategoryProvider, int>(
                                  builder: (context, data, child) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${context.read<HomePageProvider>().catList[data].name!} ',
                                                style: const TextStyle(
                                                  fontFamily: 'ubuntu',
                                                ),
                                              ),
                                              const Expanded(
                                                child: Divider(
                                                  thickness: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              '${getTranslated(context, 'All')!} ${context.read<HomePageProvider>().catList[data].name!} ',
                                              style: TextStyle(
                                                fontFamily: 'ubuntu',
                                                color: Theme.of(context).colorScheme.fontColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: textFontSize16,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  selector: (_, cat) => cat.curCat,
                                ),
                                Expanded(
                                  child:
                                      Selector<CategoryProvider, List<Product>>(
                                    builder: (context, data, child) {
                                      return data.isNotEmpty
                                          ? NotificationListener<
                                              OverscrollIndicatorNotification>(
                                              onNotification: (overscroll) {
                                                overscroll.disallowIndicator();
                                                return true;
                                              },
                                              child: GridView.count(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                crossAxisCount: 3,
                                                shrinkWrap: true,
                                                childAspectRatio: .6,
                                                children: List.generate(
                                                  data.length,
                                                  (index) {
                                                    return GestureDetector(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 80,
                                                            width: 100,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          circularBorderRadius10),
                                                              child: DesignConfiguration
                                                                  .getCacheNotworkImage(
                                                                boxFit:
                                                                    BoxFit.fill,
                                                                context:
                                                                    context,
                                                                heightvalue:
                                                                    null,
                                                                widthvalue:
                                                                    null,
                                                                imageurlString:
                                                                    data[index]
                                                                        .image!,
                                                                placeHolderSize:
                                                                    null,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Text(
                                                            '${data[index].name!}\n',
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption!
                                                                .copyWith(
                                                                  fontFamily:
                                                                      'ubuntu',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .fontColor,fontSize: 15,
                                                              fontWeight:FontWeight.bold
                                                                ),
                                                          )
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        if (context
                                                                    .read<
                                                                        CategoryProvider>()
                                                                    .curCat ==
                                                                0 &&
                                                            context
                                                                .read<
                                                                    HomePageProvider>()
                                                                .popularList
                                                                .isNotEmpty) {
                                                          if (context
                                                                      .read<
                                                                          HomePageProvider>()
                                                                      .popularList[
                                                                          index]
                                                                      .subList ==
                                                                  null ||
                                                              context
                                                                  .read<
                                                                      HomePageProvider>()
                                                                  .popularList[
                                                                      index]
                                                                  .subList!
                                                                  .isEmpty) {
                                                            Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProductList(
                                                                  name: context
                                                                      .read<
                                                                          HomePageProvider>()
                                                                      .popularList[
                                                                          index]
                                                                      .name,
                                                                  id: context
                                                                      .read<
                                                                          HomePageProvider>()
                                                                      .popularList[
                                                                          index]
                                                                      .id,
                                                                  tag: false,
                                                                  fromSeller:
                                                                      false,
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SubCategory(
                                                                  subList: context
                                                                      .read<
                                                                          HomePageProvider>()
                                                                      .popularList[
                                                                          index]
                                                                      .subList,
                                                                  title: context
                                                                          .read<
                                                                              HomePageProvider>()
                                                                          .popularList[
                                                                              index]
                                                                          .name ??
                                                                      '',
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        } else if (data[index]
                                                                    .subList ==
                                                                null ||
                                                            data[index]
                                                                .subList!
                                                                .isEmpty) {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      ProductList(
                                                                name:
                                                                    data[index]
                                                                        .name,
                                                                id: data[index]
                                                                    .id,
                                                                tag: false,
                                                                fromSeller:
                                                                    false,
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SubCategory(
                                                                subList: data[
                                                                        index]
                                                                    .subList,
                                                                title: data[index]
                                                                        .name ??
                                                                    '',
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                getTranslated(
                                                    context, 'noItem')!,
                                                style: const TextStyle(
                                                  fontFamily: 'ubuntu',
                                                ),
                                              ),
                                            );
                                    },
                                    selector: (_, categoryProvider) =>
                                        categoryProvider.subList,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

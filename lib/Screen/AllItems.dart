import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Helper/Color.dart';
import '../Helper/String.dart';
import '../Provider/Favourite/FavoriteProvider.dart';
import '../Provider/SettingProvider.dart';
import '../widgets/simmerEffect.dart';
import 'Favourite/Widget/FavProductData.dart';
import 'Language/languageSettings.dart';
import 'SQLiteData/SqliteData.dart';


class AllItems extends StatefulWidget {
  const AllItems({Key? key,}) : super(key: key);

  @override
  State<AllItems> createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ScrollController controller = ScrollController();
  List<String>? proIds;
  var db = DatabaseHelper();
  bool isLoadingMore = false;

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

  setStateNow() {
    setState(() {});
  }


  @override
  void initState() {
    callApi();
    super.initState();
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
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: colors.primary,
      body: Consumer<FavoriteProvider>(
        builder: (context, value, child) {
          if (value.getCurrentStatus == FavStatus.isSuccsess) {
            return value.favoriteList.isEmpty
                ? Center(
              child: Text(
                getTranslated(context, 'noFav')!,
                style:  TextStyle(
                  fontFamily: 'ubuntu',
                  color: Theme.of(context).colorScheme.txtColor,
                ),
              ),
            )
                :  RefreshIndicator(
              color: Theme.of(context).colorScheme.fontColor,
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child:   ListView.builder(
                  shrinkWrap: true,
                  controller: controller,
                  itemCount: value.favoriteList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    print('fav list length ${value.favoriteList.length}');

                    return (index == value.favoriteList.length &&
                        isLoadingMore)
                        ? const SingleItemSimmer()
                        : FavProductData(
                      index: index,
                      favList: value.favoriteList,
                      updateNow: setStateNow,
                        fromAllItems: true,
                        type: '1',
                    );
                  },
                ),
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
      )
    );
  }
}

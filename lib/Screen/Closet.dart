import 'package:eshop_multivendor/Screen/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Helper/Color.dart';
import '../Helper/String.dart';
import '../Provider/Favourite/FavoriteProvider.dart';
import '../widgets/simmerEffect.dart';
import 'Favourite/Widget/FavProductData.dart';
import 'Language/languageSettings.dart';
import 'SQLiteData/SqliteData.dart';


class Closet extends StatefulWidget {
  const Closet({Key? key,}) : super(key: key);

  @override
  State<Closet> createState() => _ClosetState();
}

class _ClosetState extends State<Closet> with TickerProviderStateMixin {
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
            context.read<FavoriteProvider>().getFav(isLoadingMore: true, type: '2'));
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
            (value) => context.read<FavoriteProvider>().getFav(isLoadingMore: true, type: '2'),
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
                      return (index == value.favoriteList.length &&
                          isLoadingMore)
                          ? const SingleItemSimmer()
                          : FavProductData(
                        index: index,
                        favList: value.favoriteList,
                        updateNow: setStateNow,
                        type: '2',
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

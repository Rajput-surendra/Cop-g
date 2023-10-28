import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/MyBidOrders.dart';
import 'package:eshop_multivendor/Screen/MyBidProduct.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:flutter/material.dart';


class MyBids extends StatefulWidget {
  const MyBids({Key? key}) : super(key: key);

  @override
  State<MyBids> createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: getSimpleAppBar(getTranslated(context, 'BIDDING_PRODUCT_LIST')!, context),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            ///tabs
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
                    'My Orders',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'My Product',
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

            ///views
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  MyBidOrders(),
                  MyBidProduct(),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }



}

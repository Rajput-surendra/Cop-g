import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/Screen/homePage/widgets/section.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:flutter/material.dart';

import '../Helper/Color.dart';


class AllNormalProduct extends StatefulWidget {
  const AllNormalProduct({Key? key}) : super(key: key);

  @override
  State<AllNormalProduct> createState() => _AllNormalProductState();
}

class _AllNormalProductState extends State<AllNormalProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: getSimpleAppBar(getTranslated(context, 'BUY')!, context),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const Section(),
          ],
        ),
      ),
    );
  }
}

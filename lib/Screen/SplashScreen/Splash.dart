import 'dart:async';
import 'dart:developer';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/IntroSlider/Intro_Slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Helper/String.dart';
import '../../widgets/desing.dart';
import '../../widgets/systemChromeSettings.dart';
import 'dart:math' as math;

//splash screen of app
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool from = false;
  late AnimationController navigationContainerAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  @override
  void initState() {
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();
    initializeAnimationController();
    startTime();
    super.initState();
  }

  void initializeAnimationController() {
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
  }



  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
       body: Stack(
          children: [
            Image.asset(
              DesignConfiguration.setPngPath('doodle'),
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              left: -180,
              right: -180,
              child: Lottie.asset(
                'assets/images/spinner.json',
                height: MediaQuery.of(context).size.height /2,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width / 3,
                top: MediaQuery.of(context).size.height /2.35,
                child: Image.asset(
                  'assets/images/cop_g_icon.png',
                  width: 120,
                  height: 100,
                ),)
          ],
        )
    );

    ///old
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            //decoration: DesignConfiguration.back(),
            color: Theme.of(context).colorScheme.fontColor,
            child: Center(
              child: SvgPicture.asset(
                DesignConfiguration.setSvgPath('splashlogo'),
                width: 150,
                height: 150,
              ),
            ),
          ),
          Image.asset(
            DesignConfiguration.setPngPath('doodle'),
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      ),
    );
  }

  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);

    // bool isFirstTime = await settingsProvider.getPrefrenceBool(ISFIRSTTIME);


    print('user id in splash ${settingsProvider.userId}');
    // if (isFirstTime)
    if (settingsProvider.userId != null)
    {
      setState(
        () {
          from = true;
        },
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(
        () {
          from = false;
        },
      );
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const IntroSlider(),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (from) {
      SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    }
    super.dispose();
  }
}

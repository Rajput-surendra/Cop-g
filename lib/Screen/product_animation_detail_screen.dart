import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class ProductDetailAnimation extends StatefulWidget {
  int index;

  ProductDetailAnimation({Key? key, required this.index, }) : super(key: key);

  @override
  State<ProductDetailAnimation> createState() => _ProductDetailAnimationState();
}

class _ProductDetailAnimationState extends State<ProductDetailAnimation> {

  int selectedIndex = 0;


  Widget build(BuildContext context) {
    // timeDilation =1.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.white,
      body: Stack(
        children: [
          Container(height: double.infinity, width: double.infinity,),

          Positioned(
            top: -180,
            right: -80,
            child: Container(
              width: MediaQuery.of(context).size.width*1.2,
              height: MediaQuery.of(context).size.width*1.2,

              decoration: BoxDecoration(
                  color: widget.index % 2 == 0 ? Color(0xffd48c44) : Color(0xff3555b5),
                borderRadius: BorderRadius.circular(1000)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 20),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          print("backkkkkkkkk");
                          Navigator.pop(context);

                        },
                       behavior: HitTestBehavior.opaque,
                        child: Icon(CupertinoIcons.chevron_back,  color: Theme.of(context).colorScheme.fontColor, size: 35,)),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 0,
            child: AnimatedBuilder(
              animation: AlwaysStoppedAnimation(0.5),
              builder: (BuildContext context, Widget? child) {
                return   Hero(
                tag: 'tag1${widget.index}',
                child: Image.asset( "assets/images/sneak4.png", width: 350,),
                );
              },

            ),
          ),

          ///text
          Positioned(
            top: MediaQuery.of(context).size.width/1.3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Alpha Savage",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.fontColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 130,),
                      Row(
                        children: [
                          Image.asset('assets/images/rupee.png', height: 13,),
                          Text(
                            '1953',
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
                            '2100',
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

                  SizedBox(height: 20,),

                  SizedBox(
                    width: 300,
                    child: Text(
                      "Comforable shoe, proper fit, feels like awesome",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for(int i=0; i< 3; i++)

                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            setState(() {
                              selectedIndex = i; // Update selected index
                            });
                            print("tapped index is $i");
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Container(

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).colorScheme.lightWhite,
                                border:  Border.all(color: i == selectedIndex? Theme.of(context).colorScheme.fontColor: Theme.of(context).colorScheme.lightWhite, width: 1.5 )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Image.asset( "assets/images/sneak1.png", height: 50, width: 50, fit: BoxFit.cover,),
                              )),
                          ),
                        ),



                    ],
                  ),
                  SizedBox(height: 20,),





                ],
              ),
            ),
          ),
          
          
        ],
      ),
    );
  }
}
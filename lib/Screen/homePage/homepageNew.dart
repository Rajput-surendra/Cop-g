import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FixedExtentScrollController _controller = FixedExtentScrollController();
  PageController controller = PageController();
  int _currentItem = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///normal scrolling
      body:PageView(
        controller: controller,
        scrollDirection: Axis.vertical,
        padEnds: false,
        children: [
          for(int i=0; i<6; i++)
          Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/image2.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height/1.1,
                    width: MediaQuery.of(context).size.width ,
                  ),

                  Positioned(
                    top:  MediaQuery.of(context).size.height*0.07,
                    left: MediaQuery.of(context).size.width / 2.5,
                    child: Image.asset(
                      'assets/images/cop_g_icon.png',
                      height: 100,
                      width: 80,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      )

      // ListView.builder(
      //   itemCount: 6,
      //   itemBuilder: (context, index) {
      //     _controller.animateToItem(_currentItem, duration: new Duration(seconds: 1), curve: Curves.ease);
      //     return PageView(
      //       controller: controller,
      //       scrollDirection: Axis.vertical,
      //       padEnds: false,
      //       children: [
      //         Column(
      //           children: [
      //             Stack(
      //               children: [
      //                 Image.asset(
      //                   'assets/images/image2.png',
      //                   fit: BoxFit.cover,
      //                   height: MediaQuery.of(context).size.height / 1.3,
      //                   width: MediaQuery.of(context).size.width ,
      //                 ),
      //
      //                 Positioned(
      //                   top: 10,
      //                   left: MediaQuery.of(context).size.width / 2.5,
      //                   child: Image.asset(
      //                     'assets/images/cop_g_icon.png',
      //                     height: 100,
      //                     width: 80,
      //                   ),
      //                 )
      //               ],
      //             )
      //           ],
      //         ),
      //       ],
      //     );
      //   },
      // ),

      ///wheel scrolling
      // Container(
      //     height: MediaQuery.of(context).size.height/1,

          // child: ListWheelScrollView.useDelegate(
          //     controller: _controller,
          //     diameterRatio: 9,
          //     itemExtent: 600,
          //     physics: FixedExtentScrollPhysics(),
          //     perspective: 0.009,
          //     onSelectedItemChanged: (int index) {
          //       setState(() {
          //         _currentItem = index;
          //       });
          //
          //       print("_currentItem $_currentItem");
          //     },
          //     childDelegate: ListWheelChildBuilderDelegate(
          //       childCount: 10,
          //       builder: (context, index) {
          //         _controller.animateToItem(_currentItem, duration: new Duration(seconds: 1), curve: Curves.ease);
          //         return PageView(
          //           controller: controller,
          //           scrollDirection: Axis.vertical,
          //           padEnds: false,
          //           children: [
          //             Column(
          //               children: [
          //                 Stack(
          //                   children: [
          //                     Image.asset(
          //                       'assets/images/image2.png',
          //                       fit: BoxFit.cover,
          //                       height: MediaQuery.of(context).size.height / 1.3,
          //                       width: MediaQuery.of(context).size.width ,
          //                     ),
          //
          //                     Positioned(
          //                       top: 10,
          //                       left: MediaQuery.of(context).size.width / 2.5,
          //                       child: Image.asset(
          //                         'assets/images/cop_g_icon.png',
          //                         height: 100,
          //                         width: 80,
          //                       ),
          //                     )
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ],
          //         );
          //       },
          //     ))
      // ),

    );
  }

}



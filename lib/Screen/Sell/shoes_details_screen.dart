import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/submit_legit_check_screen.dart';
import 'package:eshop_multivendor/widgets/networkAvailablity.dart';
import 'package:eshop_multivendor/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Helper/Color.dart';
import '../../widgets/appBar.dart';
import '../Language/languageSettings.dart';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;


var q;
bool imageDeleted=false;
var scannedtext = 'No Data';

class ShoesDetailsScreen extends StatefulWidget {
  Map modelDetail;
  String cat_id;
  String product_id;
  String catImage;
  ShoesDetailsScreen({Key? key, required this.modelDetail, required this.cat_id, required this.product_id, required this.catImage}) : super(key: key);

  @override
  State<ShoesDetailsScreen> createState() => _ShoesDetailsScreenState();
}

class _ShoesDetailsScreenState extends State<ShoesDetailsScreen> {
bool loading = false;
String? appearance ;
String inside_label ="";
String? insole ;
String insole_stitc ="";
String box_label ="";
String? data_code ;
String? additional ;
List<File> selectedimage=[];
bool isCheck = false;


  legitCheckApi() async {
    SettingProvider settingsProvider = Provider.of<SettingProvider>(context, listen: false);
    if(appearance == null){
      toast('Please scan image for appearance');
    }else if(inside_label == ''){
      toast('Please scan bar code or qr code for inside label');
    }else if(insole == null){
      toast('Please scan image for insole');
    }else if(insole_stitc == ''){
      toast('Please  scan bar code or qr code for insole stitc..');
    }else if(box_label == '' && isCheck == false){
      toast('Please scan bar code or qr code for Box label');
    }else if(data_code == null && isCheck == false){
      toast('Please scan image for data code');
    }else{
      isNetworkAvail = await isNetworkAvailable();

      if (isNetworkAvail) {
        setState(() {loading = true;});

        var request = await http.MultipartRequest("POST", check_productsApi);

        request.fields.addAll({
          'cat_id': widget.cat_id.toString() ,
          'product_id': widget.product_id.toString() ,
          'user_id': settingsProvider.userId! ,
          'appearance': appearance??'' ,
          'inside_label': inside_label,
          'insole': insole??'',
          'insole_stitc': insole_stitc,
          'box_label': box_label,
          'data_code': data_code??'',
          'additional': additional??'',
        });

        if (selectedimage != null || selectedimage.length != 0) {
          for(int i=0; i<selectedimage.length; i++)
          request.files.add(await http.MultipartFile.fromPath('image[$i]', selectedimage[i].path));
        }

        print("check_productsApi_is__ ${check_productsApi} & params___${request.fields} image_________${selectedimage}");

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsonResponse = convert.jsonDecode(responseString);

        setState(() {loading = false;});

        if (jsonResponse['error'] == false) {
          appearance ='';
          inside_label ="";
          insole ='';
          insole_stitc ="";
          box_label ="";
          data_code ='';
          additional ='' ;
          selectedimage=[];
          scannedtext='';
          image = null;
          so = null;
          od = null;
          di = null;
          toast('${jsonResponse['message']}');
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitCheck(status: jsonResponse['data']['status'],)));

          print("check_productsApi_response_is_______ ${jsonResponse}");
        }
        else {
          appearance ='';
          inside_label ="";
          insole ='';
          insole_stitc ="";
          box_label ="";
          data_code ='';
          additional ='' ;
          selectedimage=[];
          scannedtext='';
          image = null;
          so = null;
          od = null;
          di = null;
          toast('${jsonResponse['message']}');
        }
      } else {
        toast('Something went wrong');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

     backgroundColor: colors.primary,

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2,),
                Container(
                height: 110,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.lightWhite,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10,top: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){

                              Navigator.pop(context);
                            },
                              child: Icon(Icons.arrow_back_ios_new,size: 20,color: Theme.of(context).colorScheme.fontColor,)),
                          SizedBox(width: 5,),
                          Text("SELECT A CHECK",style: TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize: 13),),

                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Image.asset("assets/images/details.png",height: 50,color: colors.whiteTemp,),
                    ),
                    Divider(
                      color: colors.black54.withOpacity(0.2),
                      thickness: 1,
                    ),
                  ],
                ),
              ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.modelDetail['name']??''}", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),),
                        SizedBox(height: 8,),

                      ],
                    ),
                      CachedNetworkImage(
                        width: 40,
                        imageUrl: "${widget.catImage}",
                        fit: BoxFit.fill,
                        color: colors.whiteTemp
                        //Theme.of(context).colorScheme.blackTxtColor,
                      ),
                      // Image.asset("assets/images/nikerighrt.png",height: 50,  color: Theme.of(context).colorScheme.fontColor,)
                    ],
                  ),
                ),
                Text("UPLOAD PRODUCT IMAGE" ,style: TextStyle(color: Theme.of(context).colorScheme.fontColor,fontWeight: FontWeight.bold),),
              Divider(
                color: colors.black54.withOpacity(0.2),
                thickness: 1,
              ),
                 uploadImages(),

              Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor:
                      Theme.of(context).colorScheme.blackTxtColor,
                    ),
                    child: Checkbox(
                        value: isCheck,
                        activeColor: Theme.of(context).colorScheme.blackTxtColor,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheck = value!;
                            print("isCheck_________${isCheck}");
                          });
                        }),
                  ),
                  Text("No Box" ,style: TextStyle(color: Theme.of(context).colorScheme.fontColor, fontSize: 14),),

                ],
              )


            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: RoundEdgedButton(
            text: 'Check',
            isLoad: loading,
            loaderColor: Theme.of(context).colorScheme.fontColor,
            onTap: (){
              legitCheckApi();
            },
          ),
        ),
      ),
    );
  }

  File? image;
  File? nl;
  File? so;
  File? it;
  File? ab;
  File? od;
  File? di;

  scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR,);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      scannedtext = barcodeScanRes;
    });

    print('_scanBarcode result is ${scannedtext}');
    return barcodeScanRes;
  }


  Future gallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    print('image in gallery func: $imageTemporary');
    setState(() {
      this.image = imageTemporary;
      selectedimage.add(imageTemporary);
    });
    print('image in gallery after assigning: $imageTemporary');
    print('image in gallery after assigning: ${selectedimage.length}');
  }

  Future In() async {
    final nl = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (nl == null) return;
    final imageTemporary = File(nl.path);
    print('$imageTemporary');
    setState(() {
      this.nl = imageTemporary;
    });
  }

  Future ns() async {
    final nl = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (nl == null) return;
    final imageTemporary = File(nl.path);
    print('$imageTemporary');
    setState(() {
      this.so = imageTemporary;
      selectedimage.add(imageTemporary);
    });
    print("selectedimage__${selectedimage.length} $selectedimage");

  }

  Future st() async {
    final nl = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (nl == null) return;
    final imageTemporary = File(nl.path);
    print('$imageTemporary');
    setState(() {
      this.it = imageTemporary;
    });
  }

  Future bl() async {
    final nl = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (nl == null) return;
    final imageTemporary = File(nl.path);
    print('$imageTemporary');
    setState(() {
      this.ab = imageTemporary;
    });
  }

  Future dc() async {
    final nl = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (nl == null) return;
    final imageTemporary = File(nl.path);
    print('$imageTemporary');
    setState(() {
      this.od = imageTemporary;
      selectedimage.add(imageTemporary);
    });
    print("selectedimage__${selectedimage.length} $selectedimage");

  }

  Future ad() async {
    final nl = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (nl == null) return;
    final imageTemporary = File(nl.path);
    print('$imageTemporary');
    setState(() {
      this.di = imageTemporary;
      selectedimage.add(imageTemporary);
    });

    print("selectedimage__${selectedimage.length} $selectedimage");

  }
  Widget uploadImages(){
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.2,
                height: MediaQuery.of(context).size.height / 7,
                child: Card(
                  color: Theme.of(context).colorScheme.blackTxtColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),

                  child: Stack(children: [
                    Opacity(
                        opacity: 1,
                        child: image != null
                            ? Stack(
                          children: [
                            Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                                )),
                            Positioned(
                              top: 63,left: 0,
                              right: 0,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        image = null;
                                        imageDeleted = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).colorScheme.redDark,
                                    )),
                              ),
                            ),
                          ],
                        )
                            : Stack(
                          children: [
                            Center(
                                child: Image.asset('assets/images/appearance.png',scale: 2,)),
                            Positioned(
                              top: 63,left: 0,
                              right: 0,
                              child: Center(
                                child: IconButton(
                                    onPressed: () async {
                                      await gallery();
                                      if(image != null)
                                        appearance = await text(XFile(image!.path.toString()));

                                      print("appearance_______________$appearance");
                                    },
                                    icon: Icon(
                                        Icons.add_circle_outlined,color: Theme.of(context).colorScheme.fontColor,)),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 2.0, top: 5, left: 5),
                        child: GestureDetector(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              height: MediaQuery.of(context).size.height / 40,
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(child: Text("Appearance", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),))),
                        )
                      // ElevatedButton(onPressed: (){}, child: Text("Appearance")),
                    ),
                  ]),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.2,
                height: MediaQuery.of(context).size.height / 7,
                child: Card(
                  color: Theme.of(context).colorScheme.blackTxtColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),

                  child: Stack(children: [
                    Opacity(
                        opacity: 1,
                        child: inside_label != ''
                            ? Stack(
                          children: [
                            Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.blackTxtColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child:
                                ClipRRect(borderRadius: BorderRadius.circular(20),child:
                                Center(child: SizedBox(
                                  width: 80,
                                  child: Wrap(
                                    children: [
                                      Text('${inside_label}', style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),),
                                    ],
                                  ),
                                ))
                                )),
                           Positioned(
                             top: 63,left: 0,
                             right: 0,
                             child:
                           Center(
                             child: IconButton(
                                 onPressed: () {
                                   setState(() {
                                     // nl = null;
                                     // imageDeleted = true;
                                     inside_label='';
                                   });
                                 },
                                 icon: Icon(
                                   Icons.delete,
                                   color: Theme.of(context).colorScheme.redDark,
                                 )),
                           ),
                           )
                          ],
                        )
                            : Stack(
                          children: [
                            Center(
                                child: Image.asset('assets/images/inside-label.png',scale: 2,)),
                            Positioned(
                              top: 63,left: 0,
                              right: 0,
                              child: Center(
                                child: IconButton(
                                    onPressed: () async {
                                      // await In();
                                      // if(nl != null)
                                      //   text(XFile(nl!.path.toString()));
                                      ///scanning barcode
                                      inside_label = await scanQR();
                                    },
                                    icon: Icon(
                                        Icons.add_circle_outlined,color: Theme.of(context).colorScheme.fontColor,)),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 2.0, top: 5, left: 5),
                        child: GestureDetector(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              height: MediaQuery.of(context).size.height / 40,
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(child: Text("inside label", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),))),
                        )
                      // ElevatedButton(onPressed: (){}, child: Text("Appearance")),
                    ),
                  ]),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.2,
                height: MediaQuery.of(context).size.height / 7,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Theme.of(context).colorScheme.blackTxtColor,
                  child: Stack(children: [
                    Opacity(
                        opacity: 1,
                        child: so != null
                            ? Stack(
                          children: [
                            Container(
                                width: double.infinity,
                                height: double.infinity,
                                child:
                                ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.file(so!, fit: BoxFit.cover))),
                            Positioned(
                              top: 63,left: 0,
                              right: 0,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        so = null;
                                        imageDeleted = true;

                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).colorScheme.redDark,
                                    )),
                              ),
                            ),
                          ],
                        )
                            : Stack(
                          children: [
                            Center(
                                child: Image.asset(

                                    'assets/images/insole.png',scale: 2,)),
                            Positioned(
                              top: 63,left: 0,
                              right: 0,
                              child: Center(
                                child: IconButton(
                                    onPressed: () async {
                                      await ns();
                                      if(so != null)
                                        insole = await  text(XFile(so!.path.toString()));


                                    },
                                    icon: Icon(
                                        Icons.add_circle_outlined, color: Theme.of(context).colorScheme.fontColor,)),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 2.0, top: 5, left: 5),
                        child: GestureDetector(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 7,
                              height: MediaQuery.of(context).size.height / 40,
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(child: Text("insole", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),))),
                        )
                      // ElevatedButton(onPressed: (){}, child: Text("Appearance")),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.2,
                height: MediaQuery.of(context).size.height / 7,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Theme.of(context).colorScheme.blackTxtColor,
                  child: Stack(children: [
                    Opacity(
                      opacity: 1,
                      child: Center(
                          child: insole_stitc != ''
                              ? Stack(
                            children: [
                              Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),child:
                                  Center(child: SizedBox(
                                    width: 80,
                                    child: Wrap(
                                      children: [
                                        Text('${insole_stitc}', style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),),
                                      ],
                                    ),
                                  ))
                                  )),
                              Positioned(
                                top: 63,left: 0,
                                right: 0,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          // it = null;
                                          // imageDeleted = true;
                                          insole_stitc = "";
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).colorScheme.redDark,
                                      )),
                                ),
                              ),
                            ],
                          )
                              : Stack(
                            children: [
                              Center(
                                  child: Image.asset(

                                      'assets/images/inside-label.png',scale: 2,)),
                              Positioned(
                                top: 63,left: 0,
                                right: 0,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () async {
                                        // await st();
                                        // if(it != null)
                                        //   scanned_data['insole stic'] =  text(XFile(it!.path.toString()));
                                        ///scanning barcode
                                        insole_stitc = await scanQR();
                                      },
                                      icon: Icon(Icons.add_circle, color: Theme.of(context).colorScheme.fontColor,)),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 2.0, top: 5, left: 5),
                        child: GestureDetector(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              height: MediaQuery.of(context).size.height / 40,
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(child: Text("insole stitc..", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),))),
                        )
                      // ElevatedButton(onPressed: (){}, child: Text("Appearance")),
                    ),
                  ]),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width / 3.2,
                height: MediaQuery.of(context).size.height / 7,
                child: Card(
                  color: Theme.of(context).colorScheme.blackTxtColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),

                  child: Stack(children: [
                    Opacity(
                      opacity:  isCheck == true? 0.2 : 1,
                      child: Center(
                          child: box_label != ''
                              ? Stack(
                            children: [
                              Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ClipRRect(borderRadius:BorderRadius.circular(20) ,
                                    child:   Center(child: SizedBox(
                                      width: 80,
                                      child: Wrap(
                                        children: [
                                          Text('${box_label}', style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),),
                                        ],
                                      ),
                                    ))
                                  )),
                              Positioned(
                                top: 63,left: 0,
                                right: 0,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          // ab = null;
                                          // imageDeleted = true;
                                          box_label ='';
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).colorScheme.redDark,
                                      )),
                                ),
                              ),
                            ],
                          )
                              : Stack(
                            children: [
                              Center(
                                  child:Image.asset('assets/images/inside-label.png',scale: 2,)),
                              Positioned(
                                top: 63,left: 0,
                                right: 0,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () async {
                                        if(isCheck == false){
                                          ///scanning barcode
                                          box_label = await scanQR();
                                        }
                                        // await bl();
                                        // if(ab != null)
                                        //   scanned_data['appearance'] =  text(XFile(ab!.path.toString()));

                                      },
                                      icon: Icon(
                                        Icons.add_circle_outlined,
                                        color: Theme.of(context).colorScheme.fontColor,
                                      )),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 2.0, top: 5, left: 5),
                        child: GestureDetector(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              height: MediaQuery.of(context).size.height / 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(child: Text("Box label", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),))),
                        )
                      // ElevatedButton(onPressed: (){}, child: Text("Appearance")),
                    ),
                  ]),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.2,
                height: MediaQuery.of(context).size.height / 7,
                child: Card(
                  color: Theme.of(context).colorScheme.blackTxtColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),

                  child: Stack(children: [
                    Opacity(
                      opacity:isCheck == true? 0.2 : 1,
                      child: Center(
                          child: od != null
                              ? Stack(
                            children: [
                              Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      child: Image.file(od!,
                                          fit: BoxFit.cover))),
                              Positioned(
                                top: 63,left: 0,
                                right: 0,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          od = null;
                                          imageDeleted = true;

                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).colorScheme.redDark,
                                      )),
                                ),
                              ),
                            ],
                          )
                              : Stack(
                            children: [
                              Center(
                                  child: Image.asset(

                                      'assets/images/date-code.png', scale: 2,)),
                              Positioned(
                                top: 63,left: 0,
                                right: 0,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () async {
                                        if(isCheck == false){
                                          await dc();
                                          if(od != null)
                                            data_code = await  text(XFile(od!.path.toString()));
                                        }

                                      },
                                      icon: Icon(
                                          Icons.add_circle_outlined, color: Theme.of(context).colorScheme.fontColor,)),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 2.0, top: 5, left: 5),
                        child: GestureDetector(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 5,
                              height: MediaQuery.of(context).size.height / 40,
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(child: Text("Data code", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),))),
                        )
                      // ElevatedButton(onPressed: (){}, child: Text("Appearance")),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7.0, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.2,
                height: MediaQuery.of(context).size.height / 7,
                child: Card(
                  color: Theme.of(context).colorScheme.blackTxtColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),

                  child: Stack(children: [
                    Opacity(
                      opacity: 1,
                      child: Center(
                          child: di != null
                              ? Stack(
                            children: [
                              Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      child: Image.file(di!,
                                          fit: BoxFit.cover))),
                              Positioned(
                                top: 63,left: 0,
                                right: 0,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          di = null;
                                          imageDeleted = true;

                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).colorScheme.redDark,
                                      )),
                                ),
                              ),
                            ],
                          )
                              : Stack(
                            children: [
                              Center(
                                  child: Image.asset(

                                      'assets/images/additional.png',   scale: 2,)),
                                  Positioned(
                                    top: 63,left: 0,
                                    right: 0,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () async {
                                        await ad();
                                        if(di != null)
                                          additional = await  text(XFile(di!.path.toString()));
                                      },
                                      icon: Icon(
                                          Icons.add_circle_outlined, color: Theme.of(context).colorScheme.fontColor,)),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 2.0, top: 5, left: 5),
                        child: GestureDetector(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              height: MediaQuery.of(context).size.height / 40,
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(child: Text("Additonal", style: TextStyle(color: Theme.of(context).colorScheme.fontColor,),))),
                        )
                      // ElevatedButton(onPressed: (){}, child: Text("Appearance")),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),


    // imageDeleted == true? Container() :
    // Card(
    //         color: colors.whiteTemp,
    //         elevation: 3,
    //         child:Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: scannedtext == ""? Text('No Data Found..!!') : Text(scannedtext),
    //         )
    //
    //     )
      ],
    );
  }

  text(XFile nl) async{
    final input= InputImage.fromFilePath( nl.path);
    final text =GoogleMlKit.vision.textRecognizer();
    scannedtext = "";
    imageDeleted = false;
    RecognizedText recognizedtext = await text.processImage(input);
    await text.close();
    for (TextBlock block in recognizedtext.blocks){
      for( TextLine line in block.lines){
        scannedtext =scannedtext+line.text +"\n";
        setState(() {
          q=scannedtext;

        });
        print(q);
      }
    }

    print('==========================================${scannedtext.runtimeType} $scannedtext');



    return scannedtext;
  }
}

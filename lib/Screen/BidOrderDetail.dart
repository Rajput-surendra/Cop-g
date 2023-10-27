import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/Screen/Language/languageSettings.dart';
import 'package:eshop_multivendor/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class BidOrderDetail extends StatefulWidget {
  Map orderDetail;
  BidOrderDetail({Key? key, required this.orderDetail}) : super(key: key);

  @override
  State<BidOrderDetail> createState() => _BidOrderDetailState();
}

class _BidOrderDetailState extends State<BidOrderDetail> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm a');
  Future<List<Directory>?>? externalStorageDirectories;

  @override
  void initState() {
    externalStorageDirectories = getExternalStorageDirectories(type: StorageDirectory.documents);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppBar(getTranslated(context, 'ORDER_DETAIL')!, context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, 'ORDER_ID_LBL')!}- ${widget.orderDetail['id']}",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor),
                          ),
                          Text(
                            "${DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.parse(widget.orderDetail['created_at'].toString()))}",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 05,),
                      Text(
                        "${getTranslated(context, 'EMAILHINT_LBL')!}- ${widget.orderDetail['user_email']??''}",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.fontColor),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),

              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 100,
                              width: 100,
                              imageUrl:
                              "${imageUrl}${widget.orderDetail['image']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                               widget.orderDetail['product_name'].toString(),
                                style:  TextStyle(fontSize: textFontSize12,
                                  color:  Theme.of(context).colorScheme.fontColor ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Price: ',
                                    style:  TextStyle(fontSize: textFontSize12,
                                        color:  Theme.of(context).colorScheme.fontColor.withOpacity(0.5) ),
                                  ),
                                  Text(
                                    widget.orderDetail['final_price'].toString(),
                                    style:  TextStyle(fontSize: textFontSize12,
                                        color:  Theme.of(context).colorScheme.fontColor ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),


                            ],
                          )
                        ],
                      ),


                      Divider(color: Theme.of(context).colorScheme.fontColor,),
                      SizedBox(height: 10,),


                      if(widget.orderDetail['order_status'] != null || widget.orderDetail['order_status'].toString() != '4')
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: widget.orderDetail['order_status'].toString() == "0" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                                  size: 15,
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 3, left: 10),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getTranslated(context, 'ORDER_PLACED')!,
                                        style:  TextStyle(fontSize: textFontSize8,
                                          color: widget.orderDetail['order_status'].toString() == "0" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),),
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.parse(widget.orderDetail['updated_at'].toString())),
                                        style:  TextStyle(fontSize: textFontSize8,
                                          color: widget.orderDetail['order_status'].toString() == "0" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: VerticalDivider(
                                        thickness: 2,
                                        color: widget.orderDetail['order_status'].toString() == "1" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                                      ),
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: widget.orderDetail['order_status'].toString() == "1" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                                      size: 15,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 3, left: 10),
                                  child:  Text(
                                    getTranslated(context, 'ORDER_PROCESSED')!,
                                    style:  TextStyle(fontSize: textFontSize8,
                                      color: widget.orderDetail['order_status'].toString() == "1" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: VerticalDivider(
                                        thickness: 2,
                                        color: widget.orderDetail['order_status'].toString() == "2" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                                      ),
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: widget.orderDetail['order_status'].toString() == "2" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                                      size: 15,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 3, left: 10),
                                  child:  Text(
                                    getTranslated(context, 'ORDER_SHIPPED')!,
                                    style:  TextStyle(fontSize: textFontSize8,
                                      color: widget.orderDetail['order_status'].toString() == "2" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),),

                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: VerticalDivider(
                                        thickness: 2,
                                        color: widget.orderDetail['order_status'].toString() == "3" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                                      ),
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: widget.orderDetail['order_status'].toString() == "3" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),
                                      size: 15,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 3, left: 10),
                                  child:  Text(
                                    getTranslated(context, 'ORDER_DELIVERED')!,
                                    style:  TextStyle(fontSize: textFontSize8,
                                      color: widget.orderDetail['order_status'].toString() == "3" ? Theme.of(context).colorScheme.fontColor : Theme.of(context).colorScheme.fontColor.withOpacity(0.5),),

                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      if(widget.orderDetail['order_status'] != null && widget.orderDetail['order_status'].toString() == '4')
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.circle,
                              color: Theme.of(context).colorScheme.fontColor ,
                              size: 15,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 3, left: 10),
                              child:  Text(
                                getTranslated(context, 'ORDER_CANCLED')!,
                                style:  TextStyle(fontSize: textFontSize8,
                                  color:  Theme.of(context).colorScheme.fontColor ),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 10,),



                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              // dwnInvoice(externalStorageDirectories),
              // SizedBox(height: 10,),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getTranslated(context, 'SHIPPING_DETAIL')!}",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.fontColor),
                      ),
                      SizedBox(height: 05,),
                      Divider(color: Theme.of(context).colorScheme.fontColor,),
                      Text(
                        "${widget.orderDetail['address']}, ${widget.orderDetail['city']}, ${widget.orderDetail['area']}, ${widget.orderDetail['state']}, ${widget.orderDetail['country']}",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.fontColor),
                      ),
                      SizedBox(height: 05,),
                      Text(
                        "${widget.orderDetail['user_mobile']}",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.fontColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getTranslated(context, 'PRICE_DETAIL')!}",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context).colorScheme.fontColor),
                      ),
                      SizedBox(height: 05,),
                      Divider(color: Theme.of(context).colorScheme.fontColor,),
                      SizedBox(height: 05,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Original Price: ",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)),
                          ),
                          Text(
                            "${widget.orderDetail['product_price']}",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 05,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Final Price: ",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)),
                          ),
                          Text(
                            "${widget.orderDetail['final_price']}",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 05,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, 'DELIVERY_CHARGE')!}: ",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)),
                          ),
                          Text(
                            "0",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 05,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, 'TOTAL_PRICE')!}: ",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor.withOpacity(0.5)),
                          ),
                          Text(
                            "${widget.orderDetail['final_price']}",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: Theme.of(context).colorScheme.fontColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      )

    );
  }

  dwnInvoice(
      Future<List<Directory>?>? _externalStorageDirectories,
      ) {
    return FutureBuilder<List<Directory>?>(
      future: _externalStorageDirectories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Card(
          elevation: 0,
          child: InkWell(
            child: ListTile(
              dense: true,
              trailing:  Icon(
                Icons.keyboard_arrow_right,
                color: Theme.of(context).colorScheme.fontColor,
              ),
              leading:  Icon(
                Icons.receipt,
                color: Theme.of(context).colorScheme.fontColor,
              ),
              title: Text(
                getTranslated(context, 'DWNLD_INVOICE')!,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Theme.of(context).colorScheme.lightBlack),
              ),
            ),
            onTap: () async {
              final status = await Permission.storage.request();

              if (status == PermissionStatus.granted) {
                // context.read<UpdateOrdProvider>().changeStatus(UpdateOrdStatus.inProgress);
                // updateNow();
              }
              var targetPath;

              if (Platform.isIOS) {
                var target = await getApplicationDocumentsDirectory();
                targetPath = target.path.toString();
              } else {
                if (snapshot.hasData) {
                  targetPath = (snapshot.data as List<Directory>).first.path;
                }
              }
              var targetFileName = 'Invoice_${widget.orderDetail['id']}';
              var generatedPdfFile, filePath;
              try {
                generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(widget.orderDetail['invoice']!, targetPath, targetFileName);
                filePath = generatedPdfFile.path;
              } catch (e) {
                // context.read<UpdateOrdProvider>().changeStatus(UpdateOrdStatus.inProgress);
                // updateNow();
                toast(getTranslated(context, "somethingMSg")!);
                return;
              }
              // context.read<UpdateOrdProvider>().changeStatus(UpdateOrdStatus.isSuccsess);
              // updateNow();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${getTranslated(context, 'INVOICE_PATH')} $targetFileName",
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(color: Theme.of(context).colorScheme.black),
                  ),
                  action: SnackBarAction(
                    label: getTranslated(context, 'VIEW')!,
                    textColor: Theme.of(context).colorScheme.fontColor,
                    onPressed: () async {
                      await OpenFilex.open(filePath);
                    },
                  ),
                  backgroundColor: Theme.of(context).colorScheme.white,
                  elevation: 1.0,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

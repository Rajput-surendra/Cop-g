import 'package:eshop_multivendor/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Helper/Color.dart';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;



class SubmitCheck extends StatefulWidget {
  String status;
  SubmitCheck({Key? key, required this.status}) : super(key: key);

  @override
  State<SubmitCheck> createState() => _SubmitCheckState();
}

class _SubmitCheckState extends State<SubmitCheck> {
  bool loading = false;




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.lightWhite,

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.lightWhite,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
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
                      child: Image.asset("assets/images/SUBMIT.png",height: 50,),
                    ),
                    Divider(
                      color: colors.black54.withOpacity(0.2),
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              widget.status == "0"?
              Card(
                color: Colors.yellow,
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Text('50% Matched..!!'),
                ),
              ):
              Card(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Text('100% Matched..!!'),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: RoundEdgedButton(
            text: 'Submit',
            isLoad: loading,
            loaderColor: Theme.of(context).colorScheme.fontColor,
            onTap: (){
            },
          ),
        ),
      ),
    );
  }

}

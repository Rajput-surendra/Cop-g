import 'dart:async';
import 'package:eshop_multivendor/Helper/toast.dart';
import 'package:eshop_multivendor/repository/promoCodeRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Helper/Constant.dart';
import '../Helper/String.dart';
import '../Model/Section_Model.dart';
import '../Screen/Language/languageSettings.dart';
import '../widgets/networkAvailablity.dart';
import '../widgets/snackbar.dart';
import 'CartProvider.dart';

enum PromoCodeStatus {
  initial,
  inProgress,
  isSuccsess,
  isFailure,
  isMoreLoading,
}

class PromoCodeProvider extends ChangeNotifier {
  PromoCodeStatus _transactionStatus = PromoCodeStatus.initial;
  List<Promo> promoCodeList = [];
  String errorMessage = '';
  int _promoCodeListOffset = 0;
  final int _promoCodePerPage = perPage;

  bool hasMoreData = false;

  get getCurrentStatus => _transactionStatus;

  changeStatus(PromoCodeStatus status) {
    _transactionStatus = status;
    notifyListeners();
  }
  List product_id = [];

  //
  //This method is used to fetchPromoCodes
  Future<void> getPromoCodes({required bool isLoadingMore}) async {
    try {
      if (isLoadingMore) {
        changeStatus(PromoCodeStatus.inProgress);
      }

      var parameter = {
        LIMIT: _promoCodePerPage.toString(),
        OFFSET: _promoCodeListOffset.toString(),
      };

      Map<String, dynamic> result = await PromoCodeRepository.fetchPromoCodes(parameter: parameter);
      List<Promo> tempList = [];

      print("promoCodeList['promo_codes']__________${result}");


      for (var element in (result['promoCodeList'] as List)) {
        tempList.add(element);
      }

      print("promoCodeList['promo_codes']__________${tempList}");

      promoCodeList.addAll(tempList);


      for(int i=0; i<promoCodeList.length; i++){

        if(promoCodeList[i].products?.length != 0 || promoCodeList[i].products != null){

          for(int j=0; j<promoCodeList[i].products!.length; j++){
            product_id.add(promoCodeList[i].products?[j].id);
            print("product_id_______________${product_id}");
          }
        }
      }
      print("product_id_______________1${product_id}");

      if (int.parse(result['totalPromoCodes']) > _promoCodeListOffset) {
        _promoCodeListOffset += _promoCodePerPage;
        hasMoreData = true;
      } else {
        hasMoreData = false;
      }
      changeStatus(PromoCodeStatus.isSuccsess);
    } catch (e) {
      errorMessage = e.toString();
      changeStatus(PromoCodeStatus.isFailure);
    }
  }

  Future<void> validatePromocode({
    required bool check,
    required BuildContext context,
    required Function update,
    required String promocode,
    required List product_id,
    required List price,

  }) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        context.read<CartProvider>().setProgress(true);
        if (check) {
          if (context.read<CartProvider>().checkoutState != null)
            context.read<CartProvider>().checkoutState!(() {});
        }
        update();
        var parameter = {
          USER_ID: CUR_USERID,
          PROMOCODE: promocode,
          'product_id': product_id?.join(","),
          'product_price': price?.join(","),
          FINAL_TOTAL: context.read<CartProvider>().oriPrice.toString()
        };
        print("parameter_validate__________${parameter}");

        dynamic result =
            await PromoCodeRepository.validatePromoCodes(parameter: parameter);
        validateProRes = result;

        bool error = result['error'];
        String? msg = result['message'];
        if (!error) {
          var data = result['data'][0];

          context.read<CartProvider>().totalPrice =
              double.parse(data['final_total']) +
                  context.read<CartProvider>().deliveryCharge;
          context.read<CartProvider>().promoAmt =
              double.parse(data['final_discount']);
          context.read<CartProvider>().promocode = data['promo_code'];
          context.read<CartProvider>().isPromoValid = true;
          context.read<CartProvider>().isPromoLen = false;
          toast(getTranslated(context, 'PROMO_SUCCESS')!);
        } else {
          context.read<CartProvider>().isPromoValid = false;
          context.read<CartProvider>().promoAmt = 0;
          context.read<CartProvider>().promocode = null;
          context.read<CartProvider>().promoC.clear();
          context.read<CartProvider>().isPromoLen = false;
          var data = result['data'];
          context.read<CartProvider>().totalPrice =
              double.parse(data['final_total']) +
                  context.read<CartProvider>().deliveryCharge;

          toast(msg!);
        }
        if (context.read<CartProvider>().isUseWallet!) {
          context.read<CartProvider>().remWalBal = 0;
          context.read<CartProvider>().payMethod = null;
          context.read<CartProvider>().usedBalance = 0;
          context.read<CartProvider>().isUseWallet = false;
          context.read<CartProvider>().isPayLayShow = true;

          context.read<CartProvider>().selectedMethod = null;
          context.read<CartProvider>().setProgress(false);
          if (check) context.read<CartProvider>().checkoutState!(() {});
          update();
        } else {
          if (check) context.read<CartProvider>().checkoutState!(() {});
          update();
          context.read<CartProvider>().setProgress(false);
        }
      } on TimeoutException catch (_) {
        context.read<CartProvider>().setProgress(false);
        if (check) context.read<CartProvider>().checkoutState!(() {});
        update();
        toast(getTranslated(context, 'somethingMSg')!);
      }
    } else {
      isNetworkAvail = false;
      if (check) context.read<CartProvider>().checkoutState!(() {});
      update();
    }
  }

Map? validateProRes;

  Future<void> validatePromo(
    String promo,
    BuildContext context,
    Function update,
    Function? parentUpdate,
    Function callShowOverlayMethod,
   List product_ids,
   List product_price,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        context.read<CartProvider>().setProgress(true);

        update();
        var parameter = {
          USER_ID: CUR_USERID,
          PROMOCODE: promo,
          'product_id': product_ids.join(","),
          'product_price': product_price.join(","),
          FINAL_TOTAL: context.read<CartProvider>().oriPrice.toString()
        };
        print("parameter_____${parameter}");


        dynamic result = await PromoCodeRepository.validatePromoCodes(parameter: parameter);
        print("dataresult_____${result}");
        validateProRes = result;

        bool error = result['error'];
        String? msg = result['message'];
        if (!error) {
          var data = result['data'][0];
          print("data0_____${data}");



          if(data['final_total'] != null)
          context.read<CartProvider>().totalPrice = double.parse(data['final_total']) + context.read<CartProvider>().deliveryCharge;

          if(data['final_discount'] != null)
            context.read<CartProvider>().promoAmt = double.parse(data['final_discount']);

          context.read<CartProvider>().promocode = data['promo_code'];

          context.read<CartProvider>().isPromoValid = true;
          parentUpdate!(promo);


          callShowOverlayMethod();
        } else {
          context.read<CartProvider>().isPromoValid = false;
          context.read<CartProvider>().promoAmt = 0;
          context.read<CartProvider>().promocode = null;

          var data = result['data'];
          toast('${result['message']}');

          print("data_____${data}");

          context.read<CartProvider>().totalPrice = double.parse(data['final_total']) + context.read<CartProvider>().deliveryCharge;

          showOverlay(msg!, context);
        }
        if (context.read<CartProvider>().isUseWallet!) {
          context.read<CartProvider>().remWalBal = 0;
          context.read<CartProvider>().payMethod = null;
          context.read<CartProvider>().usedBalance = 0;
          context.read<CartProvider>().isUseWallet = false;
          context.read<CartProvider>().isPayLayShow = true;
          context.read<CartProvider>().selectedMethod = null;
          context.read<CartProvider>().setProgress(false);
          update();
        } else {
          update();
          context.read<CartProvider>().setProgress(false);
        }
      } on TimeoutException catch (_) {
        context.read<CartProvider>().setProgress(false);

        update();
        toast(getTranslated(context, 'somethingMSg')!);
      }
    } else {
      isNetworkAvail = false;

      update();
    }
  }
}

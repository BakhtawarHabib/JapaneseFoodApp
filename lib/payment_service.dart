import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;

  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      "sk_test_51HBbXhHTIh7tnEw8BuodwoVGrjyqihGyWc9nBLWTIAfe7gCZLU6BXMQf7wpSUtU08HYn4935Ea3n2PN0PVUA9GRD00PyL3pm6k";
  static Map<String, String> headers = {
    'Authorization': "Bearer ${StripeService.secret}",
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  ///Stripe service initializer
  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
        'pk_test_51HBbXhHTIh7tnEw8ZJJVJYVqIEyYX3Owq7vff9x2755OgMI4yKgpj7gOMqNbIDvhtQWnDqPKvnRdDZJffwWbK8PB000jVgGnBg',
        merchantId: 'test',
        androidPayMode: 'test'));
  }
//
//  static StripeTransactionResponse payViaExistingCard(
//      {String amount, String currency, card}) {
//    return StripeTransactionResponse(
//        message: 'Transaction successful', success: true);
//  }

  ///Payment via new cart Function operator
  static Future<StripeTransactionResponse> payViaNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent = await StripeService.createPaymentIntent(
          amount: amount,currency: currency
      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded'){
        return StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      }else{

        return StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    }
    catch (err) {
      return StripeTransactionResponse(
          message: 'Transaction failed: ' + err.toString(), success: false);
    }
  }


  ///Payment Intent Creater
  static Future<Map<String,dynamic>> createPaymentIntent({String amount, String currency}) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.paymentApiUrl, body: body, headers: StripeService.headers);

      return jsonDecode(response.body);

    } catch (err) {
      print('Error charing user: ${err.toString()}');
    }
    return null;
  }

  ///platform exception handler
  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
        message: message,
        success: false
    );
  }
}

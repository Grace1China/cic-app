import 'package:in_app_purchase/in_app_purchase.dart';

class IAPUtils{
  static String description(PurchaseDetails purchaseDetails){
    return """
-------purchaseg购买信息----------:
{
  productID:${purchaseDetails.productID},
  status：${purchaseDetails.status},
  error：${purchaseDetails.error},
  purchaseID:${purchaseDetails.purchaseID},
  verificationData：${purchaseDetails.verificationData},
  transactionDate：${purchaseDetails.transactionDate},
  transactionIdentifier：${purchaseDetails.skPaymentTransaction.transactionIdentifier},
  originalTransaction：${purchaseDetails.skPaymentTransaction.originalTransaction},
  transactionState：${purchaseDetails.skPaymentTransaction.transactionState},
  transactionTimeStamp：${purchaseDetails.skPaymentTransaction.transactionTimeStamp}.
} \n
        """;
  }
}
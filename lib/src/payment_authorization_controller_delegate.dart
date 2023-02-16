import 'dart:async';

import 'package:apple_pay_mimic/apple_pay_mimic.dart';

class PKPaymentAuthorizationControllerDelegate {
  const PKPaymentAuthorizationControllerDelegate();

  // iOS 10
  FutureOr<void> didFinish() {}

  // iOS 10
  FutureOr<PKPaymentAuthorizationResult> didAuthorizePayment(PKPayment payment) {
    throw UnimplementedError();
  }

  // iOS 10
  FutureOr<void> willAuthorizePayment() {}

  // iOS 14
  FutureOr<PKPaymentRequestMerchantSessionUpdate> didRequestMerchantSessionUpdate() {
    throw UnimplementedError();
  }

  // iOS 10
  FutureOr<PKPaymentRequestShippingMethodUpdate> didSelectShippingMethod(PKShippingMethod shippingMethod) {
    throw UnimplementedError();
  }

  // iOS 10
  FutureOr<PKPaymentRequestShippingContactUpdate> didSelectShippingContact(PKContact contact) {
    throw UnimplementedError();
  }

  // iOS 10
  FutureOr<PKPaymentRequestPaymentMethodUpdate> didSelectPaymentMethod(PKPaymentMethod paymentMethod) {
    throw UnimplementedError();
  }

  FutureOr<PKPaymentRequestCouponCodeUpdate> didChangeCouponCode(String couponCode) {
    throw UnimplementedError();
  }
}

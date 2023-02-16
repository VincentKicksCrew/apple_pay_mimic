import 'dart:async';

import 'package:apple_pay_mimic/apple_pay_mimic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  ApplePayMimic.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _showError(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text("Can't make a payment"),
          actions: [
            CupertinoDialogAction(
              child: Text('Sad news'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final merchantCapabilities = [PKMerchantCapability.capability3DS];
    final contactFields = [PKContactField.postalAddress]; // required fields

    final items = [
      PKPaymentSummaryItem(label: 'Book "Harry Potter"', amount: 22.5),
      PKPaymentSummaryItem(label: "Pencil case", amount: 3),
    ];
    final bonusItemsInGermany = [
      PKPaymentSummaryItem(label: 'Tape FREE BONUS', amount: 0),
    ];
    final allowedShippingCountries = [
      'Germany',
      'Russia',
    ];
    final shippingMethods = [
      PKShippingMethod(
        label: "Standard shipping",
        amount: 0,
        identifier: "free",
        detail: "May take 7-10 days",
      ),
      PKShippingMethod(
        label: "Fast shipping",
        amount: 5,
        identifier: "paid",
        detail: "1-2 days estimated",
      ),
    ];

    final canMakePayments = await ApplePayMimic.canMakePayments();
    final availableNetworks = await ApplePayMimic.availableNetworks();
    final canMakePaymentsCard = await ApplePayMimic.canMakePayments(CanMakePaymentsRequest(
      usingNetworks: availableNetworks,
      capabilities: merchantCapabilities,
    ));

    if (!canMakePayments || !canMakePaymentsCard) {
      await _showError(context);
    }

    final delegate = PaymentDelegate(
        items: items,
        shippingMethods: shippingMethods,
        allowedShippingCountries: allowedShippingCountries,
        bonusItemsInGermany: bonusItemsInGermany,
        onChangeCouponCode: (couponCode) async {
          return true;
        });
    final request = ProcessPaymentRequest(
      merchantIdentifier: 'MERCHANT ID',
      countryCode: 'US',
      currencyCode: 'USD',
      shippingType: PKShippingType.shipping,
      merchantCapabilities: merchantCapabilities,
      requiredShippingContactFields: contactFields,
      paymentSummaryItems: PaymentDelegate.withTotal(items),
      supportedNetworks: availableNetworks,
      shippingMethods: shippingMethods,
      supportsCouponCode: true,
    );

    ApplePayMimic.processPayment(
      request: request,
      delegate: delegate,
      onError: (error) {
        print(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => _onPressed(context),
              child: Text('PAY'),
            ),
          ),
        );
      }),
    );
  }
}

class PaymentDelegate extends PKPaymentAuthorizationControllerDelegate {
  final List<PKPaymentSummaryItem> items;
  final List<PKPaymentSummaryItem> bonusItemsInGermany;
  final List<PKShippingMethod> shippingMethods;
  final List<String> allowedShippingCountries;
  final Future<bool> Function(String) onChangeCouponCode;

  String country = '';

  PaymentDelegate({
    required this.items,
    required this.shippingMethods,
    required this.bonusItemsInGermany,
    required this.allowedShippingCountries,
    required this.onChangeCouponCode,
  });

  static List<PKPaymentSummaryItem> withTotal(List<PKPaymentSummaryItem> items) {
    final total = PKPaymentSummaryItem(label: 'Total', amount: items.map((e) => e.amount).reduce((a, b) => a + b));
    return List.of(items)..add(total);
  }

  @override
  FutureOr<void> didFinish() {}

  @override
  FutureOr<PKPaymentRequestPaymentMethodUpdate> didSelectPaymentMethod(PKPaymentMethod paymentMethod) {
    final items = List.of(this.items);
    if (country == 'Germany') {
      items.addAll(bonusItemsInGermany);
    }
    return PKPaymentRequestPaymentMethodUpdate(
      status: PKPaymentAuthStatus.success,
      paymentSummaryItems: withTotal(items),
    );
  }

  @override
  FutureOr<PKPaymentRequestCouponCodeUpdate> didChangeCouponCode(String couponCode) async {
    final items = List.of(this.items);

    print('coupon code: $couponCode');

    bool isValid = await onChangeCouponCode(couponCode.trim());

    if (isValid) {
      items.add(PKPaymentSummaryItem(label: couponCode, amount: 10));
      return PKPaymentRequestCouponCodeUpdate(
        status: PKPaymentAuthStatus.success,
        paymentSummaryItems: withTotal(items),
        shippingMethods: [],
      );
    } else {
      return PKPaymentRequestCouponCodeUpdate(
        status: PKPaymentAuthStatus.failure,
        paymentSummaryItems: withTotal(items),
        shippingMethods: [],
      );
    }
  }

  @override
  FutureOr<PKPaymentRequestShippingContactUpdate> didSelectShippingContact(PKContact contact) {
    final items = List.of(this.items);

    if (!allowedShippingCountries.contains(contact.postalAddress?.country)) {
      return PKPaymentRequestShippingContactUpdate(
        status: PKPaymentAuthStatus.failure,
        paymentSummaryItems: items,
        shippingMethods: shippingMethods,
        errors: [
          PKPaymentError.shippingAddressUnserviceable(postalAddressKey: ApplePayConstants.postalAddressCountryKey),
        ],
      );
    }

    country = contact.postalAddress?.country ?? '';
    if (country == 'Germany') {
      items.addAll(bonusItemsInGermany);
    }

    return PKPaymentRequestShippingContactUpdate(
      status: PKPaymentAuthStatus.success,
      paymentSummaryItems: withTotal(items),
      shippingMethods: shippingMethods,
    );
  }

  @override
  FutureOr<PKPaymentRequestShippingMethodUpdate> didSelectShippingMethod(PKShippingMethod shippingMethod) {
    final items = List.of(this.items);

    if (shippingMethod.amount > 0) {
      items.add(PKPaymentSummaryItem(label: shippingMethod.label, amount: shippingMethod.amount));
    }

    return PKPaymentRequestShippingMethodUpdate(
      status: PKPaymentAuthStatus.success,
      paymentSummaryItems: withTotal(items),
    );
  }

  @override
  FutureOr<PKPaymentRequestMerchantSessionUpdate> didRequestMerchantSessionUpdate() {
    return PKPaymentRequestMerchantSessionUpdate(
      status: PKPaymentAuthStatus.success,
    );
  }

  @override
  FutureOr<void> willAuthorizePayment() {}

  @override
  FutureOr<PKPaymentAuthorizationResult> didAuthorizePayment(PKPayment payment) {
    return PKPaymentAuthorizationResult(
      status: PKPaymentAuthStatus.success,
    );
  }
}

import 'entities.dart';

class CanMakePaymentsRequest {
  final List<PKPaymentNetwork>? usingNetworks;
  final List<PKMerchantCapability>? capabilities;

  const CanMakePaymentsRequest({this.usingNetworks, this.capabilities});

  Map toJson() => {
        'usingNetworks': usingNetworks?.map((e) => e.toJson()).toList(),
        'capabilities': capabilities?.map((e) => e.toJson()).toList(),
      };
}

class ProcessPaymentRequest {
  final String merchantIdentifier;
  final String countryCode;
  final String currencyCode;
  final List<PKPaymentNetwork> supportedNetworks;
  final List<PKMerchantCapability> merchantCapabilities;
  final List<PKPaymentSummaryItem> paymentSummaryItems;
  final List<PKContactField>? requiredBillingContactFields;
  final List<PKContactField>? requiredShippingContactFields;
  final PKContact? billingContact;
  final PKContact? shippingContact;
  final List<PKShippingMethod>? shippingMethods;
  final PKShippingType shippingType;
  final String? applicationData;
  final List<String>? supportedCountries;
  final bool? supportsCouponCode;

  const ProcessPaymentRequest({
    required this.merchantIdentifier,
    required this.countryCode,
    required this.currencyCode,
    required this.supportedNetworks,
    required this.merchantCapabilities,
    required this.paymentSummaryItems,
    this.requiredBillingContactFields,
    this.requiredShippingContactFields,
    this.billingContact,
    this.shippingContact,
    this.shippingMethods,
    required this.shippingType,
    this.applicationData,
    this.supportedCountries,
    this.supportsCouponCode,
  });

  Map toJson() => {
        'merchantIdentifier': merchantIdentifier,
        'countryCode': countryCode,
        'currencyCode': currencyCode,
        'supportedNetworks': supportedNetworks.map((e) => e.toJson()).toList(),
        'merchantCapabilities': merchantCapabilities.map((e) => e.toJson()).toList(),
        'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
        'requiredBillingContactFields': requiredBillingContactFields?.map((e) => e.toJson()).toList(),
        'requiredShippingContactFields': requiredShippingContactFields?.map((e) => e.toJson()).toList(),
        'billingContact': billingContact?.toJson(),
        'shippingContact': shippingContact?.toJson(),
        'shippingMethods': shippingMethods?.map((e) => e.toJson()).toList(),
        'shippingType': shippingType.toJson(),
        'applicationData': applicationData,
        'supportedCountries': supportedCountries,
        'supportsCouponCode': supportsCouponCode,
      };
}

class ChangeCouponCodeRequest {
  final int id;
  final String couponCode;

  const ChangeCouponCodeRequest({required this.id, required this.couponCode});

  static ChangeCouponCodeRequest fromJson(Map map) {
    return ChangeCouponCodeRequest(
      id: map['id'] as int,
      couponCode: map['couponCode'] as String,
    );
  }
}

class SelectPaymentMethodRequest {
  final int id;
  final PKPaymentMethod paymentMethod;

  const SelectPaymentMethodRequest({required this.id, required this.paymentMethod});

  static SelectPaymentMethodRequest fromJson(Map map) {
    return SelectPaymentMethodRequest(
      id: map['id'] as int,
      paymentMethod: PKPaymentMethod.fromJson(map['paymentMethod'] as Map),
    );
  }
}

class SelectShippingContactRequest {
  final int id;
  final PKContact shippingContact;

  const SelectShippingContactRequest({required this.id, required this.shippingContact});

  static SelectShippingContactRequest fromJson(Map map) {
    return SelectShippingContactRequest(
      id: map['id'] as int,
      shippingContact: PKContact.fromJson(map['shippingContact'] as Map),
    );
  }
}

class SelectShippingMethodRequest {
  final int id;
  final PKShippingMethod shippingMethod;

  const SelectShippingMethodRequest({required this.id, required this.shippingMethod});

  static SelectShippingMethodRequest fromJson(Map map) {
    return SelectShippingMethodRequest(
      id: map['id'] as int,
      shippingMethod: PKShippingMethod.fromJson(map['shippingMethod'] as Map),
    );
  }
}

class AuthorizePaymentRequest {
  final int id;
  final PKPayment payment;

  const AuthorizePaymentRequest({required this.id, required this.payment});

  static AuthorizePaymentRequest fromJson(Map map) {
    return AuthorizePaymentRequest(
      id: map['id'] as int,
      payment: PKPayment.fromJson(map['payment'] as Map),
    );
  }
}

class PKPaymentAuthStatus {
  final int value;

  const PKPaymentAuthStatus(this.value);

  static PKPaymentAuthStatus fromJson(Map map) => PKPaymentAuthStatus(map['value'] as int);

  Map toJson() => {'value': value};

  static const success = PKPaymentAuthStatus(0);
  static const failure = PKPaymentAuthStatus(1);
}

class PKPaymentNetwork {
  final String value;

  const PKPaymentNetwork(this.value);

  static PKPaymentNetwork fromJson(Map map) => PKPaymentNetwork(map['value'] as String);

  Map toJson() => {'value': value};

  static const carteBancaire = PKPaymentNetwork("carteBancaire");
  static const carteBancaires = PKPaymentNetwork("carteBancaires");
  static const cartesBancaires = PKPaymentNetwork("cartesBancaires");
  static const chinaUnionPay = PKPaymentNetwork("chinaUnionPay");
  static const discover = PKPaymentNetwork("discover");
  static const eftpos = PKPaymentNetwork("eftpos");
  static const electron = PKPaymentNetwork("electron");
  static const elo = PKPaymentNetwork("elo");
  static const idCredit = PKPaymentNetwork("idCredit");
  static const interac = PKPaymentNetwork("interac");
  static const JCB = PKPaymentNetwork("JCB");
  static const mada = PKPaymentNetwork("mada");
  static const maestro = PKPaymentNetwork("maestro");
  static const masterCard = PKPaymentNetwork("masterCard");
  static const privateLabel = PKPaymentNetwork("privateLabel");
  static const quicPay = PKPaymentNetwork("quicPay");
  static const suica = PKPaymentNetwork("suica");
  static const visa = PKPaymentNetwork("visa");
  static const vPay = PKPaymentNetwork("vPay");
  static const barcode = PKPaymentNetwork("barcode");
  static const girocard = PKPaymentNetwork("girocard");
  static const amex = PKPaymentNetwork("amex");
}

class PKMerchantCapability {
  final String value;

  const PKMerchantCapability(this.value);

  static PKMerchantCapability fromJson(Map map) => PKMerchantCapability(map['value'] as String);

  Map toJson() => {'value': value};

  static const capability3DS = PKMerchantCapability("capability3DS");
  static const capabilityEMV = PKMerchantCapability("capabilityEMV");
  static const capabilityCredit = PKMerchantCapability("capabilityCredit");
  static const capabilityDebit = PKMerchantCapability("capabilityDebit");
}

class PKShippingType {
  final String value;

  const PKShippingType(this.value);

  static PKShippingType fromJson(Map map) => PKShippingType(map['value'] as String);

  Map toJson() => {'value': value};

  static const shipping = PKShippingType("shipping");
  static const delivery = PKShippingType("delivery");
  static const storePickup = PKShippingType("storePickup");
  static const servicePickup = PKShippingType("servicePickup");
}

class PKContactField {
  final String value;

  const PKContactField(this.value);

  static PKContactField fromJson(Map map) => PKContactField(map['value'] as String);

  Map toJson() => {'value': value};

  static const postalAddress = PKContactField("postalAddress");
  static const emailAddress = PKContactField("emailAddress");
  static const phoneNumber = PKContactField("phoneNumber");
  static const name = PKContactField("name");
  static const phoneticName = PKContactField("phoneticName");

  static const List<PKContactField> all = [postalAddress, emailAddress, phoneNumber, name, phoneticName];
}

class PKPaymentSummaryItemType {
  final int value;

  const PKPaymentSummaryItemType(this.value);

  static PKPaymentSummaryItemType fromJson(Map map) => PKPaymentSummaryItemType(map['value'] as int);

  Map toJson() => {'value': value};

  static const finall = PKPaymentSummaryItemType(0);
  static const pending = PKPaymentSummaryItemType(1);
}

class PKPaymentMethodType {
  final int value;

  const PKPaymentMethodType(this.value);

  static PKPaymentMethodType fromJson(Map map) => PKPaymentMethodType(map['value'] as int);

  Map toJson() => {'value': value};

  static const unknown = PKPaymentSummaryItemType(0);
  static const debit = PKPaymentSummaryItemType(1);
  static const credit = PKPaymentSummaryItemType(0);
  static const prepaid = PKPaymentSummaryItemType(1);
  static const store = PKPaymentSummaryItemType(0);
}

class PKPaymentMethod {
  final String? displayName;
  final PKPaymentNetwork? network;
  final PKPaymentMethodType type;

  const PKPaymentMethod({this.displayName, this.network, required this.type});

  static PKPaymentMethod fromJson(Map map) => PKPaymentMethod(
        displayName: map['displayName'] as String?,
        network: map['network'] != null ? PKPaymentNetwork.fromJson(map['network'] as Map) : null,
        type: PKPaymentMethodType.fromJson(map['type'] as Map),
      );
}

class PKPaymentSummaryItem {
  final String label;
  final double amount;
  final PKPaymentSummaryItemType type;

  const PKPaymentSummaryItem({
    required this.label,
    required this.amount,
    this.type = PKPaymentSummaryItemType.finall,
  });

  static PKPaymentSummaryItem fromJson(Map map) {
    return PKPaymentSummaryItem(
      label: map['label'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: PKPaymentSummaryItemType.fromJson(map['type'] as Map),
    );
  }

  Map toJson() => {'label': label, 'amount': amount, 'type': type.toJson()};
}

class PKShippingMethod {
  final String label;
  final double amount;
  final PKPaymentSummaryItemType type;
  final String? identifier;
  final String? detail;

  const PKShippingMethod({
    required this.label,
    required this.amount,
    this.type = PKPaymentSummaryItemType.finall,
    this.identifier,
    this.detail,
  });

  static PKShippingMethod fromJson(Map map) {
    return PKShippingMethod(
      label: map['label'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: PKPaymentSummaryItemType.fromJson(map['type'] as Map),
      identifier: map['identifier'] as String?,
      detail: map['detail'] as String?,
    );
  }

  Map toJson() => {
        'label': label,
        'amount': amount,
        'type': type.toJson(),
        'identifier': identifier,
        'detail': detail,
      };
}

class PersonNameComponents {
  final String? namePrefix;
  final String? givenName;
  final String? middleName;
  final String? familyName;
  final String? nameSuffix;
  final String? nickname;
  final PersonNameComponents? phoneticRepresentation;

  const PersonNameComponents({
    this.namePrefix,
    this.givenName,
    this.middleName,
    this.familyName,
    this.nameSuffix,
    this.nickname,
    this.phoneticRepresentation,
  });

  static PersonNameComponents fromJson(Map map) {
    return PersonNameComponents(
      namePrefix: map['namePrefix'] as String?,
      givenName: map['givenName'] as String?,
      middleName: map['middleName'] as String?,
      familyName: map['familyName'] as String?,
      nameSuffix: map['nameSuffix'] as String?,
      nickname: map['nickname'] as String?,
      phoneticRepresentation: map['phoneticRepresentation'] != null ? PersonNameComponents.fromJson(map['phoneticRepresentation'] as Map) : null,
    );
  }

  Map toJson() => {
        'namePrefix': namePrefix,
        'givenName': givenName,
        'middleName': middleName,
        'familyName': familyName,
        'nameSuffix': nameSuffix,
        'nickname': nickname,
        'phoneticRepresentation': phoneticRepresentation?.toJson(),
      };
}

class CNPostalAddress {
  final String street;
  final String subLocality;
  final String city;
  final String subAdministrativeArea;
  final String state;
  final String postalCode;
  final String country;
  final String isoCountryCode;

  const CNPostalAddress({
    required this.street,
    required this.subLocality,
    required this.city,
    required this.subAdministrativeArea,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isoCountryCode,
  });

  static CNPostalAddress fromJson(Map map) {
    return CNPostalAddress(
      street: map['street'] as String,
      subLocality: map['subLocality'] as String,
      city: map['city'] as String,
      subAdministrativeArea: map['subAdministrativeArea'] as String,
      state: map['state'] as String,
      postalCode: map['postalCode'] as String,
      country: map['country'] as String,
      isoCountryCode: map['isoCountryCode'] as String,
    );
  }

  Map toJson() => {
        'street': street,
        'subLocality': subLocality,
        'city': city,
        'subAdministrativeArea': subAdministrativeArea,
        'state': state,
        'postalCode': postalCode,
        'country': country,
        'isoCountryCode': isoCountryCode,
      };
}

class PKContact {
  final PersonNameComponents? name;
  final CNPostalAddress? postalAddress;
  final String? phoneNumber;
  final String? emailAddress;

  const PKContact({this.name, this.postalAddress, this.phoneNumber, this.emailAddress});

  static PKContact fromJson(Map map) {
    return PKContact(
      name: map['name'] != null ? PersonNameComponents.fromJson(map['name'] as Map) : null,
      postalAddress: map['postalAddress'] != null ? CNPostalAddress.fromJson(map['postalAddress'] as Map) : null,
      phoneNumber: map['phoneNumber'] as String?,
      emailAddress: map['emailAddress'] as String?,
    );
  }

  Map toJson() => {
        'name': name?.toJson(),
        'postalAddress': postalAddress?.toJson(),
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
      };
}

class PKPaymentToken {
  final PKPaymentMethod paymentMethod;
  final String transactionIdentifier;
  final String paymentData;

  const PKPaymentToken({required this.paymentMethod, required this.transactionIdentifier, required this.paymentData});

  static PKPaymentToken fromJson(Map map) {
    return PKPaymentToken(
      paymentMethod: PKPaymentMethod.fromJson(map['paymentMethod'] as Map),
      transactionIdentifier: map['transactionIdentifier'] as String,
      paymentData: map['paymentData'] as String,
    );
  }
}

class PKPayment {
  final PKPaymentToken token;
  final PKContact? billingContact;
  final PKContact? shippingContact;
  final PKShippingMethod? shippingMethod;

  const PKPayment({required this.token, this.billingContact, this.shippingContact, this.shippingMethod});

  static PKPayment fromJson(Map map) {
    return PKPayment(
      token: PKPaymentToken.fromJson(map['token'] as Map),
      billingContact: map['billingContact'] != null ? PKContact.fromJson(map['billingContact'] as Map) : null,
      shippingContact: map['shippingContact'] != null ? PKContact.fromJson(map['shippingContact'] as Map) : null,
      shippingMethod: map['shippingMethod'] != null ? PKShippingMethod.fromJson(map['shippingMethod'] as Map) : null,
    );
  }
}

class PKPaymentError {
  final String errorType;
  final String? localizedDescription;
  final String? postalAddressKey;
  final PKContactField? contactField;

  const PKPaymentError._({
    required this.errorType,
    this.localizedDescription,
    this.postalAddressKey,
    this.contactField,
  });

  Map toJson() => {
        'errorType': errorType,
        'localizedDescription': localizedDescription,
        'postalAddressKey': postalAddressKey,
        'contactField': contactField?.toJson(),
      };

  factory PKPaymentError.contactInvalid({required PKContactField contactField, String? localizedDescription}) {
    return PKPaymentError._(
      errorType: 'paymentErrorContactInvalid',
      contactField: contactField,
      localizedDescription: localizedDescription,
    );
  }

  factory PKPaymentError.shippingAddressInvalid({String postalAddressKey = '', String? localizedDescription}) {
    return PKPaymentError._(
      errorType: 'paymentErrorShippingAddressInvalid',
      postalAddressKey: postalAddressKey,
      localizedDescription: localizedDescription,
    );
  }

  factory PKPaymentError.billingAddressInvalid({String postalAddressKey = '', String? localizedDescription}) {
    return PKPaymentError._(
      errorType: 'paymentErrorBillingAddressInvalid',
      postalAddressKey: postalAddressKey,
      localizedDescription: localizedDescription,
    );
  }

  factory PKPaymentError.shippingAddressUnserviceable({String postalAddressKey = '', String? localizedDescription}) {
    return PKPaymentError._(
      errorType: 'paymentErrorShippingAddressUnserviceable',
      localizedDescription: localizedDescription,
    );
  }

  factory PKPaymentError.couponCodeInvalidError({String postalAddressKey = '', String? localizedDescription}) {
    return PKPaymentError._(
      errorType: 'paymentErrorCouponCodeInvalid',
      localizedDescription: localizedDescription,
    );
  }

  factory PKPaymentError.couponCodeExpiredError({String postalAddressKey = '', String? localizedDescription}) {
    return PKPaymentError._(
      errorType: 'paymentErrorCouponCodeExpired',
      localizedDescription: localizedDescription,
    );
  }
}

class PKPaymentAuthorizationResult {
  final PKPaymentAuthStatus status;
  final List<PKPaymentError>? errors;

  const PKPaymentAuthorizationResult({required this.status, this.errors});

  Map toJson() => {
        'status': status.toJson(),
        'errors': errors?.map((e) => e.toJson()).toList(),
      };
}

class PKPaymentRequestShippingMethodUpdate {
  final PKPaymentAuthStatus status;
  final List<PKPaymentSummaryItem> paymentSummaryItems;

  const PKPaymentRequestShippingMethodUpdate({required this.status, required this.paymentSummaryItems});

  Map toJson() {
    return {
      'status': status.toJson(),
      'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
    };
  }
}

class PKPaymentRequestMerchantSessionUpdate {
  final PKPaymentAuthStatus status;
  final Map dictionary;

  const PKPaymentRequestMerchantSessionUpdate({required this.status, this.dictionary = const {}});
}

class PKPaymentRequestCouponCodeUpdate {
  final PKPaymentAuthStatus status;
  final List<PKPaymentSummaryItem> paymentSummaryItems;
  final List<PKShippingMethod> shippingMethods;
  final List<PKPaymentError>? errors;

  const PKPaymentRequestCouponCodeUpdate({
    required this.status,
    required this.paymentSummaryItems,
    required this.shippingMethods,
    this.errors,
  });

  Map toJson() {
    return {
      'status': status.toJson(),
      'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
      'shippingMethods': shippingMethods.map((e) => e.toJson()).toList(),
      'errors': errors?.map((e) => e.toJson()).toList(),
    };
  }
}

class PKPaymentRequestShippingContactUpdate {
  final PKPaymentAuthStatus status;
  final List<PKPaymentSummaryItem> paymentSummaryItems;
  final List<PKShippingMethod> shippingMethods;
  final List<PKPaymentError>? errors;

  const PKPaymentRequestShippingContactUpdate({
    required this.status,
    required this.paymentSummaryItems,
    required this.shippingMethods,
    this.errors,
  });

  Map toJson() {
    return {
      'status': status.toJson(),
      'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
      'shippingMethods': shippingMethods.map((e) => e.toJson()).toList(),
      'errors': errors?.map((e) => e.toJson()).toList(),
    };
  }
}

class PKPaymentRequestPaymentMethodUpdate {
  final PKPaymentAuthStatus status;
  final List<PKPaymentSummaryItem> paymentSummaryItems;
  final List<PKPaymentError>? errors;

  const PKPaymentRequestPaymentMethodUpdate({
    required this.status,
    required this.paymentSummaryItems,
    this.errors,
  });

  Map toJson() {
    return {
      'status': status.toJson(),
      'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
      'errors': errors?.map((e) => e.toJson()).toList(),
    };
  }
}

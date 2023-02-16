import 'dart:async';
import 'dart:convert';

import 'package:apple_pay_mimic/src/payment_authorization_controller_delegate.dart';
import 'package:flutter/services.dart';

import 'src/entities.dart';
import 'src/rpc.dart';

export 'src/entities.dart';
export 'src/rpc.dart';
export 'src/widgets/apple_pay_button.dart';
export 'src/payment_authorization_controller_delegate.dart';

class ApplePayError {
  final String error;

  const ApplePayError({required this.error});

  @override
  String toString() => error;
}

typedef DidError = FutureOr<void> Function(ApplePayError error);
typedef DidDismissed = FutureOr<void> Function();

class ApplePayPaymentHandler {
  final PKPaymentAuthorizationControllerDelegate delegate;

  final DidError onError;
  final DidDismissed? onDismissed;

  const ApplePayPaymentHandler({
    required this.delegate,
    required this.onError,
    this.onDismissed,
  });
}

class ApplePayConstants {
  static String postalAddressStreetKey = '';
  static String postalAddressSubLocalityKey = '';
  static String postalAddressCityKey = '';
  static String postalAddressSubAdministrativeAreaKey = '';
  static String postalAddressStateKey = '';
  static String postalAddressPostalCodeKey = '';
  static String postalAddressCountryKey = '';
  static String postalAddressISOCountryKey = '';
}

class ApplePayMimic {
  static const MethodChannel _channel = MethodChannel('apple_pay_mimic');

  static final _handlers = <int, ApplePayPaymentHandler>{};

  static Future<void> init() async {
    _channel.setMethodCallHandler(_methodCallHandler);

    final result = (await _channel.invokeMethod('fetchPostalAddressKeys') as Map);

    ApplePayConstants.postalAddressStreetKey = result['street'] as String;
    ApplePayConstants.postalAddressSubLocalityKey = result['subLocality'] as String;
    ApplePayConstants.postalAddressCityKey = result['city'] as String;
    ApplePayConstants.postalAddressSubAdministrativeAreaKey = result['subAdministrativeArea'] as String;
    ApplePayConstants.postalAddressStateKey = result['stateKey'] as String;
    ApplePayConstants.postalAddressPostalCodeKey = result['postalCode'] as String;
    ApplePayConstants.postalAddressCountryKey = result['country'] as String;
    ApplePayConstants.postalAddressISOCountryKey = result['isoCountryCode'] as String;
  }

  static Future<dynamic> _methodCallHandler(MethodCall call) async {
    print('[Apple Pay] FLUTTER handle: ${call.method}');
    if (call.method == 'didAuthorizePayment') {
      return await _didAuthorizePayment(call.arguments);
    } else if (call.method == 'didSelectShippingMethod') {
      return await _didSelectShippingMethod(call.arguments);
    } else if (call.method == 'didSelectShippingContact') {
      return await _didSelectShippingContact(call.arguments);
    } else if (call.method == 'didSelectPaymentMethod') {
      return await _didSelectPaymentMethod(call.arguments);
    } else if (call.method == 'didChangeCouponCode') {
      return await _didChangeCouponCode(call.arguments);
    } else if (call.method == 'error') {
      return await _handleError(call.arguments);
    } else if (call.method == 'dismissed') {
      return await _handleDismissed(call.arguments);
    }

    throw MissingPluginException();
  }

  static ApplePayPaymentHandler _handler(int id) {
    return _handlers[id]!;
  }

  static Future<dynamic> _didAuthorizePayment(dynamic arguments) async {
    try {
      final request = AuthorizePaymentRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).delegate.didAuthorizePayment(request.payment);
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e\n$s');
    }
  }

  static Future<dynamic> _didSelectShippingMethod(dynamic arguments) async {
    try {
      final request = SelectShippingMethodRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).delegate.didSelectShippingMethod(request.shippingMethod);
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e\n$s');
    }
  }

  static Future<dynamic> _didSelectShippingContact(dynamic arguments) async {
    try {
      final request = SelectShippingContactRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).delegate.didSelectShippingContact(request.shippingContact);
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e\n$s');
    }
  }

  static Future<dynamic> _didSelectPaymentMethod(dynamic arguments) async {
    try {
      final request = SelectPaymentMethodRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).delegate.didSelectPaymentMethod(request.paymentMethod);
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e\n$s');
    }
  }

  static Future<dynamic> _didChangeCouponCode(dynamic arguments) async {
    try {
      final request = ChangeCouponCodeRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).delegate.didChangeCouponCode(request.couponCode);
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e\n$s');
    }
  }

  static Future<dynamic> _handleError(dynamic arguments) async {
    if (arguments is! Map) {
      return print('[Apple Pay] _handleError arguments is not Map');
    }

    final id = arguments['id'] as int;
    final step = arguments['step'] as String?;

    print('error $arguments');

    _handler(id).onError(ApplePayError(error: step ?? ''));
  }

  static Future<dynamic> _handleDismissed(dynamic arguments) async {
    if (arguments is! Map) {
      return print('[Apple Pay] _handleDismissed arguments is not Map');
    }

    final id = arguments['id'] as int;

    _handler(id).onDismissed?.call();
  }

  static Future<List<PKPaymentNetwork>> availableNetworks() async {
    final result = await _channel.invokeMethod('availableNetworks') as String;
    final json = jsonDecode(result) as List;
    return json.map<PKPaymentNetwork>((e) => PKPaymentNetwork.fromJson(e as Map)).toList();
  }

  static Future<bool> canMakePayments([CanMakePaymentsRequest? request]) async {
    final arguments = request != null ? jsonEncode(request.toJson()) : null;
    final response = await _channel.invokeMethod('canMakePayments', arguments);
    if (response is bool) {
      return response;
    }
    throw response as Object;
  }

  static Future<void> processPayment({
    required ProcessPaymentRequest request,
    required PKPaymentAuthorizationControllerDelegate delegate,
    required DidError onError,
    DidDismissed? onDismissed,
  }) async {
    final arguments = jsonEncode(request.toJson());
    final response = await _channel.invokeMethod('processPayment', arguments);
    if (response is! int) {
      throw 'wrong response';
    }
    _handlers[response] = ApplePayPaymentHandler(
      delegate: delegate,
      onError: onError,
      onDismissed: onDismissed,
    );
  }
}

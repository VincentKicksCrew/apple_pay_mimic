import Flutter
import UIKit
import PassKit

class PaymentRequestHandler: NSObject {
    public init(_ channel: FlutterMethodChannel, _ paymentId: Int) {
        self.channel = channel
        self.paymentId = paymentId
    }

    var channel: FlutterMethodChannel
    var paymentId: Int
    var controller: PKPaymentAuthorizationController?

    public func process(_ value: ProcessPaymentRequest) {
        guard let shippingType = value.shippingType.toPK() else {
            return DispatchQueue.main.async {
                self.channel.invokeMethod("error", arguments: [
                "id": self.paymentId,
                "error": "Некорректный shippingType " + value.shippingType.value
                ])
            }
        }

        let supportedNetworks: [PKPaymentNetwork] =
                value.supportedNetworks.map({ $0.toPK() }).onlyType()
        let merchantCapabilities: [PKMerchantCapability] =
                value.merchantCapabilities.map({ $0.toPK() }).onlyType()

        let request = PKPaymentRequest()

        request.shippingType = shippingType
        request.countryCode = value.countryCode
        request.currencyCode = value.currencyCode
        request.merchantIdentifier = value.merchantIdentifier
        request.supportedNetworks = supportedNetworks
        request.paymentSummaryItems = value.paymentSummaryItems.map({ $0.toPK() }).onlyType()
        request.applicationData = value.applicationData?.data(using: .utf8)
        if #available(iOS 15.0, *) {
            request.supportsCouponCode = value.supportsCouponCode
        }

        if value.requiredBillingContactFields != nil {
            let list: [PKContactField] =
                    value.requiredBillingContactFields!.map({ $0.toPK() }).onlyType()
            request.requiredBillingContactFields = Set(list)
        }

        if value.requiredShippingContactFields != nil {
            let list: [PKContactField] =
                    value.requiredShippingContactFields!.map({ $0.toPK() }).onlyType()
            request.requiredShippingContactFields = Set(list)
        }

        if value.billingContact != nil {
            request.billingContact = value.billingContact?.toPK()
        }

        if value.shippingContact != nil {
            request.shippingContact = value.shippingContact?.toPK()
        }

        if value.shippingMethods != nil {
            request.shippingMethods = value.shippingMethods!.map({ $0.toPK() }).onlyType()
        }

        if value.supportedCountries != nil {
            request.supportedCountries = Set(value.supportedCountries!)
        }

        for merchantCapability in merchantCapabilities {
            request.merchantCapabilities.insert(merchantCapability)
        }
        controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller!.delegate = self
        controller!.present { result in
            if !result {
                DispatchQueue.main.async {
                    self.channel.invokeMethod("error", arguments: ["id": self.paymentId])
                }
            }
        }
    }
}

extension PaymentRequestHandler: PKPaymentAuthorizationControllerDelegate {
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                self.channel.invokeMethod("dismissed", arguments: ["id": self.paymentId])
            }
        }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> ()) {
        let request = AuthorizePaymentRequest(
                id: paymentId,
                payment: APayPayment.fromPK(payment)
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod("didAuthorizePayment", arguments: encodeJson(request)) { any in
                guard let string = any as? String,
                    let result: APayPaymentAuthorizationResult = decodeJson(string) else {

                        DispatchQueue.main.async {
                            self.channel.invokeMethod("error", arguments: [
                                "id": self.paymentId,
                                "step": "didAuthorizePayment",
                                "arguments": "\(any)",
                            ])
                        }

                        return completion(PKPaymentAuthorizationStatus.failure)
                }

                completion(result.status.toPK())
            }
        }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let request = AuthorizePaymentRequest(
                id: paymentId,
                payment: APayPayment.fromPK(payment)
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod("didAuthorizePayment", arguments: encodeJson(request)) { any in
                guard let string = any as? String,
                    let result: APayPaymentAuthorizationResult = decodeJson(string) else {
                        DispatchQueue.main.async {
                            self.channel.invokeMethod("error", arguments: [
                                "id": self.paymentId,
                                "step": "didAuthorizePayment",
                                "arguments": "\(any)",
                            ])
                        }
                    let result = PKPaymentAuthorizationResult()
                    result.status = PKPaymentAuthorizationStatus.failure
                    return completion(result)
                }

                completion(result.toPK())
            }
        }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingMethod shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        let request = SelectShippingMethodRequest(
                id: paymentId,
                shippingMethod: APayShippingMethod.fromPK(shippingMethod)
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod("didSelectShippingMethod", arguments: encodeJson(request)) { any in
                guard let string = any as? String,
                    let result: APayRequestShippingMethodUpdate = decodeJson(string) else {
                    self.channel.invokeMethod("error", arguments: [
                        "id": self.paymentId,
                        "step": "didSelectShippingMethod",
                        "arguments": "\(any)",
                    ])
                    let result = PKPaymentRequestShippingMethodUpdate()
                    result.status = PKPaymentAuthorizationStatus.failure
                    return completion(result)
                }

                completion(result.toPK())
            }
        }
    }
    
    @available(iOS 15.0, *)
    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didChangeCouponCode couponCode: String, handler completion: @escaping (PKPaymentRequestCouponCodeUpdate) -> Void){
             let request = ChangeCouponCodeRequest(
                id: paymentId,
                couponCode: couponCode
        )
        DispatchQueue.main.async {
                self.channel.invokeMethod("didChangeCouponCode", arguments: encodeJson(request)) { any in
                    guard let string = any as? String,
                        let result: APayRequestCouponCodeUpdate = decodeJson(string) else {

                        DispatchQueue.main.async {        
                            self.channel.invokeMethod("error", arguments: [
                                "id": self.paymentId,
                                "step": "didChangeCouponCode",
                                "arguments": "\(any)",
                            ])
                        }
                        let result = PKPaymentRequestCouponCodeUpdate()
                        result.status = PKPaymentAuthorizationStatus.failure
                        return completion(result)
                    }

                    print(result.toPK().paymentSummaryItems)

                    completion(result.toPK())
                }
        }

    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Void) {
        let request = SelectShippingContactRequest(
                id: paymentId,
                shippingContact: APayContact.fromPK(contact)
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod("didSelectShippingContact", arguments: encodeJson(request)) { any in
                guard let string = any as? String,
                    let result: APayRequestShippingContactUpdate = decodeJson(string) else {

                    DispatchQueue.main.async {
                        self.channel.invokeMethod("error", arguments: [
                            "id": self.paymentId,
                            "step": "didSelectShippingContact",
                            "arguments": "\(any)",
                        ])
                    }

                    let result = PKPaymentRequestShippingContactUpdate()
                    result.status = PKPaymentAuthorizationStatus.failure
                    return completion(result)
                }

                print(result.toPK().paymentSummaryItems)

                completion(result.toPK())
        }
    }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectPaymentMethod paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
        let request = SelectPaymentMethodRequest(
                id: paymentId,
                paymentMethod: APayPaymentMethod.fromPK(paymentMethod)
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod("didSelectPaymentMethod", arguments: encodeJson(request)) { any in
                guard let string = any as? String,
                    let result: APayRequestPaymentMethodUpdate = decodeJson(string) else {

                    DispatchQueue.main.async {        
                        self.channel.invokeMethod("error", arguments: [
                            "id": self.paymentId,
                            "step": "didSelectPaymentMethod",
                            "arguments": "\(any)",
                        ])
                    }

                    let result = PKPaymentRequestPaymentMethodUpdate()
                    result.status = PKPaymentAuthorizationStatus.failure
                    return completion(result)
                }

                completion(result.toPK())
            }
        }
    }

    public func paymentAuthorizationControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationController) {
        print("A")
    }

    /*
    @available(iOS 14.0, *)
    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didRequestMerchantSessionUpdate handler: @escaping (PKPaymentRequestMerchantSessionUpdate) -> ()) {
        print("B")
    }
    */

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingMethod shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> ()) {
        let request = SelectShippingMethodRequest(
                id: paymentId,
                shippingMethod: APayShippingMethod.fromPK(shippingMethod)
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod("didSelectShippingMethod", arguments: encodeJson(request)) { any in
                guard let string = any as? String,
                    let result: APayRequestShippingMethodUpdate = decodeJson(string) else {
                    DispatchQueue.main.async {
                        self.channel.invokeMethod("error", arguments: [
                            "id": self.paymentId,
                            "step": "didSelectShippingMethod",
                            "arguments": "\(any)",
                        ])
                    }
                    return completion(PKPaymentAuthorizationStatus.failure, [])
                }
                let pk = result.toPK()
                completion(pk.status, pk.paymentSummaryItems)
            }
        }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingContact contact: PKContact, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> ()) {
        let request = SelectShippingContactRequest(
                id: paymentId,
                shippingContact: APayContact.fromPK(contact)
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod("didSelectShippingContact", arguments: encodeJson(request)) { any in
                guard let string = any as? String,
                    let result: APayRequestShippingContactUpdate = decodeJson(string) else {
                    DispatchQueue.main.async {
                        self.channel.invokeMethod("error", arguments: [
                            "id": self.paymentId,
                            "step": "didSelectShippingContact",
                            "arguments": "\(any)",
                        ])
                    }
                    return completion(PKPaymentAuthorizationStatus.failure, [], [])
                }
                let pk = result.toPK()
                completion(pk.status, pk.shippingMethods, pk.paymentSummaryItems)
            }
        }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectPaymentMethod paymentMethod: PKPaymentMethod, completion: @escaping ([PKPaymentSummaryItem]) -> ()) {
        let request = SelectPaymentMethodRequest(
                id: paymentId,
                paymentMethod: APayPaymentMethod.fromPK(paymentMethod)
        )

        DispatchQueue.main.async {
            self.channel.invokeMethod("didSelectPaymentMethod", arguments: encodeJson(request)) { any in
                guard let string = any as? String,
                    let result: APayRequestPaymentMethodUpdate = decodeJson(string) else {
                    DispatchQueue.main.async {
                        self.channel.invokeMethod("error", arguments: [
                            "id": self.paymentId,
                            "step": "didSelectPaymentMethod",
                            "arguments": "\(any)",
                        ])
                    }
                    return completion([])
                }

                completion(result.toPK().paymentSummaryItems)
            }
        }
    }

    /*
    public func presentationWindow(for controller: PKPaymentAuthorizationController) -> UIWindow? {
        fatalError("presentationWindow(for:) has not been implemented")
    }
    */
}

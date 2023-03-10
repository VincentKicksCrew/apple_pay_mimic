import PassKit

struct Constants {
    static let paymentErrorContactInvalid = "paymentErrorContactInvalid"
    static let paymentErrorShippingAddressInvalid = "paymentErrorShippingAddressInvalid"
    static let paymentErrorBillingAddressInvalid = "paymentErrorBillingAddressInvalid"
    static let paymentErrorShippingAddressUnserviceable = "paymentErrorShippingAddressUnserviceable"
    static let paymentErrorCouponCodeInvalid = "paymentErrorCouponCodeInvalid"
    static let paymentErrorCouponCodeExpired = "paymentErrorCouponCodeExpired"

    static let paymentResultShippingContactUpdate = "paymentResultShippingContactUpdate"
    static let paymentResultShippingMethodUpdate = "paymentResultShippingMethodUpdate"
    static let paymentResultPaymentMethodUpdate = "paymentResultPaymentMethodUpdate"
    let test = NSLocalizedString("shippingAddressUnserviceableError", comment: "")
}

struct APayPaymentAuthStatus: Codable {
    let value: Int

    static let success = APayPaymentAuthStatus(value: 0)
    static let failure = APayPaymentAuthStatus(value: 1)

    public func toPK() -> PKPaymentAuthorizationStatus {
        PKPaymentAuthorizationStatus(rawValue: value)!
    }
}

struct APayPaymentMethodType: Codable {
    let value: Int

    static let unknown = APayPaymentMethodType(value: 0)
    static let debit = APayPaymentMethodType(value: 1)
    static let credit = APayPaymentMethodType(value: 2)
    static let prepaid = APayPaymentMethodType(value: 3)
    static let store = APayPaymentMethodType(value: 4)

    static func fromPK(_ value: PKPaymentMethodType) -> APayPaymentMethodType {
        APayPaymentMethodType(value: Int(value.rawValue))
    }
}

struct APayPaymentSummaryItemType: Codable {
    let value: Int

    static let final = APayPaymentSummaryItemType(value: 0)
    static let pending = APayPaymentSummaryItemType(value: 1)

    public static func fromPK(_ value: PKPaymentSummaryItemType) -> APayPaymentSummaryItemType {
        APayPaymentSummaryItemType(value: Int(value.rawValue))
    }

    public func toPK() -> PKPaymentSummaryItemType? {
        PKPaymentSummaryItemType(rawValue: UInt(value))
    }
}

struct APayShippingType: Codable {
    let value: String

    static let shipping = APayShippingType(value: "shipping")
    static let delivery = APayShippingType(value: "delivery")
    static let storePickup = APayShippingType(value: "storePickup")
    static let servicePickup = APayShippingType(value: "servicePickup")

    public func toPK() -> PKShippingType? {
        switch (value) {
        case "shipping": return .shipping
        case "delivery": return .delivery
        case "storePickup": return .storePickup
        case "servicePickup": return .servicePickup
        default: return nil
        }
    }
}

struct APayMerchantCapability: Codable {
    let value: String

    static let capability3DS = APayMerchantCapability(value: "capability3DS")
    static let capabilityEMV = APayMerchantCapability(value: "capabilityEMV")
    static let capabilityCredit = APayMerchantCapability(value: "capabilityCredit")
    static let capabilityDebit = APayMerchantCapability(value: "capabilityDebit")

    public func toPK() -> PKMerchantCapability? {
        switch (value) {
        case "capability3DS": return .capability3DS
        case "capabilityEMV": return .capabilityEMV
        case "capabilityCredit": return .capabilityCredit
        case "capabilityDebit": return .capabilityDebit
        default: return nil
        }
    }
}

struct APayPaymentNetwork: Codable {
    let value: String

    static let carteBancaire = APayPaymentNetwork(value: "carteBancaire")
    static let carteBancaires = APayPaymentNetwork(value: "carteBancaires")
    static let cartesBancaires = APayPaymentNetwork(value: "cartesBancaires")
    static let chinaUnionPay = APayPaymentNetwork(value: "chinaUnionPay")
    static let discover = APayPaymentNetwork(value: "discover")
    static let eftpos = APayPaymentNetwork(value: "eftpos")
    static let electron = APayPaymentNetwork(value: "electron")
    static let elo = APayPaymentNetwork(value: "elo")
    static let idCredit = APayPaymentNetwork(value: "idCredit")
    static let interac = APayPaymentNetwork(value: "interac")
    static let JCB = APayPaymentNetwork(value: "JCB")
    static let mada = APayPaymentNetwork(value: "mada")
    static let maestro = APayPaymentNetwork(value: "maestro")
    static let masterCard = APayPaymentNetwork(value: "masterCard")
    static let privateLabel = APayPaymentNetwork(value: "privateLabel")
    static let quicPay = APayPaymentNetwork(value: "quicPay")
    static let suica = APayPaymentNetwork(value: "suica")
    static let visa = APayPaymentNetwork(value: "visa")
    static let vPay = APayPaymentNetwork(value: "vPay")
    static let barcode = APayPaymentNetwork(value: "barcode")
    static let girocard = APayPaymentNetwork(value: "girocard")

    public func toPK() -> PKPaymentNetwork? {
        switch value {
        case "carteBancaire": return .carteBancaire
        case "carteBancaires": return .carteBancaires
        case "cartesBancaires": return .cartesBancaires
        case "chinaUnionPay": return .chinaUnionPay
        case "discover": return .discover
        case "eftpos": return .eftpos
        case "electron": return .electron
        case "elo":
            if #available(iOS 12.1.1, *) {
                return .elo
            }
            return nil
        case "idCredit": return .idCredit
        case "interac": return .interac
        case "JCB": return .JCB
        case "mada":
            if #available(iOS 12.1.1, *) {
                return .mada
            }
            return nil
        case "maestro": return .maestro
        case "masterCard": return .masterCard
        case "privateLabel": return .privateLabel
        case "quicPay": return .quicPay
        case "suica": return .suica
        case "visa": return .visa
        case "vPay": return .vPay
        case "barcode":
            if #available(iOS 14, *) {
                return .barcode
            }
            return nil
        case "girocard":
            if #available(iOS 14, *) {
                return .girocard
            }
            return nil
        default: return nil
        }
    }

    static func fromPK(_ value: PKPaymentNetwork) -> APayPaymentNetwork? {
        switch (value) {
        case .carteBancaire: return carteBancaire
        case .carteBancaires: return carteBancaires
        case .cartesBancaires: return cartesBancaires
        case .chinaUnionPay: return chinaUnionPay
        case .discover: return discover
        case .eftpos: return eftpos
        case .electron: return electron
        case .idCredit: return idCredit
        case .interac: return interac
        case .JCB: return JCB
        case .maestro: return maestro
        case .masterCard: return masterCard
        case .privateLabel:return privateLabel
        case .quicPay: return quicPay
        case .suica:return suica;
        case .visa: return visa
        case .vPay: return vPay
        default:
            if #available(iOS 12.1.1, *) {
                if value == .elo {
                    return elo
                }
                if value == .mada {
                    return mada
                }
            }
            if #available(iOS 14, *) {
                if value == .barcode {
                    return barcode
                }
                if value == .girocard {
                    return girocard
                }
            }
            return nil
        }
    }
}

struct APayContactField: Codable {
    let value: String

    static let postalAddress = APayContactField(value: "postalAddress")
    static let emailAddress = APayContactField(value: "emailAddress")
    static let phoneNumber = APayContactField(value: "phoneNumber")
    static let name = APayContactField(value: "name")
    static let phoneticName = APayContactField(value: "phoneticName")

    public func toPK() -> PKContactField? {
        switch (value) {
        case "postalAddress": return .postalAddress
        case "emailAddress": return .emailAddress
        case "phoneNumber": return .phoneNumber
        case "name": return .name
        case "phoneticName": return .phoneticName
        default: return nil
        }
    }
}

struct APayPaymentSummaryItem: Codable {
    let label: String
    let amount: Double
    let type: APayPaymentSummaryItemType

    public func toPK() -> PKPaymentSummaryItem? {
        guard let paymentSummaryItemType = type.toPK() else {
            return nil
        }

        return PKPaymentSummaryItem(label: label, amount: NSDecimalNumber(value: amount), type: paymentSummaryItemType)
    }
}

struct APayShippingMethod: Codable {
    let label: String
    let amount: Double
    let type: APayPaymentSummaryItemType
    let identifier: String?
    let detail: String?

    public static func fromPK(_ value: PKShippingMethod) -> APayShippingMethod {
        APayShippingMethod(
                label: value.label,
                amount: value.amount.doubleValue,
                type: APayPaymentSummaryItemType.fromPK(value.type),
                identifier: value.identifier,
                detail: value.detail
        )
    }

    public func toPK() -> PKShippingMethod? {
        guard let paymentSummaryItemType = type.toPK() else {
            return nil
        }

        let result = PKShippingMethod(label: label, amount: NSDecimalNumber(value: amount), type: paymentSummaryItemType)

        result.identifier = identifier
        result.detail = detail

        return result
    }
}

class APayPersonNameComponents: Codable {
    public init(namePrefix: String?, givenName: String?, middleName: String?, familyName: String?, nameSuffix: String?, nickname: String?, phoneticRepresentation: APayPersonNameComponents?) {
        self.namePrefix = namePrefix
        self.givenName = givenName
        self.middleName = middleName
        self.familyName = familyName
        self.nameSuffix = nameSuffix
        self.nickname = nickname
        self.phoneticRepresentation = phoneticRepresentation
    }

    let namePrefix: String?
    let givenName: String?
    let middleName: String?
    let familyName: String?
    let nameSuffix: String?
    let nickname: String?
    let phoneticRepresentation: APayPersonNameComponents?

    public static func fromPK(_ value: PersonNameComponents) -> APayPersonNameComponents {
        APayPersonNameComponents(
                namePrefix: value.nameSuffix,
                givenName: value.givenName,
                middleName: value.middleName,
                familyName: value.familyName,
                nameSuffix: value.nameSuffix,
                nickname: value.nickname,
                phoneticRepresentation: value.phoneticRepresentation != nil ? APayPersonNameComponents.fromPK(value.phoneticRepresentation!) : nil
        )
    }

    public func toPK() -> PersonNameComponents {
        var result = PersonNameComponents()

        result.namePrefix = namePrefix
        result.givenName = givenName
        result.middleName = middleName
        result.familyName = familyName
        result.nameSuffix = nameSuffix
        result.nickname = nickname
        result.phoneticRepresentation = phoneticRepresentation?.toPK()

        return result
    }

}

struct APayPostalAddress: Codable {
    let street: String
    let subLocality: String
    let city: String
    let subAdministrativeArea: String
    let state: String
    let postalCode: String
    let country: String
    let isoCountryCode: String

    public static func fromPK(_ value: CNPostalAddress) -> APayPostalAddress {
        APayPostalAddress(
                street: value.street,
                subLocality: value.subLocality,
                city: value.city,
                subAdministrativeArea: value.subAdministrativeArea,
                state: value.state,
                postalCode: value.postalCode,
                country: value.country,
                isoCountryCode: value.isoCountryCode
        )
    }

    public func toPK() -> CNPostalAddress {
        let result = CNMutablePostalAddress()

        result.street = street
        result.subLocality = subLocality
        result.city = city
        result.subAdministrativeArea = subAdministrativeArea
        result.state = state
        result.postalCode = postalCode
        result.country = country
        result.isoCountryCode = isoCountryCode

        return result
    }
}

struct APayContact: Codable {
    let name: APayPersonNameComponents?
    let postalAddress: APayPostalAddress?
    let phoneNumber: String?
    let emailAddress: String?

    public static func fromPK(_ value: PKContact) -> APayContact {
        APayContact(
                name: value.name != nil ? APayPersonNameComponents.fromPK(value.name!) : nil,
                postalAddress: value.postalAddress != nil ? APayPostalAddress.fromPK(value.postalAddress!) : nil,
                phoneNumber: value.phoneNumber?.stringValue,
                emailAddress: value.emailAddress
        )
    }

    public func toPK() -> PKContact {
        let result = PKContact()

        result.name = name?.toPK()
        result.postalAddress = postalAddress?.toPK()
        result.phoneNumber = phoneNumber != nil ? CNPhoneNumber(stringValue: phoneNumber!) : nil
        result.emailAddress = emailAddress

        return result
    }
}

struct APayPaymentMethod: Codable {
    let displayName: String?
    let network: APayPaymentNetwork?
    let type: APayPaymentMethodType

    static func fromPK(_ value: PKPaymentMethod) -> APayPaymentMethod {
        APayPaymentMethod(
                displayName: value.displayName,
                network: value.network != nil ? APayPaymentNetwork.fromPK(value.network!) : nil,
                type: APayPaymentMethodType.fromPK(value.type)
        )
    }
}

struct APayPaymentToken: Codable {
    let paymentMethod: APayPaymentMethod
    let transactionIdentifier: String
    let paymentData: String

    public static func fromPK(_ value: PKPaymentToken) -> APayPaymentToken {
        APayPaymentToken(
                paymentMethod: APayPaymentMethod.fromPK(value.paymentMethod),
                transactionIdentifier: value.transactionIdentifier,
                paymentData: String(data: value.paymentData, encoding: .utf8)!
        )
    }
}

struct APayPayment: Codable {
    let token: APayPaymentToken
    let billingContact: APayContact?
    let shippingContact: APayContact?
    let shippingMethod: APayShippingMethod?

    public static func fromPK(_ value: PKPayment) -> APayPayment {
        APayPayment(
                token: APayPaymentToken.fromPK(value.token),
                billingContact: value.billingContact != nil ? APayContact.fromPK(value.billingContact!) : nil,
                shippingContact: value.shippingContact != nil ? APayContact.fromPK(value.shippingContact!) : nil,
                shippingMethod: value.shippingMethod != nil ? APayShippingMethod.fromPK(value.shippingMethod!) : nil
        )
    }
}

struct CanMakeRequest: Codable {
    let usingNetworks: [APayPaymentNetwork]?
    let capabilities: [APayMerchantCapability]?
}

struct APayPaymentError: Codable {
    let errorType: String
    let localizedDescription: String?
    let postalAddressKey: String?
    let contactField: APayContactField?

    public func toPK() -> Error? {
        print(errorType)
        switch (errorType) {
        case Constants.paymentErrorContactInvalid:
            guard let contactField = contactField?.toPK() else {
                return nil
            }

            return PKPaymentRequest.paymentContactInvalidError(withContactField: contactField, localizedDescription: localizedDescription)
        case Constants.paymentErrorShippingAddressInvalid:
            return PKPaymentRequest.paymentShippingAddressInvalidError(withKey: postalAddressKey!, localizedDescription: Constants.test)
        case Constants.paymentErrorBillingAddressInvalid:
            return PKPaymentRequest.paymentBillingAddressInvalidError(withKey: postalAddressKey!, localizedDescription: localizedDescription)
        case Constants.paymentErrorShippingAddressUnserviceable:
            return PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: Constants.test)
        case Constants.paymentErrorCouponCodeInvalid:
           if #available(iOS 15.0, *) {
                return PKPaymentRequest.paymentCouponCodeInvalidError(localizedDescription: localizedDescription)
           }
            return nil
        case Constants.paymentErrorCouponCodeExpired:
            if #available(iOS 15.0, *) {
                return PKPaymentRequest.paymentCouponCodeExpiredError(localizedDescription: localizedDescription)
            }
             return nil
        default: return nil
        }
    }
}

struct ProcessPaymentRequest: Codable {
    let merchantIdentifier: String
    let countryCode: String
    let currencyCode: String
    let supportedNetworks: [APayPaymentNetwork]
    let merchantCapabilities: [APayMerchantCapability]
    let paymentSummaryItems: [APayPaymentSummaryItem]
    let requiredBillingContactFields: [APayContactField]?
    let requiredShippingContactFields: [APayContactField]?
    let billingContact: APayContact?
    let shippingContact: APayContact?
    let shippingMethods: [APayShippingMethod]?
    let shippingType: APayShippingType
    let applicationData: String?
    let supportedCountries: [String]?
    let supportsCouponCode: Bool
}

/*
struct APayPaymentRequestUpdate {
    let status: APayPaymentAuthStatus
    let paymentSummaryItems: [APayPaymentSummaryItem]
}
*/

/// AuthorizePayment
struct APayPaymentAuthorizationResult: Codable {
    let status: APayPaymentAuthStatus
    let errors: [APayPaymentError]?

    public func toPK() -> PKPaymentAuthorizationResult {
        PKPaymentAuthorizationResult(
                status: status.toPK(),
                errors: errors?.map({ $0.toPK() }).onlyType()
        )
    }
}

struct AuthorizePaymentRequest: Codable {
    let id: Int
    let payment: APayPayment
}

struct AuthorizePaymentResponse: Codable {
    let result: APayPaymentAuthorizationResult
}

/// SelectShippingMethod
struct APayRequestShippingMethodUpdate: Codable {
    let status: APayPaymentAuthStatus
    let paymentSummaryItems: [APayPaymentSummaryItem]

    public func toPK() -> PKPaymentRequestShippingMethodUpdate {
        let result = PKPaymentRequestShippingMethodUpdate(
                paymentSummaryItems: paymentSummaryItems.map({ $0.toPK() }).onlyType()
        )
        result.status = status.toPK()
        return result
    }
}

struct SelectShippingMethodRequest: Codable {
    let id: Int
    let shippingMethod: APayShippingMethod
}

struct SelectShippingMethodResponse: Codable {
    let result: APayRequestShippingMethodUpdate
}


/// ChangeCouponCode
struct APayRequestCouponCodeUpdate: Codable {
    let status: APayPaymentAuthStatus
    let paymentSummaryItems: [APayPaymentSummaryItem]
    let shippingMethods: [APayShippingMethod]
    let errors: [APayPaymentError]?

    @available(iOS 15.0, *)
    public func toPK() -> PKPaymentRequestCouponCodeUpdate {
        let result = PKPaymentRequestCouponCodeUpdate(
                errors: errors?.map({ $0.toPK() }).onlyType(),
                paymentSummaryItems: paymentSummaryItems.map({ $0.toPK() }).onlyType(),
                shippingMethods: shippingMethods.map({ $0.toPK() }).onlyType()
        )
        result.status = status.toPK()
        return result
    }
}

struct ChangeCouponCodeRequest: Codable {
    let id: Int
    let couponCode: String
}

struct ChangeCouponCodeResponse: Codable {
    let result: APayRequestCouponCodeUpdate
}


/// SelectShippingContact
struct APayRequestShippingContactUpdate: Codable {
    let status: APayPaymentAuthStatus
    let paymentSummaryItems: [APayPaymentSummaryItem]
    let shippingMethods: [APayShippingMethod]
    let errors: [APayPaymentError]?

    public func toPK() -> PKPaymentRequestShippingContactUpdate {
        let result = PKPaymentRequestShippingContactUpdate(
                errors: errors?.map({ $0.toPK() }).onlyType(),
                paymentSummaryItems: paymentSummaryItems.map({ $0.toPK() }).onlyType(),
                shippingMethods: shippingMethods.map({ $0.toPK() }).onlyType()
        )
        result.status = status.toPK()
        return result
    }
}

struct SelectShippingContactRequest: Codable {
    let id: Int
    let shippingContact: APayContact
}

struct SelectShippingContactResponse: Codable {
    let result: APayRequestShippingContactUpdate
}

/// SelectPaymentMethod
struct APayRequestPaymentMethodUpdate: Codable {
    let status: APayPaymentAuthStatus
    let paymentSummaryItems: [APayPaymentSummaryItem]
    let errors: [APayPaymentError]?

    public func toPK() -> PKPaymentRequestPaymentMethodUpdate {
        let result = PKPaymentRequestPaymentMethodUpdate(
                errors: errors?.map({ $0.toPK() }).onlyType(),
                paymentSummaryItems: paymentSummaryItems.map({ $0.toPK() }).onlyType()
        )
        result.status = status.toPK()
        return result
    }
}

struct SelectPaymentMethodRequest: Codable {
    let id: Int
    let paymentMethod: APayPaymentMethod
}

struct SelectPaymentMethodResponse: Decodable {
    let result: APayRequestPaymentMethodUpdate
}

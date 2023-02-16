import Flutter
import UIKit
import PassKit

struct APayPaymentButtonType: Decodable {
    let value: String
    
    public func toPK() -> PKPaymentButtonType {
        switch(value) {
        case "plain": return .plain
        case "buy": return .buy
        case "addMoney":
            if #available(iOS 14, *) {
                return .addMoney
            }
            return .plain
        case "book": return .book
        case "checkout": return .checkout
        case "contribute":
            if #available(iOS 14, *) {
                return .contribute
            }
            return .plain
        case "donate": return .donate
        case "inStore": return .inStore
        case "order":
            if #available(iOS 14, *) {
                return .order
            }
            return .plain
        case "reload":
            if #available(iOS 14, *) {
                return .reload
            }
            return .plain
        case "rent":
            if #available(iOS 14, *) {
                return .rent
            }
            return .plain
        case "setUp":
            if #available(iOS 14, *) {
                return .setUp
            }
            return .plain
        case "subscribe": return .subscribe
        case "tip":
            if #available(iOS 14, *) {
                return .tip
            }
            return .plain
        case "topUp":
            if #available(iOS 14, *) {
                return .topUp
            }
            return .plain
        default: return .plain
        }
    }
}

struct APayPaymentButtonStyle: Decodable {
    let value: String
    
    public func toPK() -> PKPaymentButtonStyle {
        switch(value) {
        case "white": return .white
        case "whiteOutlined": return .whiteOutline
        case "black": return .black
        case "automatic":
            if #available(iOS 14, *) {
                return .automatic
            }
            return .white
        default:
            if #available(iOS 14, *) {
                return .automatic
            }
            return .white
        }
    }
}

struct APayPaymentButtonArguments: Decodable {
    let type: APayPaymentButtonType
    let style: APayPaymentButtonStyle
}

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var channel: FlutterMethodChannel
    
    init(messenger: FlutterBinaryMessenger, channel: FlutterMethodChannel) {
        self.messenger = messenger
        self.channel = channel
        
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?) -> FlutterPlatformView {
        
        FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            channel: channel)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private let _view: PKPaymentButton
    private let messenger: FlutterBinaryMessenger?
    private let channel: FlutterMethodChannel
    private let viewId: Int64
    private let frame: CGRect

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        channel: FlutterMethodChannel
    ) {
        print("[Apple Pay] FLNativeView1 \(args)")
        self.messenger = messenger
        self.channel = channel
        self.viewId = viewId
        self.frame = frame
    
        var data: APayPaymentButtonArguments?
        if let string = args as? String {
            data = decodeJson(string)
        }
        
        if data != nil {
            _view = PKPaymentButton(
                paymentButtonType: data!.type.toPK(),
                paymentButtonStyle: data!.style.toPK())
        } else {
            _view = PKPaymentButton()
        }

        // _view.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }

    func view() -> UIView {
        _view
    }

    @objc func tap() -> Void {
        channel.invokeMethod("tap", arguments: viewId)
    }
}

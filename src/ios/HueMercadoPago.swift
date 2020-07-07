/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/
import MercadoPagoSDK
import UIKit

@objc(HueMercadoPago) class HueMercadoPago : CDVPlugin {

    var command: CDVInvokedUrlCommand?
    var navController: UINavigationController?;
    var publicKey: String = "";
    var preferenceId: String = "";
    
    @objc(realizarPago:) // Declare your function name.
    func realizarPago(command: CDVInvokedUrlCommand) { // write the function code.
        /* 
        * Always assume that the plugin will fail.
        * Even if in this example, it can't.
        */
        // Set the plugin result to fail.
        //var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
        // Set the plugin result to succeed.
        //pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        // Send the function result back to Cordova.
        self.publicKey = command.arguments[0] as! String
        self.preferenceId = command.arguments[1] as! String
        self.command = command;
        self.runMercadoPagoCheckoutWithLifecycle();
    }


    func runMercadoPagoCheckoutWithLifecycle() {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: publicKey, 
        preferenceId: preferenceId).setLanguage("es")

        // 2) Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)
        let storyboard: UIStoryboard = UIStoryboard(name: "HomeMP", bundle: nil)
        //let root = UIApplication.shared.keyWindow?.rootViewController
        
        self.navController = storyboard.instantiateViewController(withIdentifier: "HomeMP") as? UINavigationController
        self.navController!.modalPresentationStyle = .fullScreen
        
        self.viewController.present(self.navController!, animated: true)

        // 3) Start with your navigation controller.
        checkout.start(navigationController: self.navController!, lifeCycleProtocol: self)
    }
}

// MARK: Optional Lifecycle protocol implementation example.
extension HueMercadoPago: PXLifeCycleProtocol {
    public func finishCheckout() -> ((_ payment: PXResult?) -> Void)? {
        self.navController?.dismiss(animated: false)
        return ({ (_ payment: PXResult?) in
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: [
                    "paymentId": payment?.getPaymentId() ?? "",
                    "status": payment?.getStatus() ?? ""
                ] as [AnyHashable: Any]
            )
            self.commandDelegate!.send(pluginResult, callbackId: self.command?.callbackId);
        })
    }

    func cancelCheckout() -> (() -> Void)? {
        let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: "Cancelled"
            )
        self.commandDelegate!.send(pluginResult, callbackId: self.command?.callbackId);
        self.navController?.dismiss(animated: false)
        return nil
    }

    func changePaymentMethodTapped() -> (() -> Void)? {
        return { () in
            self.navController?.dismiss(animated: false) {
                self.runMercadoPagoCheckoutWithLifecycle()
            }
            print("px - changePaymentMethodTapped")
        }
    }

}



/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/
import MercadoPagoSDK
import UIKit

@objc(HueMercadoPago) class HueMercadoPago : CDVPlugin {

    var command: CDVInvokedUrlCommand?

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
        let publicKey = command.arguments[0] as! String
        let preferenceId = command.arguments[1] as! String
        self.command = command;
        self.runMercadoPagoCheckoutWithLifecycle(publicKey: publicKey, preferenceId: preferenceId)
    }


    func runMercadoPagoCheckoutWithLifecycle(publicKey: String, preferenceId: String) {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: publicKey, 
        preferenceId: preferenceId).setLanguage("es")

        // 2) Create Checkout reference
        let checkout = MercadoPagoCheckout(builder: builder)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "HomeMP", bundle: nil)
        //let root = UIApplication.shared.keyWindow?.rootViewController
        
        let navController = storyboard.instantiateViewController(withIdentifier: "HomeMP")
        self.viewController.present(navController, animated: true)
        
        // 3) Start with your navigation controller.
        checkout.start(navigationController: navController as! UINavigationController, lifeCycleProtocol: self)
    }
}

// MARK: Optional Lifecycle protocol implementation example.
extension HueMercadoPago: PXLifeCycleProtocol {
    public func finishCheckout() -> ((_ payment: PXResult?) -> Void)? {
        self.viewController.dismiss(animated: false)
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
                status: CDVCommandStatus_OK,
                messageAs: "Canceled"
            )
        self.commandDelegate!.send(pluginResult, callbackId: self.command?.callbackId);
        self.viewController.dismiss(animated: false)
        return nil
    }

    func changePaymentMethodTapped() -> (() -> Void)? {
        return { () in
            print("px - changePaymentMethodTapped")
        }
    }

}

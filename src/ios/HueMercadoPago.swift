/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/
import MercadoPagoSDK
import UIKit

@objc(HueMercadoPago) class HueMercadoPago : CDVPlugin {

    var command: CDVCommandStatus_OK?

    @objc(coolMethod:) // Declare your function name.
    func coolMethod(command: CDVInvokedUrlCommand) { // write the function code.
        /* 
        * Always assume that the plugin will fail.
        * Even if in this example, it can't.
        */
        // Set the plugin result to fail.
        //var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
        // Set the plugin result to succeed.
        //pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        // Send the function result back to Cordova.

        let preferenceId = command.arguments[0]
        self.command = command;
        self.runMercadoPagoCheckoutWithLifecycle(preferenceId)
    }


    func runMercadoPagoCheckoutWithLifecycle(preferenceId: String) {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: "TEST-c98a211b-42d5-45a3-a186-e87606d62c0a", 
        preferenceId: preferenceId).setLanguage("es")

        // 2) Create Checkout reference
        checkout = MercadoPagoCheckout(builder: builder)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "HomeMP", bundle: nil)
        //let root = UIApplication.shared.keyWindow?.rootViewController
        
        let navController = storyboard.instantiateViewController(withIdentifier: "HomeMP")
        self.present(navController, animated: true)
        
        // 3) Start with your navigation controller.
        checkout?.start(navigationController: navController as! UINavigationController, lifeCycleProtocol: self)
    }
}

// MARK: Optional Lifecycle protocol implementation example.
extension ViewController: PXLifeCycleProtocol {
    public func finishCheckout() -> ((_ payment: PXResult?) -> Void)? {
        self.dismiss(animated: false)
        return ({ (_ payment: PXResult?) in
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: self.payment
            )
            self.commandDelegate!.send(pluginResult, callbackId: self.command.callbackId);
        })
    }

    func cancelCheckout() -> (() -> Void)? {
        let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAsString: "Canceled"
            )
        self.commandDelegate!.send(pluginResult, callbackId: self.command.callbackId);
        return nil
    }

    func changePaymentMethodTapped() -> (() -> Void)? {
        return { () in
            print("px - changePaymentMethodTapped")
        }
    }

}

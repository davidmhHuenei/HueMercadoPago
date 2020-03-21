/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/
import MercadoPagoSDK
import UIKit

@objc(HueMercadoPago) class HueMercadoPago : CDVPlugin {

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

        self.runMercadoPagoCheckoutWithLifecycle(preferenceId)
        
    }


    func runMercadoPagoCheckoutWithLifecycle(preferenceId: String) {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: "TEST-c98a211b-42d5-45a3-a186-e87606d62c0a", 
        preferenceId: preferenceId).setLanguage("es")

        // 2) Create Checkout reference
        checkout = MercadoPagoCheckout(builder: builder)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        let mainView = ViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
        nav1.viewControllers = [mainView]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
        // 3) Start with your navigation controller.
        checkout?.start(navigationController: nav1, lifeCycleProtocol: self)
    }
/*
  - (void)startCheckout:(CDVInvokedUrlCommand*)command {
    NSString* callbackId = [command callbackId];
    NSString* publicKey = [[command arguments] objectAtIndex:0];
    NSString* prefId = [[command arguments] objectAtIndex:1];
    
    [MercadoPagoContext setPublicKey:publicKey];
    
    if ([[command arguments] objectAtIndex:2]!= (id)[NSNull null]){
        UIColor *color = [UIColor colorwithHexString:[[command arguments] objectAtIndex:2] alpha:1];
        [MercadoPagoContext setupPrimaryColor:color complementaryColor:nil];
    } else {
        UIColor *color = [UIColor colorwithHexString:MERCADO_PAGO_BASE_COLOR alpha:1];
        [MercadoPagoContext setupPrimaryColor:color complementaryColor:nil];
    }
    if ([[[command arguments] objectAtIndex:3]boolValue]){
        [MercadoPagoContext setDarkTextColor];
    }else {
        [MercadoPagoContext setLightTextColor];
    }
    
    UINavigationController *choFlow =[MPFlowBuilder startCheckoutViewController:prefId callback:^(Payment *payment) {
        NSString *mppayment = [payment toJSONString];
        
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:mppayment];
        
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        
    }callbackCancel:nil];
    
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [rootViewController presentViewController:choFlow animated:YES completion:^{}];
    
}*/
}

// MARK: Optional Lifecycle protocol implementation example.
extension ViewController: PXLifeCycleProtocol {
    func finishCheckout() -> ((result: PXResult?) -> Void)? {
        self.commandDelegate!.send(pluginResult, callbackId: result);
        return nil
    }

    func cancelCheckout() -> ((message) -> Void)? {
        self.commandDelegate!.send(pluginResult, callbackId: message);
        return nil
    }

    func changePaymentMethodTapped() -> (() -> Void)? {
        return { () in
            print("px - changePaymentMethodTapped")
        }
    }

}

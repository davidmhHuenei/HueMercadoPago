//
//  ViewController.swift
//  MercadoPagoPlugin
//
//  Created by David Hermosilla on 21/03/2020.
//  Copyright © 2020 Huenei. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class ViewController: UIViewController {

    private var checkout: MercadoPagoCheckout?
    @IBAction func btnPagar(_ sender: UIButton) {
        runMercadoPagoCheckoutWithLifecycle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
/*
    private func runMercadoPagoCheckout() {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd", preferenceId: "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44").setLanguage("es")

        // 2) Create Checkout reference
        checkout = MercadoPagoCheckout(builder: builder)
        
        // 3) Start with your navigation controller.
        if let myNavigationController = navigationController {
            checkout?.start(navigationController: myNavigationController)
        }
    }*/

    private func runMercadoPagoCheckoutWithLifecycle() {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd", preferenceId: "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44").setLanguage("es")

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
extension UIViewController: PXLifeCycleProtocol {
    public func finishCheckout() -> ((_ payment: PXResult?) -> Void)? {
        self.dismiss(animated: false)
        return ({ (_ payment: PXResult?) in
            print(payment?.getStatus() ?? "")
        })
    }
    
    public func cancelCheckout() -> (() -> Void)? {
        self.dismiss(animated: false)
        return nil
    }

    public func changePaymentMethodTapped() -> (() -> Void)? {
        return { () in
            print("px - changePaymentMethodTapped")
        }
    }

}

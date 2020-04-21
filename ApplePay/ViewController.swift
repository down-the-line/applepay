//
//  ViewController.swift
//  ApplePay
//
//  Created by Hardeep Singh on 21/04/20.
//  Copyright © 2020 Hardeep Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var applePay: ApplePayment!
    func applePayButtonClicked() {
        applePay = ApplePayment(paymentType: .payfort, controller: self)
        applePay.applePayTapped(amount: "100")
    }

}


extension ViewController: ApplePaymentDelegate {
    var currencyCode: String {
        return "USD"
    }
    
    var countryCode: String {
        return "US"
    }
    
    var merchantIdentifier: String {
        return "com.hardeep.applepay.app"
    }
    
    func applePaymentFailedWithError(error: AppleyPayError) {
        
    }
    
    func didSuccessPayment(payment: ApplePayToken, response: [String : Any]) {
        
    }
    
    func didAuthorizationPayment(payment: ApplePayToken, callback: @escaping (Bool, [String : Any]?) -> Void) {
        // hanlde apple pay token
    }
    
}

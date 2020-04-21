//
//  ApplePayment.swift
//  TookanVendor
//
//  Created by Hardeep Singh on 13/04/20.
//  Copyright © 2020 Hardeep Singh. All rights reserved.
//

import Foundation
import PassKit

//protocol ApplePayment {
//    func applePayTapped(amount: String)
//    func didAuthorizePayment(payment: PKPayment, callback: (_ status: PKPaymentAuthorizationStatus, _ error: Error?) -> Void)
//}

protocol ApplePaymentDelegate: class {
    
    var currencyCode: String {get}
    var countryCode: String {get}
    var merchantIdentifier: String {get}
    
    func applePaymentFailedWithError(error: AppleyPayError)
    func didSuccessPayment(payment: ApplePayToken, response: [String: Any])
    func didAuthorizationPayment(payment: ApplePayToken, callback: @escaping (_ success: Bool, _ response: [String: Any]?) -> Void)
    var viewController: UIViewController { get }
}

extension ApplePaymentDelegate where Self: UIViewController {
    var viewController: UIViewController {
        return self
    }
}


extension ApplePayment {
    enum PaymentType {
        case payfort
    }
}


class ApplePayment: NSObject {
    
    weak var delegate: ApplePaymentDelegate?
    private var paymentType: PaymentType
    private weak var controller: UIViewController?
    
    private var payment: PKPayment?
    private var applePayToken: ApplePayToken?
    private var response: [String: Any]?
    
    init<Controler: ApplePaymentDelegate>(paymentType: PaymentType, controller: Controler) {
        self.paymentType = paymentType
        self.delegate = controller
        self.controller = controller.viewController
    }
    
    func applePayTapped(amount: String) {
        
        let paymentItem = PKPaymentSummaryItem.init(label: "Payment", amount: NSDecimalNumber(string: amount))
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa ]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            
            let request = PKPaymentRequest()
            request.currencyCode = delegate!.currencyCode
            request.countryCode = delegate!.countryCode
            request.merchantIdentifier = "merchant.com.artbuy.devapp"
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.supportedNetworks = paymentNetworks
            request.paymentSummaryItems = [paymentItem]
            
            if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) {
                paymentVC.delegate = self
                controller?.present(paymentVC, animated: true, completion: nil)
            }
        } else {
           // self.controller.displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.", viewController : controller)
        }
    }

}

extension ApplePayment: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        if let applePayToken = self.applePayToken, let response = self.response {
            delegate?.didSuccessPayment(payment: applePayToken, response: response)
        }
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        self.payment = payment

        do {
            let applePayToken = try ApplePayToken(payment: payment)
            self.applePayToken = applePayToken
            delegate?.didAuthorizationPayment(payment: applePayToken, callback: {[weak self] (success, response) in
                self?.response = response
                if success {
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                } else {
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                }
            })
        } catch {
            delegate?.applePaymentFailedWithError(error: error as! AppleyPayError)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        self.payment = payment
        
        do {
            
            let applePayToken = try ApplePayToken(payment: payment)
            self.applePayToken = applePayToken

            delegate?.didAuthorizationPayment(payment: applePayToken, callback: {[weak self] (success, response) in
                self?.response = response
                if success {
                    completion(.success)
                } else {
                    completion(.failure)
                }
            })
            
        } catch {
            delegate?.applePaymentFailedWithError(error: error as! AppleyPayError)
        }
        
    }
   
}

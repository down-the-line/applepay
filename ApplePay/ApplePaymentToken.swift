//
//  ApplePaymentToken.swift
//  TookanVendor
//
//  Created by Hardeep Singh on 19/04/20.
//  Copyright © 2020 Hardeep Singh. All rights reserved.
//

import Foundation
import PassKit

extension PKPaymentMethodType {
    
    var displayName: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .credit:
            return "Credit"
        case .debit:
            return "Debit"
        case .prepaid:
            return "prepaid"
        case .store:
            return "Store"
        @unknown default:
            fatalError()
        }
    }

}

struct ApplePayToken {
    
    var paymentData: PaymentData
    var paymentMethod: PKPaymentMethod
    
    init(payment: PKPayment) throws {
        
        let paymentData = payment.token.paymentData
        
        do {
            
            guard let json =  try JSONSerialization.jsonObject(with: paymentData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] else {
                throw AppleyPayError.jsonSerializationError("Failed to serialization payment taken")
            }
            
            guard let payment  = PaymentData(dict: json) else {
                throw AppleyPayError.jsonSerializationError("Failed to serialization payment taken")
            }
            
            self.paymentData = payment

        } catch let parseError {
            throw AppleyPayError.jsonSerializationError(parseError.localizedDescription)
        }
        
        paymentMethod = payment.token.paymentMethod
    }
    
}

extension ApplePayToken {
    struct PaymentData {
        var version: String
        var signature: String
        var data: String
        var header: Header
    }
}

extension ApplePayToken.PaymentData {
    
    struct Header {
        var ephemeralPublicKey: String
        var publicKeyHash: String
        var transactionId: String
    }
    
    init?(dict: [String: Any]) {
        guard let version = dict["version"] as? String,
            let signature = dict["signature"] as? String,
            let data = dict["data"] as? String else {
            return nil
        }
        
        guard let headerDict = dict["header"] as? [String: Any],
            let header =  Header(dict: headerDict) else  {
                return nil
        }
        
        self.header = header
        
        self.version = version
        self.signature = signature
        self.data = data
        
       
    }
    
}

extension ApplePayToken.PaymentData.Header {
    init?(dict: [String: Any]) {
        guard let ephemeralPublicKey = dict["ephemeralPublicKey"] as? String,
            let publicKeyHash = dict["publicKeyHash"] as? String,
            let transactionId = dict["transactionId"] as? String else {
                return nil
        }
        self.ephemeralPublicKey = ephemeralPublicKey
        self.publicKeyHash = publicKeyHash
        self.transactionId = transactionId
    }
}

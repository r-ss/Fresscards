//
//  StoreManager.swift
//  Fresscards
//
//  Created by Alex Antipov on 04.04.2023.
//

//import Foundation
import StoreKit

class StoreManager: NSObject, ObservableObject {
    
    // Set your in-app purchase product identifiers here
    private let productIdentifiers: Set<String> = ["com.ress.Fresscards"]
    
    private var productsRequest: SKProductsRequest?
    var products = [SKProduct]()
    
    @Published var purchaseStatus: PurchaseStatus = .none
    
    enum PurchaseStatus {
        case none
        case purchasing
        case success
        case failed
    }
    
    func getProducts() {
        guard SKPaymentQueue.canMakePayments() else {
            print("In-app purchases are not enabled on this device.")
            return
        }
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func purchase(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            print("In-app purchases are not enabled on this device.")
            return
        }
        
        purchaseStatus = .purchasing
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error fetching products: \(error.localizedDescription)")
    }
}

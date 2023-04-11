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
    private let productIdentifiers: Set<String> = ["unlimited_generator"]
    
    private var productsRequest: SKProductsRequest?
    @Published var products = [SKProduct]()
    
    @Published var purchaseStatus: PurchaseStatus = .none
    
    @Published var purchasedProductIdentifiers: Set<String> = []
    
    enum PurchaseStatus {
        case none
        case purchasing
        case success
        case failed
    }
    
    func lookup() {
        for productIdentifier in productIdentifiers {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                self.purchasedProductIdentifiers.insert(productIdentifier)
//                print("Previously purchased: \(productIdentifier)")
            } else {
//                print("Not purchased: \(productIdentifier)")
            }
        }
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
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        print("restoring ...")
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error fetching products: \(error.localizedDescription)")
    }
}

// MARK: - SKPaymentTransactionObserver

extension StoreManager: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue,
                             updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                print(".restored --")
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
//                fail(transaction: transaction)
                break;  // to make XCode no complain
            }
            
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseStatus = .success
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: Notification.Name("purchase.completed"), object: identifier)
    }
}


// to show price with currency symbol
public extension SKProduct {
    
    var localizedPrice: String? {
        // Initialize Number Formatter
        let numberFormatter = NumberFormatter()
        
        // Configure Number Formatter
        numberFormatter.locale = priceLocale
        numberFormatter.numberStyle = .currency
        
        return numberFormatter.string(from: price)
    }
    
}

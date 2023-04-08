//
//  StoreView.swift
//  Fresscards
//
//  Created by Alex Antipov on 04.04.2023.
//

import SwiftUI

struct StoreView: View {
    
    @ObservedObject var storeManager = StoreManager()
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            if storeManager.purchasedProductIdentifiers.contains("unlimited_generator") {
                Text("You have a full version. Thank you for your support! We are working on more features right now")
                
//                Text("Purchased:")
//                ForEach(storeManager.purchasedProductIdentifiers.sorted(), id: \.self) { purchased in
//                    Text(purchased)
//                }
                
                
            } else {
                Text("We are paying costs for cards generations, please support us with one-time purchase to use generator without limit.")
                
                
//                    .background(.pink)
                
                ForEach(storeManager.products, id: \.self) { product in
                    Divider()
                    HStack {
                        Text(product.localizedTitle)
                        Spacer()
                        Button(action: {
                            storeManager.purchase(product: product)
                        }, label: {
                            Text("\(product.localizedPrice ?? "Error")")
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(8)
                        })
                    }
                    .padding(.vertical, 15)
                    Divider()
//                    .background(.pink)
                }
                
                switch storeManager.purchaseStatus {
                case .none:
                    Text("")
                case .purchasing:
                    ProgressView("Purchasing...")
                        .padding(.vertical, 15)
                case .success:
                    Text("Purchase Successful!")
                case .failed:
                    Text("Purchase Failed!")
                }
                
                Button(action: {
                    storeManager.restorePurchases()
                }, label: {
                    Text("Restore Purchases")
                })
                
                
                Group {
                    Text("Purchase also allowing \(Config.additionalLanguages.count) more languages: \(Config.additionalLanguages.joined(separator: ", ")) — \(Config.baseLanguages.count + Config.additionalLanguages.count) languages total in any direction!")
                        .padding(.top, 20)

                }
                
            }
            
            
        }
//        .background(.pink)
        .onAppear {
//            print("Getting products...")
            storeManager.getProducts()
            storeManager.lookup()
        }
        .padding(0)
    }
}


struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}




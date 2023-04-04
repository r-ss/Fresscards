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
        VStack {
            Text("Available Products:")
                .font(.headline)
            
            ForEach(storeManager.products, id: \.self) { product in
                HStack {
                    Text(product.localizedTitle)
                    Spacer()
                    Button(action: {
                        storeManager.purchase(product: product)
                    }, label: {
                        Text("\(product.price)")
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                }
                .padding()
            }
            
            switch storeManager.purchaseStatus {
            case .none:
                Text("")
            case .purchasing:
                ProgressView("Purchasing...")
            case .success:
                Text("Purchase Successful!")
            case .failed:
                Text("Purchase Failed!")
            }
        }
        .onAppear {
            print("Getting products...")
            storeManager.getProducts()
        }
    }
}


struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}

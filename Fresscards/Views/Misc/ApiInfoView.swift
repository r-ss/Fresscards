//
//  ApiInfoView.swift
//  Energram
//
//  Created by Alex Antipov on 18.02.2023.
//

import Foundation
import SwiftUI

struct ApiInfoView: View {
    var body: some View {
        Group {
            if let ready = info {
                Text(ready).font(jsonFont)
            } else {
                LoaderSpinner()
            }
        }
        .onAppear {
            Task { await self.fetchApiInfo() }
        }
        .padding()
    }
    
    // MARK: Private
    @State private var info: String?
    @State private var loadInProgress: Bool = false
    
    private let jsonFont = Font.system(size: 12).monospaced()
    
    private func fetchApiInfo() async {
        Task(priority: .background) {
            loadInProgress = true
            let response = await FresscardsService().fetchApiInfo()
            switch response {
            case .success(let result):
                info = result
                loadInProgress = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                loadInProgress = false
            }
        }
    }
}


struct ApiInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ApiInfoView()
    }
}

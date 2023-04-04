//
//  DebugView.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI

private func modelIdentifier() -> String {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

struct DebugView: View {
    
    var screenWidth: String { String(format: "%.01f", UIScreen.main.bounds.width) }
    var screenHeight: String { String(format: "%.01f", UIScreen.main.bounds.height) }
    
//    @ObservedObject var apiInfoService = ApiInfoService()
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Debug Info").font(.title)
                    
                    Text("Screen: \(screenWidth)x\(screenHeight)")
                    Text("Device: \(modelIdentifier())")
                    Text("Palette:").fontWeight(.bold)
                    VStack(spacing: 1) {
                        Rectangle().fill(Palette.a).frame(width: 200, height: 20)
                        Rectangle().fill(Palette.b).frame(width: 200, height: 20)
                        Rectangle().fill(Palette.c).frame(width: 200, height: 20)
                        Rectangle().fill(Palette.d).frame(width: 200, height: 20)
                        Rectangle().fill(Palette.e).frame(width: 200, height: 20)
                    }
                    Text("API info:").fontWeight(.bold)
                    ApiInfoView()
                }
                .frame(width: geometry.size.width, alignment: .leading)
            }
        }}
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}

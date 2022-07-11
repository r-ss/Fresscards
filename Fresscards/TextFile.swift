//
//  TextFile.swift
//  Fresscards
//
//  Created by Alex Antipov on 11.07.2022.
//


import SwiftUI
import UniformTypeIdentifiers


struct TextFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.json]
//    static var readableContentTypes: [UTType] { [.plainText] }

    // by default our document is empty
    var text: String = ""
    
    init(text: String) {
        self.text = text
    }

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

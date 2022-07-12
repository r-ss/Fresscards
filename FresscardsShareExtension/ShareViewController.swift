//
//  ShareViewController.swift
//  FresscardsShareExtension
//
//  Created by Alex Antipov on 11.07.2022.
//

import UIKit
import Social

import MobileCoreServices

import os // for Logger


class ShareViewController: SLComposeServiceViewController {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "extension")
    
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        logger.log("isContentValid() call")
        return true
    }
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        //        var imageType = ""
        
        //        let _ = print("WWWW ow")
        //        let readURL = Bundle.main.url(forResource: "inputpic", withExtension: "jpeg")! //Example json file in our bundle
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Initializing the url for the location where we store our data in filemanager
        
        let targetURL = documentDirectory // appending the file name to the url
            .appendingPathComponent("inputpic")
            .appendingPathExtension("jpeg")
        
        
        
        logger.log("Message from logger")
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem {
            logger.log("Item: \(item)")
            for ele in item.attachments!{
                let itemProvider = ele // as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg"){
                    
                    logger.log("itemProvider.hasItemConformingToTypeIdentifier")
                    
                    itemProvider.loadItem(forTypeIdentifier: "public.jpeg", options: nil, completionHandler: { (item, error) in
                        
                        
                        if let url = item as? URL {
                            self.logger.log("trying to copy file")
                            self.logger.log("from: \(url)")
                            self.logger.log("to: \(targetURL)")
                            //                            imgData = try! Data(contentsOf: url)
//                            if !FileManager.default.fileExists(atPath: targetURL.path) {
                                
                                do {
                                    print("What the heck...")
                                    try FileManager.default.copyItem(at: url, to: targetURL)
                                    print("Success! Yum.")
                                } catch {
                                    print("Copy error: \(error).")
                                }
                                    
//                            }
                        }
                        
                        
                    })
                    
                    
                    
                    
                }
            }
        }
        
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        logger.log("configurationItems() call")
        return []
    }
    
}


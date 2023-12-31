//
//  LocalFileManager.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-22.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init() {
        
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        
        // get url for image
        guard
            let data = image.pngData(),
            let url = getURLforImage(imageName: imageName, folderName: folderName)
            else { return }
        
        // save image
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLforImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        
        return UIImage(contentsOfFile: url.path)
        
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLforFolder(folderName: folderName) else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getURLforFolder(folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLforImage(imageName: String, folderName: String) -> URL? {
        
        guard let folderUrl = getURLforFolder(folderName: folderName) else {
            return nil
        }
        
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}

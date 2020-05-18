//
//  ImageProtocol.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/21/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import Foundation
import UIKit

protocol ImageStuff{
    
   static func getImage(for key: String) -> UIImage
   static func saveImage(key: String, img: UIImage)
    
}

extension ImageStuff{
    
   static func getImage(for key: String) -> UIImage {
        if let filePath = filePath(forKey: key), let fileData = FileManager.default.contents(atPath: filePath.path), let img = UIImage(data: fileData){
            return img
        }
        return UIImage(named: "avatar")!
    }
    
   static func saveImage(key: String, img: UIImage){
        if let filePath = filePath(forKey: key), let avatar = img.pngData(){
            do {
                try avatar.write(to: filePath, options: .atomic)
            }catch let error{
                print("Saving file resulted in error: ", error)
            }
        }
    }
    
   static private func filePath(forKey key: String) -> URL?{
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
}

class ImageStorage: ImageStuff {}

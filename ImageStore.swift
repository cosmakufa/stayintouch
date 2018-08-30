//
//  imageStore.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/31/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    //---------------------------------Variables -----------------------------------------------------------------------------
    
    let cache = NSCache<AnyObject, AnyObject>.init()
    
    
    //---------------------------------Functions-----------------------------------------------------------------------------
    
    func imageURLForKey(key: String) -> NSURL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key) as NSURL
    }
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
        let imageURL = imageURLForKey(key: key)
        
        if let data = UIImageJPEGRepresentation(image, 0.5){
          try!  data.write(to: imageURL as URL, options: .atomic)
        }
        
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as AnyObject) as? UIImage {
            return existingImage
        }
        let imageURL = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage.init(contentsOfFile: imageURL.path!) else{
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key as AnyObject)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String){
        cache.removeObject(forKey: key as AnyObject)
        let imageURL = imageURLForKey(key: key)
        try! FileManager.default.removeItem(at: imageURL as URL)
    }
}

//
//  UIImageView+loadImages.swift
//  Youtube
//
//  Created by Junyu Lin on 28/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImages(string: String){
        let url = URL(string: string)
        
        if let imageFromCache = imageCache.object(forKey: string as AnyObject) as? UIImage{
            self.image = imageFromCache
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: string as AnyObject)
                self.image = imageToCache
            })
            }.resume()
    }
}

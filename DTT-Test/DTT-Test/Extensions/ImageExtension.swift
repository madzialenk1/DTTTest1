//
//  ImageExtension.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 06.08.21.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImge(withUrl url: URL) {
        
        if let image = imageCache.object(forKey: url.relativeString as NSString) as? UIImage {
            self.image = image
            imageCache.setObject(image, forKey: url.relativeString as NSString)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let imageData = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: imageData) else { return }
                    DispatchQueue.main.async {
                        self?.image = image
                        imageCache.setObject(image, forKey: url.relativeString as NSString)
                        
                    }
                
            
            
        }
    }
}

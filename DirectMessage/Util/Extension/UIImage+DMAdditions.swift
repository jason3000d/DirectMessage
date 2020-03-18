//
//  UIImage+DMAdditions.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/11.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func dm_setImage(with url: URL, completion: ((UIImage?, Error?) -> Void)? = nil) {
        
        let hashValue = url.hashValue
        guard self.tag != hashValue else { return }
        self.tag = hashValue
        
        DMBaseService.shared.getImage(from: url) { [weak self] (image, error) in
            DispatchQueue.main.async {
                self?.image = image
                completion?(image, error)
            }
        }
    }
    
}

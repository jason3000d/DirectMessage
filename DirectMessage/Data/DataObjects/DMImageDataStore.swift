//
//  DMImageDataStore.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/14.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

class DMImageDataStore {
    
    private var imageCache = NSCache<NSString, UIImage>()

    func getImage(with url: URL?, for imageView: UIImageView) {
        guard let url = url,
            let urlString = url.absoluteString as NSString? else { return }
        if let avatar = self.imageCache.object(forKey: urlString) {
            imageView.image = avatar
        } else {
            imageView.dm_setImage(with: url) { (image, error) in
                guard let avatar = image else { return }
                self.imageCache.setObject(avatar, forKey: urlString)
            }
        }
    }
}


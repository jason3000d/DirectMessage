//
//  DMBaseService+Image.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/11.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

extension DMBaseService {
    
    @discardableResult
    func getImage(from url: URL, completion: @escaping (_ users: UIImage?, _ error: Error?) -> Void) -> URLSessionDataTask? {

        let request = self.request(with: url, methodType: .get, body: nil) as URLRequest
        let dataTask = self.session?.dataTask(with: request, completionHandler: { (data, response, err) in

            guard err == nil,
                let rawData = data,
                let image = UIImage(data: rawData)else {
                    completion(nil, DMBaseService.aggregateError(err, data: data, response: response))
                    return
            }
            
            DispatchQueue.main.async {
                completion(image, err)
            }

        })
        dataTask?.resume()
        return dataTask
    }

}

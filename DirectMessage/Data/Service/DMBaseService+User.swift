//
//  DMBaseService+User.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/8.
//  Copyright © 2020 Paradise. All rights reserved.
//

import Foundation

extension DMBaseService {
    
    @discardableResult
    func getUserList(since: UInt = 0, completion: @escaping (_ users: [DMUser]?, _ error: Error?) -> Void) -> URLSessionDataTask? {

        let apiPath = "/users"
        let queryItem = URLQueryItem(name: "since", value: "\(since)")
        guard let url = createUrl(with: baseServerURLString, apiPath: apiPath, queryItems: [queryItem]) else {
            completion(nil, NSError())
            return nil
        }

        let request = self.request(with: url, methodType: .get, body: nil) as URLRequest
        let dataTask = self.session?.dataTask(with: request, completionHandler: { (data, response, err) in

            guard err == nil,
                let jsonArr = DMServiceUtils.dataToJsonArray(data: data).0 else {
                    completion(nil, DMBaseService.aggregateError(err, data: data, response: response))
                    return
            }
            
            let (userList, error): ([DMUser]?, Error?) = DMServiceUtils.parse(jsons: jsonArr)
            DispatchQueue.main.async {
                completion(userList, err ?? error)
            }

        })
        dataTask?.resume()
        return dataTask
    }
    
}


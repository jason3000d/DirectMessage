//
//  DMBaseService.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/8.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

// MARK: API base tool
class DMBaseService: NSObject {

    enum Environment {
        case prod
    }

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    enum ContentType: String {
        case json = "application/json"
        case formUrlencoded = "application/x-www-form-urlencoded"
    }
    
    enum HttpStatus: Int {
        case `continue` = 100       /// Continue
        case processing = 102       /// Processing
        case ok = 200               /// Ok
        case noContent = 204        /// No Content
        case multipleChoices = 300  /// Multiple Choices
        case notModified = 304      /// Not Modified
        case badRequest = 400       /// Bad Request
        case unauthorized = 401     /// Unauthorized
        case forbidden = 403        /// Forbidden
        case notFound = 404         /// Not Found
        case conflict = 409         /// Conflict
    }

    static let shared = DMBaseService()
    var sessionConfiguration = URLSessionConfiguration.default
    var session: URLSession?
    var enviroment: Environment = .prod

    var baseServerURLString: String {
        var host = ""
        switch enviroment {
        case .prod:
            host = "https://api.github.com"
        }
        return host
    }

    override init() {
        sessionConfiguration.httpAdditionalHeaders = ["Content-Type": "application/json; charset=UTF-8",
                                                      "Accept": "application/json"]
        session = URLSession(configuration: sessionConfiguration)
    }

    /// Return URL by combining host, api path and query items.
    ///
    /// - Parameters:
    ///   - host: The host of URL
    ///   - apiPath: The API path of URL
    ///   - queryItems: The query items of URL
    /// - Returns: Retrun URL if all requirements met, otherwise nil
    func createUrl(with host: String, apiPath: String?, queryItems: [URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents(string: host)
        urlComponents?.path = apiPath ?? ""
        urlComponents?.queryItems = queryItems ?? nil
        return urlComponents?.url ?? nil
    }

    /// Return mutable URL request with URL, method type and body.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - methodType: The type for http request
    ///   - body: The data for request if needed
    /// - Returns: Return the mutable request with all requirements
    func request(with url: URL, methodType: HTTPMethod, body: Data?) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = methodType.rawValue
        request.httpBody = body
        return request
    }

    // MARK: Class methods

    /// Create the error that represents the service's situation.
    ///
    /// - Parameters:
    ///   - requestError: The error of response
    ///   - data: THe data of response
    ///   - response: Request's response
    /// - Returns: The concrete error.
    class func aggregateError(_ requestError: Error?, data: Data?, response: URLResponse?) -> Error? {
        guard requestError == nil else {
            return requestError
        }
        guard data != nil else {
            if let status = (response as? HTTPURLResponse)?.statusCode {
                return NSError.dm_request(with: status)
            }
            return nil
        }
        return nil
    }

}


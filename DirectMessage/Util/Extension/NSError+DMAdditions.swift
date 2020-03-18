//
//  NSError+DMAdditions.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/8.
//  Copyright © 2020 Paradise. All rights reserved.
//

import Foundation

extension NSError {

    enum DMServiceCode: Int {
        case timeout
        case success
        case initilizationFailed
        case failed
        case permissionDenied
        case notFound
        case invalidFormat
    }

    enum DMDataValidationCode: Int {
        case missingRequiredParams
        case nullResponse
        case invalidJson
    }

    enum DMDomain: String {
        case request = "com.paradise.directMessage.request"
        case service = "com.paradise.directMessage.service"
        case validation = "com.paradise.directMessage.validation"
        case test = "com.paradise.directMessage.test"
    }

    static let DMConnectionErrorMessage = "connection error"
    static let DMRawDataKey = "errorObjects"
    static let DMTagKey = "tag"

    static let dm_monkeyTest = {
        return NSError(domain: DMDomain.test.rawValue, code: 0, userInfo: nil)
    }()

    private static func dm_infoDict(tag: String? = nil, rawData: Any? = nil) -> [String: Any]? {
        var info: [String: Any] = [:]
        if let rawData = rawData {
            info[DMRawDataKey] = rawData
        }
        if let tag = tag {
            info[DMTagKey] = tag
        }
        return info.count > 0 ? info : nil
    }

    static func dm_validation(with code: DMDataValidationCode, tag: String? = nil, rawData: Any? = nil) -> NSError {
        let info = NSError.dm_infoDict(tag: tag, rawData: rawData)
        return NSError(domain: DMDomain.validation.rawValue, code: code.rawValue, userInfo: info)
    }

    static func dm_service(with code: DMServiceCode, tag: String? = nil, rawData: Any? = nil) -> NSError {
        let info = NSError.dm_infoDict(tag: tag, rawData: rawData)
        return NSError(domain: DMDomain.service.rawValue, code: code.rawValue, userInfo: info)
    }

    static func dm_request(with statusCode: Int, tag: String? = nil, rawData: Any? = nil) -> NSError {
        let info = NSError.dm_infoDict(tag: tag, rawData: rawData)
        return NSError(domain: DMDomain.request.rawValue, code: statusCode, userInfo: info)
    }

}

//
//  DMServiceUtils.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/9.
//  Copyright © 2020 Paradise. All rights reserved.
//

import Foundation

struct DMServiceUtils {

    /// Convert JSON to model object.
    /// - Parameters:
    ///   - json: The JSON dict to be convert.
    ///   - fileName: The caller file name.
    ///   - functionName: The caller function name.
    ///   - line: The caller line.
    static func parse<T: Decodable>(json: Any?, fileName: String = #file, functionName: String = #function, line: Int = #line) -> (T?, Error?) {
        var returnTuple: (T?, Error?)

        guard let json = json else {
            returnTuple = (nil, NSError.dm_validation(with: .nullResponse, tag: #function))
            return returnTuple
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            returnTuple = self.parse(data: data, fileName: fileName, functionName: functionName, line: line)
            return returnTuple
        } catch {
            returnTuple = (nil, NSError.dm_validation(with: .invalidJson, tag: #function))
            return returnTuple
        }
    }

    /// Convert multiple JSON dict to model objects.
    /// - Parameters:
    ///   - jsons: The JSON array to be convert.
    ///   - fileName: The caller file name.
    ///   - functionName: The caller function name.
    ///   - line: The caller line.
    static func parse<T: Decodable>(jsons: [Any], fileName: String = #file, functionName: String = #function, line: Int = #line) -> ([T]?, Error?) {
        var models = [T]()
        var error: Error?
        for json in jsons {
            let (model, err): (T?, Error?) = parse(json: json, fileName: fileName, functionName: functionName, line: line)
            guard err == nil,
                let dataModel = model
            else {
                error = err
                continue
            }
            models.append(dataModel)
        }
        return (models.count > 0 ? models : nil, error)
    }

    /// Convert data to model object.
    /// - Parameters:
    ///   - data: The data to be convert.
    ///   - fileName: The caller file name.
    ///   - functionName: The caller function name.
    ///   - line: The caller line.
    static func parse<T: Decodable>(data: Data?, fileName: String = #file, functionName: String = #function, line: Int = #line) -> (T?, Error?) {
        let returnTuple: (T?, Error?) = data?.dm_parse(fileName: fileName, functionName: functionName, line: line) ?? (nil, NSError.dm_validation(with: .nullResponse, tag: #function))
        return returnTuple
    }

    /// Convert data to JSON dict.
    /// - Parameters:
    ///   - data: The data to be convert.
    ///   - fileName: The caller file name.
    ///   - functionName: The caller function name.
    ///   - line: The caller line.
    static func dataToJsonDict(data: Data?, fileName: String = #file, functionName: String = #function, line: Int = #line) -> ([String: Any]?, Error?) {
        let returnTuple = data?.dm_toJsonDict(fileName: fileName, functionName: functionName, line: line) ?? (nil, NSError.dm_validation(with: .nullResponse, tag: #function))
        return returnTuple
    }

    /// Convert data to JSON array.
    /// - Parameters:
    ///   - data: The data to be convert.
    ///   - fileName: The caller file name.
    ///   - functionName: The caller function name.
    ///   - line: The caller line.
    static func dataToJsonArray(data: Data?, fileName: String = #file, functionName: String = #function, line: Int = #line) -> ([Any]?, Error?) {
        let returnTuple = data?.dm_toJsonArray(fileName: fileName, functionName: functionName, line: line) ?? (nil, NSError.dm_validation(with: .nullResponse, tag: #function))
        return returnTuple
    }

}

extension Data {

    /// Convert data to model object.
    /// - Parameters:
    ///   - fileName: The caller file name.
    ///   - functionName: The caller function name.
    ///   - line: The caller line.
    fileprivate func dm_parse<T: Decodable>(fileName: String = #file, functionName: String = #function, line: Int = #line) -> (T?, Error?) {
        var retError: Error?
        var targetObject: T?
        do {
            targetObject = try JSONDecoder().decode(T.self, from: self)
        } catch {
            retError = error
        }
        return (targetObject, retError)
    }

    /// Convert data to JSON dict.
    /// - Parameters:
    ///   - fileName: The caller file name.
    ///   - functionName: The caller function name.
    ///   - line: The caller line.
    fileprivate func dm_toJsonDict(fileName: String = #file, functionName: String = #function, line: Int = #line) -> ([String: Any]?, Error?) {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
            return (json, nil)
        } catch {
            return (nil, error)
        }
    }

    /// Convert data to JSON array.
    /// - Parameters:
    ///   - fileName: The caller file name.
    ///   - functionName: The caller function name.
    ///   - line: The caller line.
    fileprivate func dm_toJsonArray(fileName: String = #file, functionName: String = #function, line: Int = #line) -> ([Any]?, Error?) {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: []) as? [Any]
            return (json, nil)
        } catch {
            return (nil, error)
        }
    }

}

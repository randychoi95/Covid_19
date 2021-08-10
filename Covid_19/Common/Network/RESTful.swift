//
//  RESTful.swift
//  Covid_19
//
//  Created by 최제환 on 2021/08/10.
//

import Foundation

enum JSONDecoderError:Error {
    case JSONDecodingError
}

class RESTful {
    public static func centerSearchNetwork(_ param: [String: Any]?, _ method: Method, completionHandler: @escaping(_ result: Int, _ data: Centers?, _ error: Error?)->()) {
        HTTPRequest.request(param: param, method: method) { result, data, error in
            if result == -1 {
                completionHandler(result,nil,error)
            } else {
                if let dat = data {
                    do {
                        let centerData = try JSONDecoder.init().decode(Centers.self, from: dat)
                        completionHandler(result,centerData,nil)
                    } catch {
                        completionHandler(-1,nil,JSONDecoderError.JSONDecodingError)
                    }
                }
            }
        }
    }
}

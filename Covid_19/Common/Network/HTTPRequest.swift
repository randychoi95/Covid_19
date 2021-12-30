//
//  HTTPRequest.swift
//  Covid_19
//
//  Created by 최제환 on 2021/08/09.
//

import Foundation

enum ServerError: Error {
    case status_401 // "인증 정보가 정확 하지 않음"
    case status_500 // "API 서버에 문제가 발생하였음"
}

enum Method: String {
    case get = "GET"
    case post = "POST"
}

enum PATH: String {
    case vaccination_center = "15077586/v1/centers"
}

class HTTPRequest: NSObject {
    static let baseURL = "https://api.odcloud.kr/api/"
    
    public static func request(param: [String: Any]?,path: PATH, method: Method, completionHandler: @escaping (_ result: Int, _ data: Data?, _ error: Error?)->()) {
        let urlStr = "\(baseURL)\(path.rawValue)"
        guard let url = URL(string: urlStr) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("UTF-8", forHTTPHeaderField: "charset")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var paramArr = [String]()
        guard let param = param else {
            completionHandler(-1,nil,nil)
            return
        }
        for (key,value) in param {
            paramArr.append("\(key)=\(value)")
        }
        let paramData = paramArr.joined(separator: "&")
        request.url = URL(string: "\(urlStr)?\(paramData)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                completionHandler(-1,data,err)
            }
            else {
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 200 {
                        if let dat = data {
                            completionHandler(1,dat,nil)
                        }
                    } else if response.statusCode == 401 {
                        completionHandler(-1,nil,ServerError.status_401)
                    } else if response.statusCode == 500 {
                        completionHandler(-1,nil,ServerError.status_500)
                    }
                }
            }
        }
        task.resume()
    }
}

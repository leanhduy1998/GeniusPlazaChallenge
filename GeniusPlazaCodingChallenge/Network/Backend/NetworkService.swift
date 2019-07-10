//
//  NetworkService.swift
//  GeniusPlazaCodingChallenge
//
//  Created by Duy Le 2 on 7/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation

class NetworkService{
    private var task:URLSessionDataTask?
    private var successCodes:Range<Int> = 200..<299
    private var failureCodes:Range<Int> = 400..<499
    
    enum Method:String{
        case GET,POST,PUT,DELETE
    }
    
    func request(url: URL, method: Method,
                 params: [String: Any]? ,
                 headers: [String: String]? ,
                 success: ((Data?) -> Void)? ,
                 failure: ((_ data: Data?, _ error: Error?, _ responseCode: Int) -> Void)?) {
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 10.0)
        
        
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        if let params = params {
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        let session = URLSession.shared
        task = session.dataTask(with: urlRequest, completionHandler: {[weak self] data, response, error in
            
            guard let strongself = self else{return}
            
            guard let httpResponse = response as? HTTPURLResponse else {
                failure?(data, error , 0)
                return
            }
            
            if(error != nil){
                failure?(data,error,httpResponse.statusCode)
            }
            else if (strongself.successCodes.contains(httpResponse.statusCode)){
                success?(data)
            }
            else if (strongself.failureCodes.contains(httpResponse.statusCode)){
                failure?(data,error,httpResponse.statusCode)
            }
            else{
                let info = [
                    NSLocalizedDescriptionKey: "Request failed with code \(httpResponse.statusCode)",
                    NSLocalizedFailureReasonErrorKey: "Unexpected Error"
                ]
                let error = NSError(domain: "NetworkService", code: 0, userInfo: info)
                failure?(data, error, httpResponse.statusCode)
            }
        })
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}

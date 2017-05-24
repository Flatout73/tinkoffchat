//
//  RequestSender.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 24.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {
    let session = URLSession.shared
    
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.Fail("url string can't be parser to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.Fail(error.localizedDescription))
                return
            }
            guard let data = data,
                let parsedModel: T = config.parser.Parse(data: data) else {
                    completionHandler(Result.Fail("recieved data can't be parsed"))
                    return
            }
            completionHandler(Result.Success(parsedModel))
        }
        
        task.resume()
    }
}

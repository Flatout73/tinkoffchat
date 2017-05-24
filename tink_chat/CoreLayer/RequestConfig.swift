//
//  RequestConfig.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 24.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

struct RequestConfig<T> {
    let request: IRequest
    let parser: Parser<T>
}

enum Result<T> {
    case Success(T)
    case Fail(String)
} 

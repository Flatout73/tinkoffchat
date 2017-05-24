//
//  RequestFactory.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 24.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

struct RequestFactory {
    struct ImageApi {
        static func loadImage() ->RequestConfig<[ApiImage]> {
            let request = ImageRequest(apiKey: "5453512-c06a9a425b0abc29618814451")
            return RequestConfig<[ApiImage]>(request: request, parser: ImageParser())
        }
    }
}

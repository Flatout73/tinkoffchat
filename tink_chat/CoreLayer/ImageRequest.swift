//
//  ImageSender.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 24.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    
    private var baseURL = "https://pixabay.com/api/"
    private let apiKey: String
    
    private var imageType = "photo"
    private var pretty = true
    private var perPage = 100
    private var q = "green+cars"
    
    private var getParameters: [String: String] {
        return ["q": q,
                "image_type": imageType,
                "pretty": String(pretty),
                "per_page": String(perPage)
                ]
    }
    
    private var urlString: String {
        let params = getParameters.flatMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseURL + "?key=" + apiKey + "&" + params
    }
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

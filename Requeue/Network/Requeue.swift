//
//  Requeue.swift
//  Requeue
//
//  Created by Mina Malak on 6/27/20.
//  Copyright © 2020 Mina Malak. All rights reserved.
//

import UIKit
enum Requeue {
    case listArticles(period: String,apiKey: String)
}

extension Requeue: Endpoint {
    var base: String {
        return Bundle.main.baseURL
    }
    
    var prefix: String {
        return "/"
    }
    
    var path: String {
        switch self {
        case .listArticles(let period,_):
            return "svc/mostpopular/v2/viewed/\(period).json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listArticles:
            return .get
        }
    }
    
    var headers : [httpHeader] {
        return []
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .listArticles(_,let apiKey):
            return [URLQueryItem(name:"api-key", value: apiKey)]
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var Cancellable : Bool {
        return false
    }
}


extension URLRequest{
    mutating func addHeaders(_ Headers:[httpHeader]){
        for Header in Headers {
            self.addValue(Header.value, forHTTPHeaderField: Header.key)
        }
    }
}

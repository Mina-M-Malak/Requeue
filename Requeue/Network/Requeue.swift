//
//  Tons.swift
//  TonsProject
//
//  Created by Mina Malak on 6/27/20.
//  Copyright © 2020 Mina Malak. All rights reserved.
//

import UIKit
enum Tons {
    case getProduct(offset: Int,limit: Int)
    case updateCart(product: UpdateCartModel)
    case getCart
}

extension Tons: Endpoint {
    var base: String {
        return Bundle.main.tonsBaseURL
    }
    
    var prefix: String {
        return Bundle.main.apiPrefix
    }
    
    var path: String {
        switch self {
        case .getProduct:
            return "products"
        case .updateCart,.getCart:
            return "cart"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProduct,.getCart:
            return .get
        case .updateCart:
            return .post
        }
    }
    
    var headers : [httpHeader] {
        return []
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getProduct(offset: let offset, limit: let limit):
            return [URLQueryItem(name:"limit", value: "\(limit)"), URLQueryItem(name:"offset", value: "\(offset)")]
        case .getCart:
            guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return []}
            return [URLQueryItem(name:"id", value: uuid)]
        default:
            return []
        }
    }
    
    var body: Data? {
        switch self {
        case .updateCart(let product):
            do {
                let jsonData = try JSONEncoder().encode(product)
                return jsonData
            }catch {
                return nil
            }
        default:
            return nil
        }
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

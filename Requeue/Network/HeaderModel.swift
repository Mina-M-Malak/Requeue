//
//  HeaderModel.swift
//  TonsProject
//
//  Created by Mina Malak on 6/27/20.
//  Copyright © 2020 Mina Malak. All rights reserved.
//

import Foundation

struct httpHeader:Decodable {
    var key:String
    var value:String
}

enum APIResult<T, U> where T: Decodable, U: Error  {
    case success(T)
    case failure(U)
}

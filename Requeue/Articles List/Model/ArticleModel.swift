//
//  ArticleModel.swift
//  Requeue
//
//  Created by Mina Malak on 10/25/20.
//

import Foundation

struct NYTimesResponse: Codable{
    var articles: [Article] = [Article]()
    
    enum CodingKeys: String,CodingKey{
        case articles = "results"
    }
}

struct Article: Codable{
    var url: String = ""
    var title: String = ""
    var abstract: String = ""
    var media: [Media] = [Media]()
}

struct Media: Codable {
    var type: String = ""
    var metaData: [MetaData] = [MetaData]()
    
    enum CodingKeys: String,CodingKey{
        case metaData = "media-metadata"
        case type
    }
}

struct MetaData: Codable {
    var url: String = ""
    var format: String = ""
}

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
    
    var id: Int = 0
    var type: String = ""
    var byline: String = ""
    var url: String = ""
    var publishedDate: String = ""
    var updateDate: String = ""
    var title: String = ""
    var abstract: String = ""
    var section: String = ""
    var subsection: String = ""
    var source: String = ""
    var media: [Media] = [Media]()
    
    
    enum CodingKeys: String,CodingKey{
        case url , title , abstract , media , id , type , byline , section , subsection , source
        case publishedDate = "published_date"
        case updateDate = "updated"
    }
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

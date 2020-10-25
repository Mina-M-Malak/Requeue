//
//  RequeueTests.swift
//  RequeueTests
//
//  Created by Mina Malak on 10/25/20.
//

import XCTest
@testable import Requeue

class RequeueTests: XCTestCase {
    
    var articleListViewModel = ArticleListViewModel()
    
    func testGetArticles(){
        articleListViewModel.fetchArticlesList()
        sleep(3)
        articleListViewModel.error = {[weak self] (error) in
            XCTAssertNil(error)
        }
        
        articleListViewModel.getArticles = {[weak self] in
            guard let self = self else { return }
            XCTAssertFalse(self.articleListViewModel.getFilteredArticles(searchText: "").isEmpty)
        }
    }
}

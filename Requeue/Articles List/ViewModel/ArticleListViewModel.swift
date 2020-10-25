//
//  ArticleListViewModel.swift
//  Requeue
//
//  Created by Mina Malak on 10/25/20.
//

import Foundation
class ArticleListViewModel{
    
    var error: ((_ error: String)->())?
    var getArticles: (()->())?
    var loading: ((_ isLoad: Bool)->())?
    var articles: [Article] = [Article](){
        didSet{
            self.getArticles?()
        }
    }
    
    func getFilteredArticles(searchText: String) -> [Article]{
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return articles}
        return articles.filter({$0.title.lowercased().contains(searchText.lowercased())})
    }
    
    func fetchArticlesList(){
        loading?(true)
        Network.shared.fetch(with: Requeue.listArticles(period: "30", apiKey: "IeM1hWWs0y8mkj8AY80tUZxAuycOci8O"), model: NYTimesResponse.self) {[weak self] (Result) in
            self?.loading?(false)
            switch Result{
            case .success(let response):
                self?.articles = response.articles
            case .failure(let error):
                self?.error?(error.localizedDescription)
            }
        }
    }
}

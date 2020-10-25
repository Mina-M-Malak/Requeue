//
//  ArticleListViewController.swift
//  Requeue
//
//  Created by Mina Malak on 10/25/20.
//

import UIKit

class ArticleListViewController: BaseViewController {
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    private var searchText: String = ""{
        didSet{
            articlesTableView.reloadData()
        }
    }
    private let viewModel = ArticleListViewModel()
    private let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObservers()
        setupUI()
        viewModel.fetchArticlesList()
    }
    
    private func setupUI(){
        title = "Article List"
        articlesTableView.tableFooterView = UIView()
        self.articlesTableView.refreshControl = self.refresher
        self.refresher.addTarget(self, action: #selector(self.handleRefresher), for: .valueChanged)
        articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    private func setObservers(){
        viewModel.getArticles = {[weak self] in
            self?.articlesTableView.reloadData()
        }
        
        viewModel.error = { [weak self] (message) in
            self?.showAlert(title: "Error", message: message)
        }
        
        viewModel.loading = { [weak self] (isLoad) in
            if isLoad{
                self?.refresher.beginRefreshing()
            }
            else{
                self?.refresher.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArticleDetailsViewController , let article = sender as? Article {
            vc.article = article
        }
    }
    
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .appColor
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.tintColor = .black
        if (!searchText.isEmpty){
            searchController.searchBar.text = searchText
        }
        searchController.hidesNavigationBarDuringPresentation = false
        self.present(searchController,animated: true, completion: nil)
    }
    
    @objc func handleRefresher(){
        viewModel.fetchArticlesList()
    }
}

// MARK:-  Article List TableViewDelegate
extension ArticleListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "articleDetails", sender: viewModel.articles[indexPath.row])
    }
}

// MARK:- Article List TableViewDataSource
extension ArticleListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFilteredArticles(searchText: searchText).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        cell.article = viewModel.getFilteredArticles(searchText: searchText)[indexPath.row]
        return cell
    }
}

// MARK:- SearchBar Delegate
extension ArticleListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (!searchText.trimmingCharacters(in: .whitespaces).isEmpty){
            self.searchText = searchText
        }
        else {
            self.searchText = ""
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
    }
}

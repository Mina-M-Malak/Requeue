//
//  ArticleDetailsViewController.swift
//  Requeue
//
//  Created by Mina Malak on 10/25/20.
//

import UIKit

class ArticleDetailsViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var subsectionLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var article: Article?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        guard let article = article else { return }
        idLabel.text = "\(article.id)"
        titleLabel.text = article.title
        abstractLabel.text = article.abstract
        typeLabel.text = article.type
        byLabel.text = article.byline
        sectionLabel.text = article.section
        subsectionLabel.text = article.subsection
        publishDateLabel.text = article.publishedDate
        updateDateLabel.text = article.updateDate
        sourceLabel.text = article.source
        guard let url = URL(string: article.media.first?.metaData.last?.url ?? "") else { return }
        logoImageView.kf.setImage(with: url)
    }
}

//
//  ArticleTableViewCell.swift
//  Requeue
//
//  Created by Mina Malak on 10/25/20.
//

import UIKit
import Kingfisher

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var article: Article = Article() {
        didSet{
            titleLabel.text = article.title
            descLabel.text = article.abstract
            dateLabel.text = article.publishedDate
            guard let urlString = article.media.first?.metaData.first?.url , let url = URL(string: urlString) else { return }
            articleImageView.kf.setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        articleImageView.layer.cornerRadius = articleImageView.frame.height / 2
    }
}


//
//  SimilarMovieCollectionViewCell.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/18/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit
import SDWebImage
class SimilarMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    var movie : Movie?{
        didSet{
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView(){
        self.posterImageView.layer.cornerRadius = 7
        self.posterImageView.layer.masksToBounds = true
        
    }
    
    private func updateView(){
        guard let movie = movie, let posterPath = movie.posterPath else {return}
        posterImageView.sd_setImage(with: URL(string: Urls.imageURL + posterPath), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        movieTitleLabel.text = movie.title
    }

}

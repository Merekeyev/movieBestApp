//
//  MovieByGenreCollectionViewCell.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/19/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit
import SDWebImage
class MovieByGenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
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
        movieImageView.layer.cornerRadius = 10
        movieImageView.layer.masksToBounds = true
    }

    private func updateView(){
        guard let movie = movie,let posterPath = movie.posterPath else {return}
        movieImageView.sd_setImage(with: URL(string: Urls.imageURL + posterPath), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        movieTitleLabel.text = movie.title
    }
}

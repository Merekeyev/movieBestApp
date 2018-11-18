//
//  MovieTableViewCell.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/18/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    var moviePreview: MoviePreview?{
        didSet{
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    private func setupView(){
        movieImageView.layer.cornerRadius = 10
        movieImageView.layer.masksToBounds = true
    }
    private func updateView(){
        guard let moviePreview = moviePreview, let posterPath = moviePreview.posterPath else {return}
        movieImageView.sd_setImage(with: URL(string: Urls.imageURL + posterPath), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
        movieTitleLabel.text = moviePreview.title
    }
}

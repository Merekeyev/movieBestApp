//
//  DetailMovieTableViewCell.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/18/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit
import SDWebImage
class DetailMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    var closeCompletion : (()->())?
    var movie : Movie?{
        didSet{
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        closeCompletion?()
    }
    
    
    private func updateView(){
        guard let movie = movie , let posterPath = movie.posterPath else {return}
        posterImageView.sd_setImage(with: URL(string: Urls.imageURL + posterPath), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        movieTitleLabel.text = movie.title
        overviewLabel.text = movie.overview
    }
    
}

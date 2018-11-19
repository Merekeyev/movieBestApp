//
//  GenreHeaderCollectionReusableView.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/19/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit

class GenreHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var genreTitleLabel: UILabel!
    var genre : Genre?{
        didSet{
            setupView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView(){
        guard let genre = genre else {return}
        genreTitleLabel.text = genre.name
    }
    
}

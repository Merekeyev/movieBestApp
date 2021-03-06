//
//  GenresTableViewCell.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/19/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    var genre : Genre?{
        didSet{
            setupView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
        // Initialization code
    }

    private func setupView(){
        guard let genre = genre else {return}
        genreLabel.text = genre.name
    }
    
    
}

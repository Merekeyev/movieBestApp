//
//  MovieCollectionViewTableViewCell.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/18/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit

class MovieCollectionViewTableViewCell: UITableViewCell {
    
    enum CellType{
        case similarMovies
        case actors
    }

    @IBOutlet weak var collectionViewSectionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var cellType = CellType.similarMovies{
        didSet{
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "ActorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActorCollectionViewCell")
        collectionView.register(UINib(nibName: "SimilarMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimilarMovieCollectionViewCell")
        
    }

    private func updateView(){
        switch cellType {
        case .actors:
            collectionViewSectionLabel.text = "Cast of the movie"
        case .similarMovies:
            collectionViewSectionLabel.text = "Similar movies"
        }
        self.collectionView.reloadData()
    }
 
   
}



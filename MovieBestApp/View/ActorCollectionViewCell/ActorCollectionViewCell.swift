//
//  ActorCollectionViewCell.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/18/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageVew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var actor : Actor?{
        didSet{
            updateView()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageVew.image = #imageLiteral(resourceName: "placeholder")
        nameLabel.text = actor?.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView(){
        avatarImageVew.layer.cornerRadius = 7
        avatarImageVew.layer.masksToBounds = true
    }
    
    private func updateView(){
        guard let actor = actor, let profilePath = actor.profilePath else {return}
        avatarImageVew.sd_setImage(with: URL(string: Urls.imageURL + profilePath), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        nameLabel.text = actor.name
    }

}

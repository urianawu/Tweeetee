//
//  SearchUserCell.swift
//  TwitterOAuth
//
//  Created by you wu on 2/20/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class SearchUserCell: UICollectionViewCell {
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user: User! {
        didSet {
            profileView.setImageWithURL(user!.profileImageUrl!)
            nameLabel.text = user!.name
            screenNameLabel.text = user!.screenName
            
            profileView.layer.cornerRadius = 4
            profileView.clipsToBounds = true
        }
    }
}

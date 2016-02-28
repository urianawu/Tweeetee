//
//  RetweetCell.swift
//  TwitterOAuth
//
//  Created by you wu on 2/27/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class RetweetCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            if let url = tweet.user?.profileEnlargedImageUrl {
                profileView.setImageWithURL(url)
            }
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = tweet.user?.screenName
            retweetLabel.text = "Retweeted "+tweet.timelineString!

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

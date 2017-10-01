//
//  TweetCell.swift
//  twitter
//
//  Created by Auster Chen on 10/1/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateWithTweet(_ tweet: Tweet) {
        if let user = tweet.user {
            if let name = user.name {
                nameLabel.text = name
            }

            if let handle = user.twitterHandle {
                userNameLabel.text = handle
            }
            
            if let profileUrl = user.profileUrl {
                userProfileImageView.setImageWith(profileUrl)
            }
        }

        if let text = tweet.text {
            tweetTextLabel.text = text
        }

        if let timeago = tweet.postedTimeAgoString {
            timestampLabel.text = timeago
        }
    }
}

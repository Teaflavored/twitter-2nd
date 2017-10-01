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
    @IBOutlet weak var inReplyToView: UIView!
    @IBOutlet weak var inReplyToLabel: UILabel!
    
    @IBOutlet weak var nameToTopSuperviewConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameToReplyToViewConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        inReplyToView.isHidden = true
        nameToReplyToViewConstraint.isActive = false
        nameToTopSuperviewConstraint.isActive = true
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

        if let fullInReplyToString = tweet.fullInReplyToString {
            inReplyToView.isHidden = false
            nameToTopSuperviewConstraint.isActive = false
            nameToReplyToViewConstraint.isActive = true
                inReplyToLabel.text = fullInReplyToString
        } else {
            inReplyToView.isHidden = true
            nameToReplyToViewConstraint.isActive = false
            nameToTopSuperviewConstraint.isActive = true
        }
    }
}

//
//  TweetCell.swift
//  twitter
//
//  Created by Auster Chen on 10/1/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

protocol TweetCellTapDelegate: class {
    func onTap(cell: TweetCell, tweetUser: User)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var inReplyToView: UIView!
    @IBOutlet weak var inReplyToLabel: UILabel!
    
    @IBOutlet weak var replyHeightConstraint: NSLayoutConstraint!
    
    var heightConstraint: NSLayoutConstraint!
    var tweetUser: User!
    weak var delegate: TweetCellTapDelegate?

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
            tweetUser = user

            if let name = user.name {
                nameLabel.text = name
            }

            if let handle = user.twitterHandle {
                userNameLabel.text = handle
            }
            
            if let profileUrl = user.profileUrl {
                userProfileImageView.setImageWith(profileUrl)
            }

            userProfileImageView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            userProfileImageView.addGestureRecognizer(tapGesture)
        }

        if let text = tweet.text {
            tweetTextLabel.text = text
        }

        if let timeago = tweet.postedTimeAgoString {
            timestampLabel.text = timeago
        }

        if let fullInReplyToString = tweet.fullInReplyToString {
            replyHeightConstraint.constant = 30.0
            inReplyToView.isHidden = false
            inReplyToLabel.text = fullInReplyToString
        } else {
            replyHeightConstraint.constant = 0.0
            inReplyToView.isHidden = true
        }
    }

    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.onTap(cell: self, tweetUser: tweetUser)
    }
}

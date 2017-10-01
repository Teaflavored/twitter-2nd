//
//  TweetDetailsViewController.swift
//  twitter
//
//  Created by Auster Chen on 10/1/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var replyButton: UIImageView!
    @IBOutlet weak var retweetButton: UIImageView!
    @IBOutlet weak var tweetTimestampLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = tweet.user {
            if let name = user.name {
                userNameLabel.text = name
            }

            if let handle = user.twitterHandle {
                userHandleLabel.text = handle
            }

            if let profileImageUrl = user.profileUrl {
                userProfileImageView.setImageWith(profileImageUrl)
            }
        }

        if let text = tweet.text {
            tweetBodyLabel.text = text
        }

        if let fullTimeString = tweet.fullTimeString {
            tweetTimestampLabel.text = fullTimeString
        }

        // set up controls
        let retweetGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onRetweet))
        retweetButton.isUserInteractionEnabled = true
        retweetButton.addGestureRecognizer(retweetGestureRecognizer)
        
        let replyGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onReply))
        replyButton.isUserInteractionEnabled = true
        replyButton.addGestureRecognizer(replyGestureRecognizer)
        
        let likeGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLike))
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.addGestureRecognizer(likeGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func onRetweet() {
        print("onTweet")
    }

    @objc fileprivate func onReply() {
        print("onReply")
    }

    @objc fileprivate func onLike() {
        print("onLike")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
    
        if segue.identifier == "replySegue" {
            // Replying we need to set tweet on the reply screen
            let vc = destinationViewController.childViewControllers[0] as! NewTweetViewController
            vc.replyTweet = tweet
        }
    }
}

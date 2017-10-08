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
    @IBOutlet weak var numberRetweetsLabel: UILabel!
    @IBOutlet weak var numberFavoritesLabel: UILabel!
    var tweet: Tweet!
    var lastTappedViewController: UINavigationController!

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
            
            userProfileImageView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            userProfileImageView.addGestureRecognizer(tapGesture)
        }

        if let text = tweet.text {
            tweetBodyLabel.text = text
        }

        if let fullTimeString = tweet.fullTimeString {
            tweetTimestampLabel.text = fullTimeString
        }
    
        numberRetweetsLabel.text = "\(tweet.numberOfRetweets) retweets"
        numberFavoritesLabel.text = "\(tweet.numberOfFavorites) favorites"

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
        TwitterClient.instance.retweet(
            tweet,
            success: {},
            failure: {
                (error: Error) -> () in
            }
        )
    }

    @objc fileprivate func onReply() {
        performSegue(withIdentifier: "replySegue", sender: nil)
    }

    @objc fileprivate func onLike() {
        TwitterClient.instance.like(
            tweet,
            success: {},
            failure: {
                (error: Error) -> () in
        }
        )
    }

    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController") as! UINavigationController
        let pvc = profileViewController.viewControllers[0] as! TimelineViewController
        pvc.targetUser = tweet.user!
        pvc.isProfileView = true
        pvc.title = "Profile"
        lastTappedViewController = profileViewController
        let newBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.handleDismissView(sender:)))
        pvc.navigationItem.leftBarButtonItem = newBarButtonItem
        
        self.present(profileViewController, animated: true, completion: nil)
    }

    @objc fileprivate func handleDismissView(sender: UIBarButtonItem) {
        lastTappedViewController.dismiss(animated: true, completion: nil)
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

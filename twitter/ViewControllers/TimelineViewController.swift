//
//  TimelineViewController.swift
//  twitter
//
//  Created by Auster Chen on 10/1/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tweetsTableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowerLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    var tweets: [Tweet] = []
    var refreshControl: UIRefreshControl!
    var targetUser: User?
    var isProfileView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up dynamic row height for table view
        tweetsTableView.estimatedRowHeight = 100
        tweetsTableView.rowHeight = UITableViewAutomaticDimension

        if isProfileView {
            tweetsTableView.tableHeaderView = profileView
            var userToUse: User!
            
            if let user = targetUser {
                userToUse = user
            } else {
                userToUse = User.currentUser!
            }
            
            if let profileUrl = userToUse.profileUrl {
                userImageView.setImageWith(profileUrl)
            }
            
            numTweetsLabel.text = userToUse.numTweetsString
            numFollowerLabel.text = userToUse.numFollowersString
            numFollowingLabel.text = userToUse.numFollowingString
        } else {
            tweetsTableView.tableHeaderView = nil
        }

        // Set up pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)

        // Set up listening to did post tweet
        NotificationCenter.default.addObserver(
            forName: Tweet.didPostTweetNotificationName,
            object: nil,
            queue: OperationQueue.main,
            using: {
                (NSNotification) in
                self.fetchTimeline()
            }
        )
        
        fetchTimeline()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.instance.logout()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "tweetCell") as? TweetCell else {
            return TweetCell()
        }

        let tweet = tweets[indexPath.row]
        cell.updateWithTweet(tweet)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tweetsTableView.cellForRow(at: indexPath) as! TweetCell
        
        cell.setSelected(false, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    @objc fileprivate func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchTimeline()
    }

    fileprivate func fetchTimeline() -> () {
        if (targetUser == nil) {
            TwitterClient.instance.fetchHomeTimeline(
                success: {
                    (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tweetsTableView.reloadData()
                    self.refreshControl.endRefreshing()
            },
                failure: {
                    (error: Error) in
                    self.refreshControl.endRefreshing()
            }
            )
        } else {
            TwitterClient.instance.fetchTimelineForUser(
                user: targetUser!,
                success: {
                    (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tweetsTableView.reloadData()
                    self.refreshControl.endRefreshing()
            },
                failure: {
                    (error: Error) in
                    self.refreshControl.endRefreshing()
            }
            )
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination

        if let identifier = segue.identifier {
            let cell = sender as! UITableViewCell
            let indexPath = tweetsTableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]

            if identifier == "tweetDetailsSegue" {
                let vc = destinationViewController as! TweetDetailsViewController
                
                vc.tweet = tweet
            }
        }
    }
}

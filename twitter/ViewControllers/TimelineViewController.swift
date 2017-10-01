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
    var tweets: [Tweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up dynamic row height for table view
        tweetsTableView.estimatedRowHeight = 100
        tweetsTableView.rowHeight = UITableViewAutomaticDimension

        TwitterClient.instance.fetchHomeTimeline(
            success: {
                (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tweetsTableView.reloadData()
            },
            failure: {
                (error: Error) in
            }
        )
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

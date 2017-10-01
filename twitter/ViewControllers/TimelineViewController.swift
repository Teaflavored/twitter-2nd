//
//  TimelineViewController.swift
//  twitter
//
//  Created by Auster Chen on 10/1/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    var tweets: [Tweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        TwitterClient.instance.fetchHomeTimeline(
            success: {
                (tweets: [Tweet]) -> () in
                self.tweets = tweets
                
                for tweet in tweets {
                    print(tweet.text)
                }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
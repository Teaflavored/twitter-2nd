//
//  ViewController.swift
//  twitter
//
//  Created by Auster Chen on 9/30/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    let consumerKey: String = "9raxjqpPCTtCv0fOjWindyEUD"
    let consumerSecret: String = "PvKF3XDOBj9i9drzbQ9X1K1ENEs4EyCJH1yvGhYM4oZKBNJwfF"
    let baseUrlString: String = "https://api.twitter.com"
    let oauthRequestTokenUrl = "https://api.twitter.com/oauth/request_token"
    let oauthAuthorizeUrl = "https://api.twitter.com/oauth/authorize"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(_ sender: Any) {
        TwitterClient.instance.login(
            success: {
                () -> () in
                print("logged in")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            },
            failure: {
                (error: Error) -> Void in
            }
        )
    }
}


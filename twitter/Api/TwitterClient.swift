//
//  TwitterClient.swift
//  twitter
//
//  Created by Auster Chen on 9/30/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let consumerKey: String = "9raxjqpPCTtCv0fOjWindyEUD"
    static let consumerSecret: String = "PvKF3XDOBj9i9drzbQ9X1K1ENEs4EyCJH1yvGhYM4oZKBNJwfF"
    static let baseUrl: String = "https://api.twitter.com"
    static let oauthRequestTokenPath = "oauth/request_token"
    static let oauthAuthorizeUrl = "https://api.twitter.com/oauth/authorize?oauth_token="
    static let instance = TwitterClient(baseURL: URL(string: TwitterClient.baseUrl), consumerKey: TwitterClient.consumerKey, consumerSecret: TwitterClient.consumerSecret)!

    func login(success: @escaping () -> Void, error: @escaping (Error?) -> Void) {
        deauthorize()
        fetchRequestToken(
            withPath: TwitterClient.oauthRequestTokenPath,
            method: "GET",
            callbackURL: URL(string: "twitter://oauth"),
            scope: nil,
            success: {
                (requestToken: BDBOAuth1Credential?) in
                print("I got a token")
                let url = URL(string: "\(TwitterClient.oauthAuthorizeUrl)\(requestToken!.token as String)")!
                UIApplication.shared.open(url)
            },
            failure: {
                (error: Error?) in
                    print("error \(error!.localizedDescription)")
            }
        )
    }

    func logout() {
        
    }
}

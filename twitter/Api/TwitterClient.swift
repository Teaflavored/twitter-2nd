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
    // OAUTH related
    static let consumerKey: String = "9raxjqpPCTtCv0fOjWindyEUD"
    static let consumerSecret: String = "PvKF3XDOBj9i9drzbQ9X1K1ENEs4EyCJH1yvGhYM4oZKBNJwfF"
    static let baseUrl: String = "https://api.twitter.com"
    static let oauthRequestTokenPath: String = "oauth/request_token"
    static let oauthAuthorizeUrlPrefix: String = "https://api.twitter.com/oauth/authorize?oauth_token="
    static let accessPath: String = "https://api.twitter.com/oauth/access_token"

    // User related
    static let verifyAccountUrl: String = "1.1/account/verify_credentials.json"

    // Tweet related
    static let homeTimelineUrl: String = "1.1/statuses/home_timeline.json"

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
                let url = URL(string: "\(TwitterClient.oauthAuthorizeUrlPrefix)\(requestToken!.token as String)")!
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

    func checkSession(requestToken: BDBOAuth1Credential, success: @escaping () -> Void, error: @escaping (Error?) -> Void) {
        fetchAccessToken(
            withPath: TwitterClient.accessPath,
            method: "POST",
            requestToken: requestToken,
            success: {
                (accessToken: BDBOAuth1Credential?) in
                print("I got the access token")
                success()
            },
            failure: {
                (err: Error?) in
                print("error \(err!.localizedDescription)")
                error(err)
            }
        )
    }
    
    func fetchCurrentUser() {
        self.get(
            TwitterClient.verifyAccountUrl,
            parameters: nil,
            progress: nil,
            success: {
                (task: URLSessionDataTask, response: Any?) in
                let user = User(dictionary: response as! NSDictionary)
                print(user.name)
                print(user.screename)
                print(user.profileUrl)
                print(user.tagLine)
            },
            failure: {
                (task: URLSessionDataTask?, error: Error) in
                print("error: \(error.localizedDescription)")
            }
        )
    }

    func fetchHomeTimeline() {
        self.get(
            TwitterClient.homeTimelineUrl,
            parameters: nil,
            progress: nil,
            success: {
                (task: URLSessionDataTask, response: Any?) in
                let tweets = Tweet.tweetsWithArray(dictionaries: response as! [NSDictionary])
                
                for tweet in tweets {
                    print(tweet.text)
                    print(tweet.timestamp)
                    print(tweet.numberOfRetweets)
                    print(tweet.numberOfFavorites)
                }
            },
            failure: {
                (task: URLSessionDataTask?, error: Error) in
                print("error: \(error.localizedDescription)")
            }
        )
    }
}

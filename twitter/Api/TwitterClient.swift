//
//  TwitterClient.swift
//  twitter
//
//  Created by Auster Chen on 9/30/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import Foundation
import BDBOAuth1Manager
import Alamofire

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
    static let postStatusUrl: String = "1.1/statuses/update.json"

    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    static let instance = TwitterClient(baseURL: URL(string: TwitterClient.baseUrl), consumerKey: TwitterClient.consumerKey, consumerSecret: TwitterClient.consumerSecret)!

    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure

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
                self.loginFailure?(error!)
            }
        )
    }

    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userDidLogoutNotificationName, object: nil)
    }

    func handleOpenUrl(_ url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        checkSession(
            requestToken: requestToken!,
            success: {
                self.fetchCurrentUser(
                    success: {
                        (user: User) -> () in
                        User.currentUser = user
                        self.loginSuccess?()
                    },
                    failure: {
                        (error: Error) in
                        self.loginFailure?(error)
                    }
                )
            },
            failure: {
                (error: Error) in
                self.loginFailure?(error)
            }
        )
    }

    func checkSession(requestToken: BDBOAuth1Credential, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
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
                (error: Error?) in
                print("error \(error!.localizedDescription)")
                failure(error!)
            }
        )
    }
    
    func fetchCurrentUser(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get(
            TwitterClient.verifyAccountUrl,
            parameters: nil,
            progress: nil,
            success: {
                (task: URLSessionDataTask, response: Any?) in
                let user = User(dictionary: response as! NSDictionary)
                success(user)
            },
            failure: {
                (task: URLSessionDataTask?, error: Error?) in
                print("error: \(error!.localizedDescription)")
                failure(error!)
            }
        )
    }

    func fetchHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get(
            TwitterClient.homeTimelineUrl,
            parameters: nil,
            progress: nil,
            success: {
                (task: URLSessionDataTask, response: Any?) in
                let tweets = Tweet.tweetsWithArray(dictionaries: response as! [NSDictionary])
                success(tweets)
            },
            failure: {
                (task: URLSessionDataTask?, error: Error?) in
                print("error: \(error!.localizedDescription)")
                failure(error!)
            }
        )
    }

    func postStatus(_ status: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let encodedUrl = URLEncoding.default.queryComponents(fromKey: "status", value: status)
        let (key, value) = encodedUrl[0]
        let fullUrl = "\(TwitterClient.postStatusUrl)?\(key)=\(value)"

        post(
            fullUrl,
            parameters: nil,
            progress: nil,
            success: {
                (task: URLSessionDataTask?, response: Any?) in
                NotificationCenter.default.post(name: Tweet.didPostTweetNotificationName, object: nil)
                success()
            },
            failure: {
                (task: URLSessionDataTask?, error: Error) in
                failure(error)
            }
        )
    }
}

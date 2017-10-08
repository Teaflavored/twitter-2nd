//
//  User.swift
//  twitter
//
//  Created by Auster Chen on 9/30/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import Foundation

class User: NSObject {
    static let userDidLogoutNotificationName: NSNotification.Name = NSNotification.Name(rawValue: "UserDidLogout")
    static var _currentUser: User?
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }

            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }

    var numTweets: Int64 = 0
    var numFollowers: Int64 = 0
    var numFollowing: Int64 = 0
    var id: Int64 = 0
    var name: String?
    var screename: String?
    var profileUrl: URL?
    var tagLine: String?
    var dictionary: NSDictionary?
    var twitterHandle: String? {
        get {
            if let screename = screename {
                return "@\(screename)"
            }
            
            return nil
        }
    }
    var numTweetsString: String {
        get {
            return "\(numTweets) tweets"
        }
    }
    var numFollowersString: String? {
        get {
            return "\(numFollowers) followers"
        }
    }
    var numFollowingString: String? {
        get {
            return "following \(numFollowing)"
        }
    }

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id"] as! Int64
        numTweets = dictionary["statuses_count"] as! Int64
        numFollowers = dictionary["followers_count"] as! Int64
        numFollowing = dictionary["friends_count"] as! Int64
        name = dictionary["name"] as? String
        screename = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)!
        }
        tagLine = dictionary["description"] as? String
    }
}

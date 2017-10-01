//
//  Tweet.swift
//  twitter
//
//  Created by Auster Chen on 9/30/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import Foundation
import DateToolsSwift

class Tweet: NSObject {
    static let didPostTweetNotificationName: NSNotification.Name = NSNotification.Name(rawValue: "didPostTweet")
    var text: String?
    var timestamp: Date?
    var numberOfRetweets: Int = 0
    var numberOfFavorites: Int = 0
    var user: User?
    var postedTimeAgoString: String? {
        get {
            if let timestamp = timestamp {
                return timestamp.timeAgoSinceNow
            }

            return nil
        }
    }
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        numberOfRetweets = (dictionary["retweet_count"] as? Int) ?? 0
        numberOfFavorites = (dictionary["favourites_count"] as? Int) ?? 0
        let dateString = dictionary["created_at"] as? String
        let userData = dictionary["user"] as? NSDictionary

        if let userData = userData {
            user = User(dictionary: userData)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        if let dateString = dateString {
            timestamp = formatter.date(from: dateString)
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = []
        
        for dictionary in dictionaries {
            tweets.append(Tweet(dictionary: dictionary))
        }
    
        return tweets
    }
}

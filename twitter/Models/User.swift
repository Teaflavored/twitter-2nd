//
//  User.swift
//  twitter
//
//  Created by Auster Chen on 9/30/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import Foundation

class User: NSObject {
    var name: String?
    var screename: String?
    var profileUrl: URL?
    var tagLine: String?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screename = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)!
        }
        tagLine = dictionary["description"] as? String
    }
}

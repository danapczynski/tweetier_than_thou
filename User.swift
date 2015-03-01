//
//  User.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/20/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var id: Int?
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var profileBackgroundImageUrl: String?
    var profileBackgroundColor: String?
    var tagline: String?
    var followersCount: Int?
    var followingCount: Int?
    var tweetsCount: Int?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        profileBackgroundImageUrl = dictionary["profile_background_image_url"] as? String
        profileBackgroundColor = dictionary["profile_background_color"] as? String
        tagline = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
    }
    
    func hiResProfileUrl() -> String? {
        if self.profileImageUrl != nil {
            return self.profileImageUrl!.stringByReplacingOccurrencesOfString("_normal.png", withString: "_bigger.png")
        } else {
            return nil
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

}

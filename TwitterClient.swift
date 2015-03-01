//
//  TwitterClient.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/19/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = OAuthKeychain.twitterConsumerKey()
let twitterConsumerSecret = OAuthKeychain.twitterConsumerSecret()

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
   
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary]) as [Tweet]
            completion(tweets: tweets, error: nil)

            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Something went wrong while fetching timeline: \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func userTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Successfully fetched user timeline")
            
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary]) as [Tweet]
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Something went wrong while fetching user timeline: \(error)")
        })
    }
    
    func createTweet(params: NSDictionary) -> Void {
        println(params)
        
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Successfully posted tweet")
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Something went wrong while posting tweet: \(error)")
        })
    }
    
    func retweetTweet(id: Int) -> Void {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Successfully retweeted")
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Something went wrong while retweeting tweet: \(error)")
        })
    }
    
    func favoriteTweet(params: NSDictionary) -> Void {
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Successfully favorited tweet")
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Something went wrong while favoriting tweet: \(error)")
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweetierthanthou://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential! ) -> Void in
            println("GOT THE REQUEST")
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authUrl)
        }) { (error: NSError!) -> Void in
                println("Failed to receive request token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: {(accessToken: BDBOAuth1Credential!) -> Void in
        println("GOT THE ACCESS TOKEN")
        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
        
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //                println("user: \(response)")
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                println("user: \(user.name!)")
                self.loginCompletion?(user: user, error: nil)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting current user")
                self.loginCompletion?(user: nil, error: error)
            })
        
        }) { (error: NSError!) -> Void in
            println("failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
}

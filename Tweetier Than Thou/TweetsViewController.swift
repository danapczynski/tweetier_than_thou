//
//  TweetsViewController.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/20/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func onLogout(sender: AnyObject) { User.currentUser?.logout() }
    var tweets: [Tweet]! = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        getHomeViewTweets()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        var tweet = tweets[indexPath.row]
        var user = tweet.user!
        
        cell.delegate = self
        cell.tweetId = tweet.id
        cell.tweetUserHandleLabel.text = "@\(user.screenname!)"
        cell.tweetUserNameLabel.text = user.name
        cell.tweetMessageLabel.text = tweet.text
        cell.tweetUserImage.setImageWithURL(NSURL(string: user.hiResProfileUrl()!))
        cell.tweetTimeLabel.text = TweetTimeFormatter.timeAgoFormat(tweet)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func getHomeViewTweets(){
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    
    func retweet(id: Int) {
        TwitterClient.sharedInstance.retweetTweet(id)
    }
    
    func favorite(id: Int) {
        TwitterClient.sharedInstance.favoriteTweet(["id" : id])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "composeSegue" {
            var vc = segue.destinationViewController as ComposeViewController
            vc.user = User.currentUser!
        } else if segue.identifier == "showTweetSegue" {
            var vc = segue.destinationViewController as TweetViewController
            vc.tweet = tweets[self.tableView.indexPathForCell(sender as TweetCell)!.row]
        } else if segue.identifier == "replySegue" {
            var contentView = sender!.superview!
            var cell = contentView!.superview
            var vc = segue.destinationViewController as ComposeViewController
            var replyToTweet = tweets[self.tableView.indexPathForCell(cell as TweetCell)!.row]
            vc.user = User.currentUser!
            vc.replyToId = replyToTweet.id
            vc.replyUser = replyToTweet.user
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.getHomeViewTweets()
            self.refreshControl.endRefreshing()
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

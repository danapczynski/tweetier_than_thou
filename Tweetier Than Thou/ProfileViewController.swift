//
//  ProfileViewController.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/28/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var user : User!
    var tweets : [Tweet]! = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        getUserViewTweets()
        
        println(self.tweets)
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        switch indexPath.row {
        case 0 : cell = dequeueProfileCell() as ProfileCell!
        default : cell = dequeueTweetCell(indexPath.row) as TweetCell!
        }
        
        return cell!
    }
    
    func dequeueProfileCell() -> ProfileCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as ProfileCell!
        
        cell.profileImageView.setImageWithURL(NSURL(string: user.hiResProfileUrl()!))
        cell.coverImageView.setImageWithURL(NSURL(string: user.profileBackgroundImageUrl!))
        cell.userNameLabel.text = user.name
        cell.userHandleLabel.text = "@\(user.screenname!)"
        cell.userDescriptionLabel.text = user.tagline
        cell.userFollowerCountLabel.text = "\(user.followersCount!)"
        cell.userFollowingCountLabel.text = "\(user.followingCount!)"
        cell.userTweetCountLabel.text = "\(user.tweetsCount!)"
        
        return cell
    }
    
    func dequeueTweetCell(index: Int) -> TweetCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell!
        
        var tweet = tweets[index - 1]
        var user = tweet.user!
        
        cell.delegate = self
        cell.tweetId = tweet.id!
        cell.tweetUserHandleLabel.text = "@\(user.screenname!)"
        cell.tweetUserNameLabel.text = user.name
        cell.tweetMessageLabel.text = tweet.text
        cell.tweetUserImage.setImageWithURL(NSURL(string: user.hiResProfileUrl()!))
        cell.tweetTimeLabel.text = TweetTimeFormatter.timeAgoFormat(tweet)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (1 + self.tweets.count)
    }
    
    func getUserViewTweets() {
        var params: NSDictionary?
        params = [ "user_id" : user.id!, "include_rts" : 1 ]
        TwitterClient.sharedInstance.userTimelineWithParams(params, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
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

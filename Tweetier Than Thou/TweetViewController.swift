//
//  TweetViewController.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/22/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    weak var tweet: Tweet?

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBAction func replyButtonClicked(sender: AnyObject) {
        
    }
    @IBAction func retweetButtonClicked(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetTweet(tweet!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func favoriteButtonClicked(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteTweet(["id": tweet!.id!])
    }
    @IBAction func addButtonClicked(sender: AnyObject) {
        
    }
    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = tweet!.user! as User
        tweetTextLabel.text = tweet!.text
        userNameLabel.text = user.name
        userHandleLabel.text = "@\(user.screenname!)"
        userImage.setImageWithURL(NSURL(string: user.hiResProfileUrl()!))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "replySegue" {
            var vc = segue.destinationViewController as ComposeViewController
            vc.user = User.currentUser!
            vc.replyToId = tweet!.id!
            vc.replyUser = tweet!.user!
        }
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

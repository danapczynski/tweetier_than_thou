//
//  ComposeViewController.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/21/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func cancelTweet(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func clickSubmitButton(sender: AnyObject) {
        submitTweet()
    }
    
    weak var user: User?
    weak var replyUser: User?
    var replyToId: Int?
    
    override func viewDidLoad() {
        
        tweetTextView.text = ""
        tweetTextView.delegate = self
        userNameLabel.text = user!.name
        userHandleLabel.text = "@\(user!.screenname!)"
        userImage.setImageWithURL(NSURL(string: user!.hiResProfileUrl()!))
        setReplyUser()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        var textLength = countElements(textView.text)
        charCountLabel.text = "\(140 - textLength)"
        if textLength > 140 {
            charCountLabel.textColor = UIColor.redColor()
            submitButton.backgroundColor = UIColor.darkGrayColor()
        } else {
            charCountLabel.textColor = UIColor.whiteColor()
            submitButton.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func setReplyUser(){
        if replyUser != nil {
            tweetTextView.text = "@\(replyUser!.screenname!) "
        }
    }
    
    func submitTweet() {
        if (countElements(tweetTextView.text) > 140) { return }
        
        var newTweet: NSDictionary
        
        if replyToId != nil {
            newTweet = [ "status" : tweetTextView.text, "in_reply_to_status_id" : replyToId! ]
        } else {
            newTweet = [ "status" : tweetTextView.text ]
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        TwitterClient.sharedInstance.createTweet(newTweet)
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

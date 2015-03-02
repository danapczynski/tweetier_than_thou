//
//  ComposeViewController.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/21/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

protocol ComposeVCDelegate {
    func cancelCompose()
}

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func cancelTweet(sender: AnyObject) {
        self.delegate!.cancelCompose()
    }
    @IBAction func clickSubmitButton(sender: AnyObject) {
        submitTweet()
    }
    
    weak var user: User?
    weak var replyUser: User?
    var replyToId: Int?
    var delegate: ComposeVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.text = ""
        tweetTextView.delegate = self
        userNameLabel.text = user!.name
        userHandleLabel.text = "@\(user!.screenname!)"
        userImage.setImageWithURL(NSURL(string: user!.hiResProfileUrl()!))
        setReplyUser()
        setInitialCharCount()

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
    
    func setInitialCharCount() {
        if replyUser != nil {
            charCountLabel.text = "\(138 - countElements(replyUser!.screenname!))"
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
        
        TwitterClient.sharedInstance.createTweet(newTweet)
        
        self.delegate!.cancelCompose()
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

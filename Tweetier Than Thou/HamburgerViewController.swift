//
//  HamburgerViewController.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/28/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController, UIGestureRecognizerDelegate, TweetsVCDelegate, ProfileVCDelegate, ComposeVCDelegate {

    var menuWidth : CGFloat?
    var menuViewIsShowing : Bool = false

    class func storyBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    let timelineVC = HamburgerViewController.storyBoard().instantiateViewControllerWithIdentifier("TweetsViewController") as TweetsViewController
    
    let profileVC = HamburgerViewController.storyBoard().instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
    
    let composeVC = HamburgerViewController.storyBoard().instantiateViewControllerWithIdentifier("ComposeViewController") as ComposeViewController

    @IBAction func timelineButtonClicked(sender: UIButton) {
        setContainerView(timelineVC)
    }
    
    @IBAction func profileButtonClicked(sender: UIButton) {
        profileVC.user = User.currentUser!
        profileVC.setting = "user_timeline"
        if profileVC.tableView != nil {
            profileVC.getUserViewTweets()
        }
        setContainerView(profileVC)
    }
    
    @IBAction func mentionsButtonClicked(sender: UIButton) {
        profileVC.user = User.currentUser!
        profileVC.setting = "mentions_timeline"
        if profileVC.tableView != nil {
            profileVC.getMentions()
        }
        setContainerView(profileVC)
    }
    
    func openUserProfile(user: User) {
        profileVC.user = user
        profileVC.setting = "user_timeline"
        if profileVC.tableView != nil {
            profileVC.getUserViewTweets()
        }
        setContainerView(profileVC)
    }
    
    func compose() {
        setContainerView(composeVC)
    }
    
    func reply(tweetId: Int) {
        composeVC.replyToId = tweetId
        setContainerView(composeVC)
    }
    
    func cancelCompose() {
        setContainerView(timelineVC)
    }
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var leftGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var rightGestureRecognizer: UISwipeGestureRecognizer!

    @IBAction func
    menuSwipeRight(sender: UISwipeGestureRecognizer) {
        animateMenuDisplay()
    }

    @IBAction func menuSwipeLeft(sender: UISwipeGestureRecognizer) {
        animateMenuHide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftGestureRecognizer.delegate = self
        rightGestureRecognizer.delegate = self
        addGestureRecognizers()
        
        menuWidth = menuView.frame.width
        
        timelineVC.delegate = self
        timelineVC.view.frame = containerView.bounds
        profileVC.delegate = self
        composeVC.user = User.currentUser
        composeVC.delegate = self

        setContainerView(timelineVC)
        // Do any additional setup after loading the view.
    }
    
    func setContainerView(vc: UIViewController) {
        animateMenuHide()
        for view in self.containerView.subviews {
            view.removeFromSuperview()
        }
        self.containerView.addSubview(vc.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGestureRecognizers() {
        containerView.addGestureRecognizer(leftGestureRecognizer)
        containerView.addGestureRecognizer(rightGestureRecognizer)
    }
    
    func animateMenuDisplay() {
        if menuViewIsShowing { return }
        
        UIView.animateWithDuration(0.2, animations: {
            self.menuView.frame.offset(dx: self.menuWidth!, dy: 0)
            self.containerView.frame.offset(dx: self.menuWidth!, dy: 0)
        })
        
        menuViewIsShowing = true
    }
    
    func animateMenuHide() {
        if !menuViewIsShowing { return }
        
        UIView.animateWithDuration(0.2, animations: {
            self.menuView.frame.offset(dx: -(self.menuWidth!), dy: 0)
            self.containerView.frame.offset(dx: -(self.menuWidth!), dy: 0)
        })
        
        menuViewIsShowing = false
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

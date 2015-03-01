//
//  ProfileViewController.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/28/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.datasource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        switch indexPath.row {
        case 1 : cell = dequeueProfileCell() as ProfileCell!
        default : cell = dequeueTweetCell(indexPath.row) as TweetCell!
        }
        
        return cell!
    }
    
    func dequeueProfileCell() -> ProfileCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as ProfileCell!
        
        return cell
    }
    
    func dequeueTweetCell(index: Int) -> TweetCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell!
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
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

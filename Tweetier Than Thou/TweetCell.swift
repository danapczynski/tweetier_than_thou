//
//  TweetCell.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/20/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

protocol TweetCellDelegate : class {
    func tweetUserProfile(recognizer: UITapGestureRecognizer)
    func retweet(id: Int)
    func favorite(id: Int)
    func reply(id: Int)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetUserHandleLabel: UILabel!
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetMessageLabel: UILabel!
    @IBOutlet weak var tweetUserImage: UIImageView!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    
    var tweetId: Int?
    weak var delegate: TweetCellDelegate?
    
    @IBAction func retweetButtonClicked(sender: AnyObject) {
        delegate!.retweet(tweetId!)
    }
    
    @IBAction func favoriteButtonClicked(sender: AnyObject) {
        delegate!.favorite(tweetId!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

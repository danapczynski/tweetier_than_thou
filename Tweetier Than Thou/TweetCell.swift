//
//  TweetCell.swift
//  Tweetier Than Thou
//
//  Created by Daniel Apczynski on 2/20/15.
//  Copyright (c) 2015 Dan Apczynski. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetUserHandleLabel: UILabel!
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetMessageLabel: UILabel!
    @IBOutlet weak var tweetUserImage: UIImageView!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

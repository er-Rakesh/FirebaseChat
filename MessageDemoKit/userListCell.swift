//
//  userlistCell.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 01/03/23.
//

import UIKit

class userlistCell: UITableViewCell {

    @IBOutlet weak var Imageview: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        messageView.clipsToBounds = true
        messageView.layer.cornerRadius = 20
        messageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]//[.layerMaxXMinYCorner, .layerMinXMinYCorner]

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

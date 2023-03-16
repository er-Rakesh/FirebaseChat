//
//  ChatMessageLeftCell.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 08/03/23.
//

import UIKit

class ChatMessageLeftCell: UITableViewCell {

    @IBOutlet weak var imgUserLeft:UIImageView!
    @IBOutlet weak var lblTimeLeft:UILabel!
    @IBOutlet weak var lblMessageLeft:UILabel!
    //@IBOutlet weak var imgTriangleLeft:UIImageView!
    
    @IBOutlet weak var viewLeft: UIView!
    
   
    // @IBOutlet weak var imgTriangleRight:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewLeft.layer.cornerRadius = 10
        viewLeft.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
       
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

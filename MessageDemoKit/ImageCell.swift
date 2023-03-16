//
//  ImageCell.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 28/02/23.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var Image_View: UIImageView!
    @IBOutlet weak var imageTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

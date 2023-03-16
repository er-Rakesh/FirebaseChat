//
//  VideosCell.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 13/03/23.
//

import UIKit
import AVKit
import AVFoundation

class VideosCell: UITableViewCell {

    @IBOutlet weak var Avplayer: PlayerView!
    @IBOutlet weak var videoTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

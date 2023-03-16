//
//  ChatMessageCell.swift
//  AtoZ
//
//  Created by Emizen Tech Subhash on 01/04/22.
//

import UIKit

enum CellType {
    case left, right
}

class ChatMessageCell: UITableViewCell {

     
    @IBOutlet weak var viewRight: UIView!
    
    @IBOutlet weak var imgUserRight:UIImageView!
    @IBOutlet weak var lblTimeRight:UILabel!
    @IBOutlet weak var lblMessageRight:UILabel!
   // @IBOutlet weak var imgTriangleRight:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewRight.layer.cornerRadius = 10
        viewRight.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
    private var type: CellType = .right {
        didSet {
            let rightHidden = type == .left ? true : false

            imgUserRight.isHidden = rightHidden
            lblMessageRight.isHidden = rightHidden
            lblTimeRight.isHidden = rightHidden
            viewRight.isHidden = rightHidden
//
//
//            imgUserRight.sd_setImage(with:URL(string:Helper.shared().getProfileImage()) , placeholderImage: UIImage(named: "AppIcon"))
            imgUserLeft.isHidden = !rightHidden
            lblMessageLeft.isHidden = !rightHidden
            lblTimeLeft.isHidden = !rightHidden
            viewLeft.isHidden = !rightHidden

            //imgUserLeft.sd_setImage(with:  URL(string:""))
        }
    }
    
    private var userImage: String? {
        didSet {
            switch type {
           
            case .left:imgUserLeft.sd_setImage(with: URL(string: userImage ?? ""), placeholderImage: UIImage(named: "groupPlaceholder"))
            case .right:imgUserRight.sd_setImage(with:URL(string:Helper.shared().getProfileImage()), placeholderImage: UIImage(named: "groupPlaceholder"))
           
            }
        }
    }
    
    private var message: String? {
        didSet {
            switch type {
            case .left:
                lblMessageLeft.text = message
                lblMessageRight.text = ""
            case .right:
                lblMessageRight.text = message
                lblMessageLeft.text = ""
            }
        }
    }
    
    private var time: Int64? {
        didSet {
            switch type {
            case .left:
                lblTimeLeft.text = Helper.shared().convertTimeStamp(timeStamp: Double(time!), toTimeFormat: "hh:mm a")
            case .right:
                lblTimeRight.text = Helper.shared().convertTimeStamp(timeStamp: Double(time!), toTimeFormat: "hh:mm a")
            }
        }
    }
    
    func update(type: CellType, message: FireMessage, userImage:String) {
        self.type = type
        self.time = message.sentDate
        self.userImage = userImage
        self.message = message.content
    }
    */
}

//
//  NotificationsTableViewCell.swift
//  OnTime
//
//  
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationsTableViewCell"
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: "NotificationsTableViewCell", bundle: nil)
    }
    
    
}
